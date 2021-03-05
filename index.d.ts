declare module 'react-native-adyen-encrypt' {
    interface CardForm {
        cardNumber: string;
        securityCode: string;
        expiryMonth: string;
        expiryYear: string;
    }

    declare class AdyenEncryptor {
        constructor(adyenPublicKey: string);

        encryptCard(cardForm: CardForm);

        identify(token: String, paymentData: String): Promise<String>;

        challenge(token: String, paymentData: String): Promise<String>;

        redirect(url: String, paymentData: String): Promise<String>;

        getRedirectUrl(): Promise<String>;
    }
}
