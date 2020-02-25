//
//  RNAdyenEncryptor.m
//  Voom
//
//  Created by Voom Pair on 8/13/19.
//  Copyright © 2019 Voom. All rights reserved.
//

#import "RNAdyenEncryptor.h"
#import <react_native_adyen-Swift.h>

@implementation RNAdyenEncryptor

RCT_EXPORT_MODULE(AdyenEncryptor);

RCT_EXPORT_METHOD(encryptWithData: (NSDictionary *)data) {
  NSString *addressCity = [self safeString: data[@"addressCity"]];
  NSString *addressCountry = [self safeString: data[@"addressCountry"]];
  NSString *addressCountryCode = [self safeString: data[@"addressCountryCode"]];
  NSString *addressStreet = [self safeString: data[@"addressStreet"]];
  NSString *addressHouseNumber = [self safeString: data[@"addressHouseNumber"]];
  NSString *addressState = [self safeString: data[@"addressState"]];
  NSString *addressZip = [self safeString: data[@"addressZip"]];
  NSString *cardNickname = [self safeString: data[@"cardNickname"]];
  NSString *cardNumber = [self safeString: data[@"cardNumber"]];
  NSString *expiryMonth = [NSString stringWithFormat:@"%@", data[@"expiryMonth"]];
  NSString *expiryYear = [NSString stringWithFormat:@"%@", data[@"expiryYear"]];
  NSString *name = [self safeString: data[@"name"]];
  NSString *publicKey = [self safeString: data[@"publicKey"]];
  NSString *securityCode = [self safeString: data[@"securityCode"]];
  NSString *taxIdentifier = [self safeString: data[@"taxIdentifier"]];

  AdyenEncryptorWrapper *wrapper = [AdyenEncryptorWrapper new];
  wrapper.addressCity = addressCity;
  wrapper.addressCountry = addressCountry;
  wrapper.addressCountryCode = addressCountryCode;
  wrapper.addressStreet = addressStreet;
  wrapper.addressHouseNumber = addressHouseNumber;
  wrapper.addressState = addressState;
  wrapper.addressZip = addressZip;
  wrapper.cardNickname = cardNickname;
  wrapper.cardNumber = cardNumber;
  wrapper.expiryMonth = expiryMonth;
  wrapper.expiryYear = expiryYear;
  wrapper.name = name;
  wrapper.publicKey = publicKey;
  wrapper.securityCode = securityCode;
  wrapper.taxIdentifier = taxIdentifier;

  [wrapper encryptCard];
}

- (NSString *)safeString:(id)object {
  if ([object isKindOfClass:[NSString class]]) {
    return (NSString *)object;
  } else if ([object isKindOfClass:[NSNull class]]) {
    return nil;
  } else {
    return [NSString stringWithFormat:@"%@", object];
  }
}

@end
