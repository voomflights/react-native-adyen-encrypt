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
    let cardData = EncryptedCardData(cardNumber: cardNumber,
                                     expiryMonth: expiryMonth,
                                     expiryYear: expiryYear,
                                     securityCode: securityCode,
                                     publicKey: publicKey)
    RNAdyenEventEmitter.sharedInstance().emitEncryptedCard(cardData.toJSON)
  }
}
