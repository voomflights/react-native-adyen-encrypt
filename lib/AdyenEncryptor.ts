import {NativeModules, NativeEventEmitter} from "react-native"

interface CardForm {
    cardNumber: string
    securityCode: string
    expiryMonth: string
    expiryYear: string
}

interface EncryptedCard {
    encryptedCardNumber: string
    encryptedExpiryMonth: string
    encryptedExpiryYear: string
    encryptedSecurityCode: string
}

const {
    AdyenEncryptor: NativeAdyenEncryptor,
    RNAdyenEventEmitter
} = NativeModules

const SUCCESS_CALLBACK = "AdyenCardEncryptedSuccess"
const ERROR_CALLBACK = "AdyenCardEncryptedError"

class AdyenEncryptor {
    private emitter: NativeEventEmitter

    constructor(private adyenPublicKey: string) {
        this.emitter = new NativeEventEmitter(RNAdyenEventEmitter)
    }

    generatePromise<T>(): Promise<T> {
        return new Promise<T>((resolve, reject) => {
            const successSubscription = this.emitter.addListener(
                SUCCESS_CALLBACK,
                (result: T) => {
                    successSubscription.remove()
                    resolve(result)
                }
            )
            const errorSubscription = this.emitter.addListener(
                ERROR_CALLBACK,
                (result: T) => {
                    errorSubscription.remove()
                    reject(result)
                }
            )
        })
    }

    encryptCard(cardForm: CardForm): Promise<EncryptedCard> {
        const data = {
            ...cardForm,
            publicKey: this.adyenPublicKey
        }
        const promise = this.generatePromise<EncryptedCard>();
        NativeAdyenEncryptor.encryptWithData(data)
        return promise
    }

    identify(token: String, paymentData: String): Promise<String> {
        const promise = this.generatePromise<String>();
        NativeAdyenEncryptor.identify(token, paymentData);
        return promise;
    }

    challenge(token: String, paymentData: String): Promise<String> {
        const promise = this.generatePromise<String>();
        NativeAdyenEncryptor.challenge(token, paymentData);
        return promise;
    }

    redirect(url: String, paymentData: String): Promise<String> {
        const promise = this.generatePromise<String>();
        NativeAdyenEncryptor.redirect(url, paymentData);
        return promise;
    }

    getRedirectUrl(): Promise<String> {
        const promise = this.generatePromise<String>();
        NativeAdyenEncryptor.getRedirectUrl();
        return promise;
    }


}

export default AdyenEncryptor
export {CardForm}
