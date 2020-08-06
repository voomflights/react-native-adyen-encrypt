//
//  AdyenThreeDS2Wrapper.swift
//  Adyen
//
//  Created by Kenneth Castro on 06.08.20.
//

import Adyen3DS2

@objc public class AdyenThreeDS2Wrapper: NSObject {
    
    @objc public func identify(fingerprintToken: String?, resolve: RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
       
     
      resolve("caca")
     }
    @objc public func challenger(challengeToken: String?, resolve: RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
       
     
        resolve("caca")
     }
    
}
