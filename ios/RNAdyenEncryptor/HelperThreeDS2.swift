//
//  HelperThreeDS2.swift
//  RNAdyen
//
//  Created by Kenneth Castro on 07.08.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import Adyen
import Adyen3DS2

public class HelperThreeDS2: NSObject, ActionComponentDelegate {
    
    let threeDS2Component: ThreeDS2Component = ThreeDS2Component()
    
    public override init() {
        super.init()
        self.threeDS2Component.delegate = self
    }
    
    public func identify(_ fingerprintToken: String?) {
        guard let fingerprintToken = fingerprintToken else { return }
let base64Encoded2 = "eyJkaXJlY3RvcnlTZXJ2ZXJJZCI6IkYwMTMzNzEzMzciLCJkaXJlY3RvcnlTZXJ2ZXJQdWJsaWNLZXkiOiJleUpyZEhraU9pSlNVMEVpTENKbElqb2lRVkZCUWlJc0ltNGlPaUk0VkZCeFprRk9XazR4U1VFemNIRnVNa2RoVVZaaloxZzRMVXBXWjFZME0yZGlXVVJ0WW1kVFkwTjVTa1ZTTjNsUFdFSnFRbVF5YVRCRWNWRkJRV3BWVVZCWFZVeFpVMUZzUkZSS1ltOTFiVkIxYVhWb2VWTXhVSE4yTlRNNFVIQlJSbkV5U2tOYVNFUmthVjg1V1RoVlpHOWhibWxyVTA5NWMyTkhRV3RCVm1KSldIQTVjblZPU20xd1RUQndaMHM1Vkd4SlNXVkhZbEUzWkVKYVIwMU9RVkpMUVhSS2VUWTNkVmx2YlZwWFYwWkJiV3B3TTJkNFNEVnpOemRDUjJ4a2FFOVJVVmxRVEZkeWJEZHlTMHBMUWxVd05tMXRabGt0VUROcGF6azVNbXRQVVRORWFrMDJiSFIyV21OdkxUaEVUMlJDUjBSS1ltZFdSR0ZtYjI5TFVuVk5kMk5VVFhoRGRUUldZV3B5Tm1ReVprcHBWWGxxTlVZemNWQnJZbmc0V0RsNmExYzNVbWx4Vm5vMlNVMXFkRTU0TnpaaWNtZzNhVTlWZDJKaVdtb3hZV0Y2VkcxR1EyeEViMGR5WTJKeE9WODBObmNpZlE9PSIsInRocmVlRFNTZXJ2ZXJUcmFuc0lEIjoiMWVjNDQ3ZTAtZjBhNi00ZTVmLWE2N2MtZjQ0ZmJjNDhkZDEwIn0"
      //  let decodedData = Data(base64Encoded: base64Encoded)!
      //       let decodedString = String(data: decodedData, encoding: .utf8)!
        
        //let decodedData2 = Data(base64Encoded: base64Encoded2)!
          //   let decodedString2 = String(data: decodedData2, encoding: .utf8)!
        
        
        let action = ThreeDS2FingerprintAction(token: fingerprintToken, paymentData: "")
        self.threeDS2Component.handle(action)
    }
    
    public func challenger(_ challengeToken: String?) {
        guard let challengeToken = challengeToken else { return }
        let action = ThreeDS2ChallengeAction(token: challengeToken, paymentData: "")
        self.threeDS2Component.handle(action)
    }
    
    public func didProvide(_ data: ActionComponentData, from component: ActionComponent) {
        print("didProvide",data)
        RNAdyenEventEmitter.sharedInstance().emitEncryptedCard(data)
    }
    
    public func didFail(with error: Error, from component: ActionComponent) {
        var json: [String: String] = [:]
        json["error"] = error.localizedDescription
        let nserror = error as NSError
        if let debugDescription = nserror.userInfo["NSDebugDescription"] as? String {
            json["debugDescription"] = debugDescription
        }
        RNAdyenEventEmitter.sharedInstance().emitEncryptedCardError(json)
    }
    
}
