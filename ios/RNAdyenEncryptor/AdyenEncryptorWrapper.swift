//
//  AdyenEncryptorWrapper.swift
//  Voom
//
//  Created by Voom Pair on 8/13/19.
//  Copyright © 2019 Voom. All rights reserved.
//

import Adyen

@objc public class AdyenEncryptorWrapper: NSObject {
  @objc public var cardNumber: String?
  @objc public var expiryMonth: String?
  @objc public var expiryYear: String?
  @objc public var publicKey: String?
  @objc public var securityCode: String?


  @objc public func encryptCard() {
    guard let publicKey = publicKey else { return } //can't encrypt without an encryption key
    self.encryptCard(number: cardNumber, securityCode: securityCode, expiryMonth: expiryMonth, expiryYear: expiryYear, publicKey: publicKey)
  }

  @objc public func encryptCard(number: String?, securityCode: String?, expiryMonth: String?, expiryYear: String?, publicKey: String) {
    
    let card = CardEncryptor.Card(number: cardNumber, securityCode: securityCode, expiryMonth: expiryMonth, expiryYear: expiryYear)
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
    }
  }
}
