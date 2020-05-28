// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

@class OMBanner;

NS_ASSUME_NONNULL_BEGIN

/// The methods declared by the OMBannerDelegate protocol allow the adopting delegate to respond to messages from the OMBanner class and thus respond to operations such as whether the ad has been loaded, the person has clicked the ad.
@protocol OMBannerDelegate<NSObject>

@optional

/// Sent when an ad has been successfully loaded.
- (void)omBannerDidLoad:(OMBanner *)banner;

/// Sent after an OMBanner fails to load the ad.
- (void)omBanner:(OMBanner *)banner didFailWithError:(NSError *)error;

/// Sent immediately before the impression of an OMBanner object will be logged.
- (void)omBannerWillExposure:(OMBanner *)banner;

/// Sent after an ad has been clicked by the person.
- (void)omBannerDidClick:(OMBanner *)banner;

/// Sent when a banner is about to present a full screen content
- (void)omBannerWillPresentScreen:(OMBanner *)banner;

/// Sent after a full screen content has been dismissed.
- (void)omBannerDidDismissScreen:(OMBanner *)banner;

 /// Sent when a user would be taken out of the application context.
- (void)omBannerWillLeaveApplication:(OMBanner *)banner;

@end

NS_ASSUME_NONNULL_END
