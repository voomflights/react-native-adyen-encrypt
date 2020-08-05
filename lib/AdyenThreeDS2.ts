// @ts-ignore
import { NativeModules } from "react-native";

const {
    AdyenThreeDS2: NativeAdyenThreeDS2
} = NativeModules;

class AdyenThreeDS2 {
    identify(fingerprintToken: String): Promise<String> {
        return NativeAdyenThreeDS2.identify(fingerprintToken);
    }
    challenge(challengeToken: String): Promise<String> {
        return NativeAdyenThreeDS2.challenge(challengeToken);
    }
}

export default AdyenThreeDS2;
