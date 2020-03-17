// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingBannerClass_h
#define OMAdTimingBannerClass_h

@class AdTimingBanner;

NS_ASSUME_NONNULL_BEGIN

/// Banner Ad Size
typedef NS_ENUM(NSInteger, AdTimingBannerType) {
    AdTimingBannerTypeDefault = 0,       ///ad size: 320 x 50
    AdTimingBannerTypeLarge = 1,         ///ad size: 320 x 100
    AdTimingBannerTypeSmart = 2          ///ad size: screen.width x 50
};

/// Banner Ad layout attribute
typedef NS_ENUM(NSInteger, AdTimingBannerLayoutAttribute) {
    AdTimingBannerLayoutAttributeTop = 0,
    AdTimingBannerLayoutAttributeLeft = 1,
    AdTimingBannerLayoutAttributeBottom = 2,
    AdTimingBannerLayoutAttributeRight = 3,
    AdTimingBannerLayoutAttributeHorizontally = 4,
    AdTimingBannerLayoutAttributeVertically = 5
};

/// The methods declared by the AdTimingBannerDelegate protocol allow the adopting delegate to respond to messages from the AdTimingBanner class and thus respond to operations such as whether the ad has been loaded, the person has clicked the ad.
@protocol AdTimingBannerDelegate<NSObject>

@optional

/// Sent when an ad has been successfully loaded.
- (void)adtimingBannerDidLoad:(AdTimingBanner *)banner;

/// Sent after an AdTimingBanner fails to load the ad.
- (void)adtimingBanner:(AdTimingBanner *)banner didFailWithError:(NSError *)error;

/// Sent immediately before the impression of an AdTimingBanner object will be logged.
- (void)adtimingBannerWillExposure:(AdTimingBanner *)banner;

/// Sent after an ad has been clicked by the person.
- (void)adtimingBannerDidClick:(AdTimingBanner *)banner;

/// Sent when a banner is about to present a full screen content
- (void)adtimingBannerWillPresentScreen:(AdTimingBanner *)banner;

/// Sent after a full screen content has been dismissed.
- (void)adtimingBannerDidDismissScreen:(AdTimingBanner *)banner;

 /// Sent when a user would be taken out of the application context.
- (void)adtimingBannerWillLeaveApplication:(AdTimingBanner *)banner;

@end

/// A customized UIView to represent a AdTimingiming ad (banner ad).
@interface AdTimingBanner : UIView

@property(nonatomic, readonly, nullable) NSString *placementID;

/// the delegate
@property (nonatomic, weak)id<AdTimingBannerDelegate> delegate;

/// The banner's ad placement ID.
- (NSString*)placementID;


/// This is a method to initialize an AdTimingBanner.
/// type: The size of the ad. Default is AdTimingBannerTypeDefault.
/// placementID: Typed access to the id of the ad placement.
- (instancetype)initWithBannerType:(AdTimingBannerType)type placementID:(NSString *)placementID;

/// set the banner position.
- (void)addLayoutAttribute:(AdTimingBannerLayoutAttribute)attribute constant:(CGFloat)constant;

/// Begins loading the AdTimingBanner content. And to show with default controller([UIApplication sharedApplication].keyWindow.rootViewController) when load success.
- (void)loadAndShow;

@end



NS_ASSUME_NONNULL_END

#endif /* OMAdTimingBannerClass_h */
