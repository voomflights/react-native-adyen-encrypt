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
    return new Promise((resolve, reject) => {
      const adyenSubscription = this.emitter.addListener(
        "AdyenCardEncryptedSuccess",
        result => {
          adyenSubscription.remove()
          resolve(result)
        }
      )
      NativeAdyenEncryptor.encryptWithData(data)
    })
  }
}

export default AdyenEncryptor
export { CardForm }
