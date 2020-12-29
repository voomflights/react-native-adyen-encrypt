declare module 'react-native-adyen-encrypt' {
    interface CardForm {
      cardNumber: string;
      securityCode: string;
      expiryMonth: string;
      expiryYear: string;
    }
  
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    declare class AdyenEncryptor {
      constructor(adyenPublicKey: string);
      encryptCard(cardForm: CardForm);
      identify(token: String, paymentData: String): Promise<any>;
      challenge(token: String, paymentData: String): Promise<String>;
    }
  }
  