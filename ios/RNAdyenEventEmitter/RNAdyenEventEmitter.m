//
//  RNAdyenEventEmitter.m
//  Voom
//
//  Created by Voom Pair on 7/31/19.
//  Copyright © 2019 Voom. All rights reserved.
//

#import "RNAdyenEventEmitter.h"

@implementation RNAdyenEventEmitter

RCT_EXPORT_MODULE(RNAdyenEventEmitter)

static RNAdyenEventEmitter *sharedInstance = nil;

+ (RNAdyenEventEmitter *)sharedInstance {
  if (sharedInstance == nil) {
    [RNAdyenEventEmitter allocWithZone:nil];
  }
  return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"AdyenCardEncryptedSuccess", @"AdyenCardEncryptedFailure"];
}

- (void)emitEncryptedCard:(id)body {
  [self sendEventWithName:@"AdyenCardEncryptedSuccess" body:body];
}

- (void)emitFailure:(id)error {
  [self sendEventWithName:@"AdyenCardEncryptedFailure" body:error];
}

@end
