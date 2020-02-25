//
//  RNAdyenEventEmitter.h
//  Voom
//
//  Created by Voom Pair on 7/31/19.
//  Copyright © 2019 Voom. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNAdyenEventEmitter : RCTEventEmitter <RCTBridgeModule>

+ (RNAdyenEventEmitter *)sharedInstance;
- (void)emitEncryptedCard:(id)body;
- (void)emitFailure:(id)error;

@end

NS_ASSUME_NONNULL_END
