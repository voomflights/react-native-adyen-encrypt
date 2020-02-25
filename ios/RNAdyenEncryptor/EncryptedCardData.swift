//
//  VoomEncryptedCardData.swift
//  Voom
//
//  Created by Voom Pair on 8/13/19.
//  Copyright © 2019 Voom. All rights reserved.
//

import Foundation
import Adyen

public struct EncryptedCardData {
  let addressCity: String?
  let addressCountry: String?
  let addressCountryCode: String?
  let addressStreet: String?
  let addressHouseNumber: String?
  let addressState: String?
  let addressZip: String?
  let cardNumber: String?
  let expiryMonth: String?
  let expiryYear: String?
  let securityCode: String?
  let cardNickname: String?
  let name: String?
  let taxIdentifier: String?
  let publicKey: String

  var toJSON: [String: String] {
    let card = CardEncryptor.Card(number: cardNumber, securityCode: securityCode, expiryMonth: expiryMonth, expiryYear: expiryYear)
    let encryptedCard = CardEncryptor.encryptedCard(for: card, publicKey: publicKey)

    var json: [String: String] = [:]
    if let addressCity = addressCity { json["addressCity"] = addressCity }
    if let addressCountry = addressCountry { json["addressCountry"] = addressCountry }
    if let addressCountryCode = addressCountryCode { json["addressCountryCode"] = addressCountryCode }
    if let addressStreet = addressStreet { json["addressStreet"] = addressStreet }
    if let addressHouseNumber = addressHouseNumber { json["addressHouseNumber"] = addressHouseNumber }
    if let addressState = addressState { json["addressState"] = addressState }
    if let addressZip = addressZip { json["addressZip"] = addressZip }
    if let cardNickname = cardNickname { json["cardNickname"] = cardNickname }
    if cardNumber != nil { json["encryptedCardNumber"] = encryptedCard.number }
    if let expiryMonth = expiryMonth {
      json["expiryMonth"] = expiryMonth
      json["encryptedExpiryMonth"] = encryptedCard.expiryMonth
    }
    if let expiryYear = expiryYear {
      json["expiryYear"] = expiryYear
      json["encryptedExpiryYear"] = encryptedCard.expiryYear
    }
    if securityCode != nil { json["encryptedSecurityCode"] = encryptedCard.securityCode }
    if let name = name { json["name"] = name }
    if let taxIdentifier = taxIdentifier { json["taxIdentifier"] = taxIdentifier }

    return json
  }
}
