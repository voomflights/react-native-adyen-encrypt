import { NativeModules, NativeEventEmitter } from "react-native"

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

class AdyenEncryptor {
  private emitter: NativeEventEmitter
  constructor(private adyenPublicKey: string) {
    this.emitter = new NativeEventEmitter(RNAdyenEventEmitter)
  }

  encryptCard(cardForm: CardForm): Promise<EncryptedCard> {
    const data = {
      ...cardForm,
      publicKey: this.adyenPublicKey
    }
    const promise = new Promise<EncryptedCard>((resolve, reject) => {
      const successSubscription = this.emitter.addListener(
        "AdyenCardEncryptedSuccess",
        (result: EncryptedCard) => {
          successSubscription.remove()
          resolve(result)
        }
      )
      const errorSubscription = this.emitter.addListener(
          "AdyenCardEncryptedError",
          (result: EncryptedCard) => {
            errorSubscription.remove()
            reject(result)
          }
      )
      NativeAdyenEncryptor.encryptWithData(data)
    })
    return promise
  }

  identify(token: String, paymentData: String): Promise<any> {
    const promise = new Promise<any>((resolve, reject) => {
        const successSubscription = this.emitter.addListener(
          "AdyenCardEncryptedSuccess",
          (result: any) => {
            successSubscription.remove();
            resolve(result)
          }
        )
        const errorSubscription = this.emitter.addListener(
            "AdyenCardEncryptedError",
            (result: any) => {
              errorSubscription.remove();
              reject(result);
            }
        )
        NativeAdyenEncryptor.identify(token, paymentData);
      });
    return promise;
}

challenge(token: String, paymentData: String): Promise<String> {
    const promise = new Promise<String>((resolve, reject) => {
        const successSubscription = this.emitter.addListener(
          "AdyenCardEncryptedSuccess",
          (result: String) => {
            successSubscription.remove()
            resolve(result)
          }
        );
        const errorSubscription = this.emitter.addListener(
            "AdyenCardEncryptedError",
            (result: String) => {
              errorSubscription.remove()
              reject(result)
            }
        );
        NativeAdyenEncryptor.challenge(token, paymentData);
      });
    return promise;
}

}

export default AdyenEncryptor
export { CardForm }
