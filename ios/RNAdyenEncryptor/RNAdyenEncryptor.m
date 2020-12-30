//
//  RNAdyenEncryptor.m
//  Voom
//
//  Created by Voom Pair on 8/13/19.
//  Copyright © 2019 Voom. All rights reserved.
//

#import "RNAdyenEncryptor.h"
#import <react_native_adyen_encrypt-Swift.h>

@implementation RNAdyenEncryptor

RCT_EXPORT_MODULE(AdyenEncryptor);

RCT_EXPORT_METHOD(encryptWithData: (NSDictionary *)data) {
  NSString *cardNumber = [self safeString: data[@"cardNumber"]];
  NSString *expiryMonth = [NSString stringWithFormat:@"%@", data[@"expiryMonth"]];
  NSString *expiryYear = [NSString stringWithFormat:@"%@", data[@"expiryYear"]];
  NSString *publicKey = [self safeString: data[@"publicKey"]];
  NSString *securityCode = [self safeString: data[@"securityCode"]];

  AdyenEncryptorWrapper *wrapper = [AdyenEncryptorWrapper new];
  wrapper.cardNumber = cardNumber;
  wrapper.expiryMonth = expiryMonth;
  wrapper.expiryYear = expiryYear;
  wrapper.publicKey = publicKey;
  wrapper.securityCode = securityCode;

  [wrapper encryptCard];
}

RCT_EXPORT_METHOD(identify: (NSString*)token setPaymentData:(NSString*)paymentData) {
    AdyenThreeDS2Wrapper *wrapper = [AdyenThreeDS2Wrapper new];
    [wrapper identify:token paymentData:paymentData];
}

RCT_EXPORT_METHOD(challenge: (NSString*)token setPaymentData:(NSString*)paymentData) {
    AdyenThreeDS2Wrapper *wrapper = [AdyenThreeDS2Wrapper new];
    [wrapper challenger:token paymentData:paymentData];
}

RCT_EXPORT_METHOD(redirect: (NSString*)url setPaymentData:(NSString*)paymentData) {
    AdyenThreeDS2Wrapper *wrapper = [AdyenThreeDS2Wrapper new];
    [wrapper redirect:url paymentData:paymentData];
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
