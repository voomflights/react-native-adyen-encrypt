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
    let successSubscription: any
    let failureSubscription: any
    const promise = new Promise<EncryptedCard>((resolve, reject) => {
      successSubscription = this.emitter.addListener(
        "AdyenCardEncryptedSuccess",
        (result: EncryptedCard) => {
          resolve(result)
        }
      )
      failureSubscription = this.emitter.addListener(
        "AdyenCardEncryptedFailure",
        error => {
          reject(error)
        }
      )
      NativeAdyenEncryptor.encryptWithData(data)
    })
    promise.finally(() => {
      successSubscription.remove()
      failureSubscription.remove()
    })
    return promise
  }
}

export default AdyenEncryptor
export { CardForm }
