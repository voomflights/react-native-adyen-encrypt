//
//  HelperThreeDS2.swift
//  RNAdyen
//
//  Created by Kenneth Rangel on 07.08.20.
//

import Foundation
import Adyen

let threeDS2ComponentSingleton = ThreeDS2Component()

public class HelperThreeDS2: NSObject, ActionComponentDelegate {
    
    let threeDS2Component: ThreeDS2Component
    
    public override init() {
        threeDS2Component = threeDS2ComponentSingleton
        super.init()
        self.threeDS2Component.delegate = self
    }
    
    public func identify(_ token: String?, _ paymentData: String?) {
        guard let token = token, let paymentData = paymentData else { return }
        let action = ThreeDS2FingerprintAction(token: token, paymentData: paymentData)
        self.threeDS2Component.handle(action)
    }
    
    public func challenger(_ token: String?, _ paymentData: String?) {
        guard let token = token, let paymentData = paymentData else { return }
        let action = ThreeDS2ChallengeAction(token: token, paymentData: paymentData)
        self.threeDS2Component.handle(action)
    }
    
    public func didProvide(_ data: ActionComponentData, from component: ActionComponent) {
    let dictionary = data.details.dictionaryRepresentation;
        if let jsonData = try? JSONSerialization.data( withJSONObject: dictionary,   options: .prettyPrinted  ) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                RNAdyenEventEmitter.sharedInstance().emitEncryptedCard(jsonString)
            }
        }
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
