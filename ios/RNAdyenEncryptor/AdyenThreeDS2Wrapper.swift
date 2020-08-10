//
//  AdyenThreeDS2Wrapper.swift
//  Quarters
//
//  Created by Kenneth Rangel on 06.08.20.
//

@objc public class AdyenThreeDS2Wrapper: NSObject {
    @objc public func identify(_ fingerprintToken: String?) {
        guard let fingerprintToken = fingerprintToken else { return }
        let helper = HelperThreeDS2()
        helper.identify(fingerprintToken)
     } 
    @objc public func challenger(_ challengeToken: String?) {
        guard let challengeToken = challengeToken else { return }
        let helper = HelperThreeDS2()
        helper.challenger(challengeToken)
     }
}
