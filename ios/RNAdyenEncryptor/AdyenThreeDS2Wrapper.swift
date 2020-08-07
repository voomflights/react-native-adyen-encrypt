//
//  AdyenThreeDS2Wrapper.swift
//  Adyen
//
//  Created by Kenneth Castro on 06.08.20.
//

import Adyen3DS2

@objc public class AdyenThreeDS2Wrapper: NSObject {
    
    @objc public func identify(fingerprintToken: String?, resolve: RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {

       guard let fingerprintToken = fingerprintToken else { return }
      let helper = HelperThreeDS2()
      resolve("caca")
     }
    
    @objc public func challenger(challengeToken: String?, resolve: RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {

       guard let challengeToken = challengeToken else { return }
     let helper = HelperThreeDS2()
        resolve("caca")
     }
    
}
