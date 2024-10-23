/*
 * Objective-C Bridge: Exposes Swift TimerWidgetModule methods to React Native
 * - Declares which native methods can be called from JavaScript
 * - Acts as the connection point between React Native and Swift code
 * - Required because React Native bridge needs Objective-C declarations
 */

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(TimerWidgetModule, NSObject)

+ (BOOL)requiresMainQueueSetup {
  return NO;
}

RCT_EXTERN_METHOD(startLiveActivity:(nonnull double)timestamp)
RCT_EXTERN_METHOD(pause:(nonnull double)timestamp)
RCT_EXTERN_METHOD(resume)
RCT_EXTERN_METHOD(stopLiveActivity)
RCT_EXTERN_METHOD(getCurrentState:(RCTResponseSenderBlock)callback)

@end
