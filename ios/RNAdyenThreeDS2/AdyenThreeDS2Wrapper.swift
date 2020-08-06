//
//  AdyenThreeDS2Wrapper.swift
//  Adyen
//
//  Created by Kenneth Castro on 06.08.20.
//

import Adyen3DS2

@objc public class AdyenThreeDS2Wrapper: NSObject {
 

    @objc public func identify(finger: String?) {
    
   /* let card = CardEncryptor.Card(number: cardNumber, securityCode: securityCode, expiryMonth: expiryMonth, expiryYear: expiryYear)
    var json: [String: String] = [:]
    do {
        let encryptedCard = try CardEncryptor.encryptedCard(for: card, publicKey: publicKey)

        if cardNumber != nil { json["encryptedCardNumber"] = encryptedCard.number }
        if expiryMonth != nil { json["encryptedExpiryMonth"] = encryptedCard.expiryMonth }
        if expiryYear != nil { json["encryptedExpiryYear"] = encryptedCard.expiryYear }
        if securityCode != nil { json["encryptedSecurityCode"] = encryptedCard.securityCode }
        RNAdyenEventEmitter.sharedInstance().emitEncryptedCard(json)
    } catch {
        json["error"] = error.localizedDescription
        RNAdyenEventEmitter.sharedInstance().emitEncryptedCardError(json)
    }*/
  }
}
