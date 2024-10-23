//
//  TimerEventEmitter.m
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 30/01/2024.
//

/*
 * Event Emitter Bridge: Objective-C declaration of the event emitter
 * - Exposes the Swift TimerEventEmitter to React Native
 * - Required for the React Native bridge to recognize the event emitter
 */

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(TimerEventEmitter, RCTEventEmitter)

+ (bool)requiresMainQueueSetup {
  return NO;
}

RCT_EXTERN_METHOD(supportedEvents)

@end
