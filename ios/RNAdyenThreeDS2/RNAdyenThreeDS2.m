//
//  RNAdyenThreeDS2.m
//  RNAdyen
//
//  Created by Kenneth Castro on 06.08.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RNAdyenThreeDS2.h"
#import <react_native_adyen_encrypt-Swift.h>

@implementation RNAdyenThreeDS2

RCT_EXPORT_MODULE(AdyenThreeDS2);

RCT_REMAP_METHOD(identify, fingerprintToken: (NSString *)fingerprintToken
resolver:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve(@"hallo identify");
}

RCT_REMAP_METHOD(challenge, challengeToken: (NSString *)challengeToken
resolver:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)
{
     resolve(@"hallo challenge");
}

@end

