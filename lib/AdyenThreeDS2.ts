// @ts-ignore
import { NativeModules, NativeEventEmitter } from "react-native";

const {
  AdyenEncryptor: NativeAdyenEncryptor,
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
        "AdyenCardEncryptedSuccess",
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
      NativeAdyenEncryptor.identify(fingerprintToken);
    })
    return promise;
  }
}

export default AdyenThreeDS2;
