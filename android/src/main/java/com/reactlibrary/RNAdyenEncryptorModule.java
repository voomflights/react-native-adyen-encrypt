package com.reactlibrary;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.Observer;

import com.adyen.checkout.base.ActionComponentData;
import com.adyen.checkout.base.ComponentError;
import com.adyen.checkout.base.model.payments.response.Action;
import com.adyen.checkout.base.model.payments.response.Threeds2ChallengeAction;
import com.adyen.checkout.base.model.payments.response.Threeds2FingerprintAction;
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

import org.jdeferred2.Deferred;
import org.jdeferred2.DoneCallback;
import org.jdeferred2.FailCallback;
import org.jdeferred2.impl.DeferredObject;
import org.json.JSONObject;

import com.adyen.checkout.adyen3ds2.Adyen3DS2Component;


public class RNAdyenEncryptorModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNAdyenEncryptorModule(ReactApplicationContext reactContext) {
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

    private Adyen3DS2Component authenticator;
    private Callback callback;

    private interface Callback {
        void onSuccess(ActionComponentData data);
        void onError(ComponentError error);
    }
    private Deferred<Adyen3DS2Component, Throwable, Void> getAuthenticator(Callback callback) {
        final Deferred<Adyen3DS2Component, Throwable, Void> deferred = new DeferredObject<>();

        this.callback = callback;

        if (authenticator == null) {
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    try {
                        final Activity activity = getCurrentActivity();

                        if (activity == null) {
                            deferred.reject(null);
                        }

                        final FragmentActivity fragmentActivity = (FragmentActivity) activity;
                        authenticator = Adyen3DS2Component.PROVIDER.get(fragmentActivity);

                        authenticator.observe(fragmentActivity, new Observer<ActionComponentData>() {
                            @Override
                            public void onChanged(@Nullable ActionComponentData actionComponentData) {
                                RNAdyenEncryptorModule.this.callback.onSuccess(actionComponentData);
                            }
                        });

                        authenticator.observeErrors(fragmentActivity, new Observer<ComponentError>() {
                            @Override
                            public void onChanged(@Nullable ComponentError componentError) {
                                RNAdyenEncryptorModule.this.callback.onError(componentError);
                            }
                        });
                        deferred.resolve(authenticator);
                    } catch (Throwable e) {
                        deferred.reject(e);
                    }
                }
            });
        } else {
            deferred.resolve(authenticator);
        }
        return deferred;
    }

    private void dispatchAction(final Action action, final String resultKey) {
        getAuthenticator(new Callback() {
            @Override
            public void onSuccess(ActionComponentData data) {
                final JSONObject details = data.getDetails();
                final String result = details.optString(resultKey);
                if (!result.isEmpty()){
                    reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedSuccess", details.toString());
                }else{
                    reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedError","String is empty?");
                }
            }

            @Override
            public void onError(ComponentError error) {
                reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedError", error.getErrorMessage());
            }
        }).then(new DoneCallback<Adyen3DS2Component>() {
            @Override
            public void onDone(Adyen3DS2Component authenticator) {
                if (authenticator == null) {
                    reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedError", "activity is null");
                    return;
                }

                final Activity activity = getCurrentActivity();
                authenticator.handleAction(activity, action);
            }
        }, new FailCallback<Throwable>() {
            @Override
            public void onFail(Throwable result) {
                if (result != null) {
                    reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedError", result.toString());
                } else {
                    reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedError", "error null");
                }

            }
        });
    }

    @ReactMethod
    public void identify(final String token, final String paymentData) {
        Threeds2FingerprintAction action = new Threeds2FingerprintAction();
        action.setToken(token);
        action.setType(Threeds2FingerprintAction.ACTION_TYPE);
        dispatchAction(action, "threeds2.fingerprint");
    }

    @ReactMethod
    public void challenge(final String token, final String paymentData) {
        Threeds2ChallengeAction action = new Threeds2ChallengeAction();
        action.setToken(token);
        action.setType(Threeds2ChallengeAction.ACTION_TYPE);
        dispatchAction(action, "threeds2.challengeResult");
    }

}
