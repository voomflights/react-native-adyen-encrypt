// @ts-ignore
import { NativeModules, NativeEventEmitter } from "react-native";

const {
    AdyenThreeDS2: NativeAdyenThreeDS2,
  RNAdyenEventEmitter
} = NativeModules;

class AdyenThreeDS2 {
  private emitter: NativeEventEmitter
  constructor() {
    this.emitter = new NativeEventEmitter(RNAdyenEventEmitter);
  }

  identify(fingerprintToken: String): Promise<String> {
    // @ts-ignore
    const promise = new Promise<String>((resolve, reject) => {
      const successSubscription = this.emitter.addListener(
        "threeds2.fingerprint",
        (result: String) => {
          successSubscription.remove();
          resolve(result);
        }
      );
      const errorSubscription = this.emitter.addListener(
          "AdyenCardEncryptedError",
          (result: String) => {
            errorSubscription.remove()
            reject(result)
          }
      );
      console.log('NativeAdyenThreeDS2',NativeAdyenThreeDS2)
        NativeAdyenThreeDS2.identify(fingerprintToken);

    })
    return promise;
  }
}

export default AdyenThreeDS2;
