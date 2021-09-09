// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

@class OMNative;
@class OMNativeAd;
@class OMNativeAdView;

NS_ASSUME_NONNULL_BEGIN

/// The methods declared by the OMNativeDelegate protocol allow the adopting delegate to respond to messages from the OMNative class and thus respond to operations such as whether the native ad has been loaded.
@protocol OMNativeDelegate<NSObject>

@optional

/// Sent when an OMNative has been successfully loaded.
- (void)omNative:(OMNative*)native didLoad:(OMNativeAd*)nativeAd;

/// Sent when an OMNativeAdView has been successfully loaded.
- (void)omNative:(OMNative*)native didLoadAdView:(OMNativeAdView*)nativeAdView;

/// Sent when an OMNative is failed to load.
- (void)omNative:(OMNative*)native didFailWithError:(NSError*)error;

/// Sent immediately before the impression of an OMNative object will be logged.
- (void)omNative:(OMNative*)native nativeAdDidShow:(OMNativeAd*)nativeAd;

/// Sent after an ad has been clicked by the person.
- (void)omNative:(OMNative*)native nativeAdDidClick:(OMNativeAd*)nativeAd;

@end

NS_ASSUME_NONNULL_END
