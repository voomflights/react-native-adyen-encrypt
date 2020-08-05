package com.reactlibrary;

import android.app.Activity;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.Observer;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;


import com.adyen.checkout.adyen3ds2.Adyen3DS2Component;
import com.adyen.checkout.base.ActionComponentData;
import com.adyen.checkout.base.ComponentError;
import com.adyen.checkout.base.model.payments.response.Action;
import com.adyen.checkout.base.model.payments.response.Threeds2ChallengeAction;
import com.adyen.checkout.base.model.payments.response.Threeds2FingerprintAction;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import android.os.Handler;
import android.os.Looper;
import androidx.fragment.app.Fragment;
import android.util.Log;

import org.jdeferred2.Deferred;
import org.jdeferred2.DoneCallback;
import org.jdeferred2.FailCallback;
import org.jdeferred2.impl.DeferredObject;
import org.json.JSONObject;


public class RNAdyenThreeDS2Module extends ReactContextBaseJavaModule implements LifecycleOwner{

    private final ReactApplicationContext reactContext;

    public RNAdyenThreeDS2Module(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "AdyenThreeDS2";
    }

    private Adyen3DS2Component authenticator;

    private Callback callback;

    @NonNull
    @Override
    public Lifecycle getLifecycle() {
        return null;
    }

    private interface Callback {
        void onSuccess(ActionComponentData data);

        void onError(ComponentError error);
    }
/*
    private Adyen3DS2Component getAuthenticator (Callback callback){

        this.callback = callback;

        if (authenticator == null) {
            try {
                final Activity activity = getCurrentActivity();

                if (activity == null) {
                    return null;
                }
                final FragmentActivity fragmentActivity = (FragmentActivity) activity;
                authenticator = Adyen3DS2Component.PROVIDER.get(fragmentActivity);

                authenticator.observe(this, new Observer<ActionComponentData>() {
                    @Override
                    public void onChanged(@Nullable ActionComponentData actionComponentData) {
                        RNAdyenThreeDS2Module.this.callback.onSuccess(actionComponentData);
                    }
                });

                authenticator.observeErrors(this, new Observer<ComponentError>() {
                    @Override
                    public void onChanged(@Nullable ComponentError componentError) {
                        RNAdyenThreeDS2Module.this.callback.onError(componentError);
                    }
                });
            }
            catch (Throwable e){
                return  null;
            }
        }
        return authenticator;
    }*/

    private Deferred<Adyen3DS2Component, Throwable, Void> getAuthenticator(Callback callback) {
        final Deferred<Adyen3DS2Component, Throwable, Void> deferred = new DeferredObject<>();

        this.callback = callback;

        final RNAdyenThreeDS2Module me = this;
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
                                RNAdyenThreeDS2Module.this.callback.onSuccess(actionComponentData);
                            }
                        });

                        authenticator.observeErrors(fragmentActivity, new Observer<ComponentError>() {
                            @Override
                            public void onChanged(@Nullable ComponentError componentError) {
                                RNAdyenThreeDS2Module.this.callback.onError(componentError);
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


    private void dispatchAction(final Action action, final String resultKey, final Promise promise) {
        getAuthenticator(new Callback() {
            @Override
            public void onSuccess(ActionComponentData data) {
                Log.d("moduleRek","onSuccess");
                final JSONObject details = data.getDetails();
                final String result = details.optString(resultKey);

                Log.d("moduleRek","onSuccess " + result);
              //  if (!TextUtils.isEmpty(result)) {
                    promise.resolve(result);
               // }
            }

            @Override
            public void onError(ComponentError error) {

                Log.d("moduleRek","ComponentError");
             //   ReadableMap readableError = fromThrowable(error.getException());
                promise.reject("xxx", error.getErrorMessage(), error.getException());
            }
        }).then(new DoneCallback<Adyen3DS2Component>() {
            @Override
            public void onDone(Adyen3DS2Component authenticator) {
                if (authenticator == null) {
                    promise.reject(getName(), "activity is null");
                    return;
                }

                final Activity activity = getCurrentActivity();
                authenticator.handleAction(activity, action);
            }
        }, new FailCallback<Throwable>() {
            @Override
            public void onFail(Throwable result) {

                Log.d("moduleRek","onFail" + result.toString());
               /* ReadableMap error = fromThrowable(result);
                if (error != null) {
                    promise.reject(error.getString("code"), error.getString("message"), result);
                } else {
                    promise.resolve(null);
                }*/

            }
        });
    }

    @ReactMethod
    public void identify(final String fingerprintToken, final Promise promise) {
        Log.d("moduleRek",fingerprintToken);
       Threeds2FingerprintAction action = new Threeds2FingerprintAction();

        action.setToken(fingerprintToken);
        action.setType(Threeds2FingerprintAction.ACTION_TYPE);

        dispatchAction(action, "threeds2.fingerprint", promise);

        /*reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("AdyenCardEncryptedSuccess", "xxx");

        promise.resolve("holaa");*/

      //  reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("threeds2.fingerprint", "caquita1000");

    }

    @ReactMethod
    public void challenge(final String challengeToken, final Integer challengeTimeOut, final Promise promise) {

        Threeds2ChallengeAction action = new Threeds2ChallengeAction();

        action.setToken(challengeToken);
        action.setType(Threeds2ChallengeAction.ACTION_TYPE);

        dispatchAction(action, "threeds2.challengeResult", promise);
    }

    /*
    @ReactMethod
    public void identify(final String fingerprintToken, final Promise promise) {
        Threeds2FingerprintAction action = new Threeds2FingerprintAction();

        action.setToken(fingerprintToken);
        action.setType(Threeds2FingerprintAction.ACTION_TYPE);

        dispatchAction(action, "threeds2.fingerprint", promise);
    }*/
}

