import { NativeModules } from "react-native"

interface CardForm {
  cardNumber: string
  securityCode: string
  expiryMonth: string
  expiryYear: string
}

const { AdyenEncryptor: NativeAdyenEncryptor } = NativeModules

class AdyenEncryptor {
  constructor(private adyenPublicKey: string) {}

  encryptCard(cardForm: CardForm) {
    const data = {
      ...cardForm,
      publicKey: this.adyenPublicKey
    }
    NativeAdyenEncryptor.encryptWithData(data)
  }
}

export default AdyenEncryptor
export { CardForm }
