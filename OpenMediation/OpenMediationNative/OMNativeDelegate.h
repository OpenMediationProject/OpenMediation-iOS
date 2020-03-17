//
//  OMNativeDelegate.h
//  OM SDK
//
//  Copyright 2017 OM Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMNative;
@class OMNativeAd;

NS_ASSUME_NONNULL_BEGIN

/// The methods declared by the OMNativeDelegate protocol allow the adopting delegate to respond to messages from the OMNative class and thus respond to operations such as whether the native ad has been loaded.
@protocol OMNativeDelegate<NSObject>

@optional

/// Sent when an OMNative has been successfully loaded.
- (void)omNative:(OMNative*)native didLoad:(OMNativeAd*)nativeAd;

/// Sent when an OMNative is failed to load.
- (void)omNative:(OMNative*)native didFailWithError:(NSError*)error;

/// Sent immediately before the impression of an OMNative object will be logged.
- (void)omNativeWillExposure:(OMNative*)native;

/// Sent after an ad has been clicked by the person.
- (void)omNativeDidClick:(OMNative*)native;

@end

NS_ASSUME_NONNULL_END
