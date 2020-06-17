package com.reactlibrary;

import com.adyen.checkout.cse.Card;
import com.adyen.checkout.cse.CardEncryptor;
import com.adyen.checkout.cse.EncryptedCard;
import com.adyen.checkout.cse.internal.CardEncryptorImpl;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;


public class RNAdyenModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNAdyenModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "AdyenEncryptor";
    }

    @ReactMethod
    public void encryptWithData(ReadableMap cardData) throws Exception {
        String cardNumber = cardData.getString("cardNumber");
        String securityCode = cardData.getString("securityCode");
        String expiryMonth = cardData.getString("expiryMonth");
        String expiryYear = cardData.getString("expiryYear");
        String publicKey = cardData.getString("publicKey");
        WritableNativeMap encryptedCardMap = new WritableNativeMap();

        try {
            CardEncryptor encryptor = new CardEncryptorImpl();
            Card card = new Card.Builder()
                    .setNumber(cardNumber)
                    .setSecurityCode(securityCode)
                    .setExpiryDate(Integer.parseInt(expiryMonth), Integer.parseInt(expiryYear))
                    .build();
            EncryptedCard encryptedCard = encryptor.encryptFields(card, publicKey);

            encryptedCardMap.putString("encryptedCardNumber", encryptedCard.getEncryptedNumber());
            encryptedCardMap.putString("encryptedSecurityCode", encryptedCard.getEncryptedSecurityCode());
            encryptedCardMap.putString("encryptedExpiryMonth", encryptedCard.getEncryptedExpiryMonth());
            encryptedCardMap.putString("encryptedExpiryYear", encryptedCard.getEncryptedExpiryYear());
        } catch (Exception e) {
            encryptedCardMap.putString("error", e.toString());
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedError", encryptedCardMap);
        }

        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedSuccess", encryptedCardMap);
    }
}
