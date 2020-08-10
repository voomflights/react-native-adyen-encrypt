//
//  HelperThreeDS2.swift
//  RNAdyen
//
//  Created by Kenneth Rangel on 07.08.20.
//

import Foundation
import Adyen

public class HelperThreeDS2: NSObject, ActionComponentDelegate {
    
    let threeDS2Component: ThreeDS2Component
    
    public override init() {
        threeDS2Component = ThreeDS2Component()
        super.init()
        self.threeDS2Component.delegate = self
    }
    
    public func identify(_ token: String?) {
        guard let token = token else { return }
        let action = ThreeDS2FingerprintAction(token: token, paymentData: "")
        self.threeDS2Component.handle(action)
    }
    
    public func challenger(_ token: String?) {
        guard let token = token else { return }
        let action = ThreeDS2ChallengeAction(token: token, paymentData: "")
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
