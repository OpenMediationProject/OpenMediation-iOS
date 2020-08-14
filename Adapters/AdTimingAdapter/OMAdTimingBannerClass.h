// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingBannerClass_h
#define OMAdTimingBannerClass_h

@class AdTimingAdsBanner;

NS_ASSUME_NONNULL_BEGIN

/// Banner Ad Size
typedef NS_ENUM(NSInteger, AdTimingAdsBannerType) {
    AdTimingAdsBannerTypeDefault = 0,       ///ad size: 320 x 50
    AdTimingAdsBannerTypeLarge = 1,         ///ad size: 320 x 100
    AdTimingAdsBannerTypeLeaderboard = 2    ///ad size: 728x90
};

/// Banner Ad layout attribute
typedef NS_ENUM(NSInteger, AdTimingAdsBannerLayoutAttribute) {
    AdTimingAdsBannerLayoutAttributeTop = 0,
    AdTimingAdsBannerLayoutAttributeLeft = 1,
    AdTimingAdsBannerLayoutAttributeBottom = 2,
    AdTimingAdsBannerLayoutAttributeRight = 3,
    AdTimingAdsBannerLayoutAttributeHorizontally = 4,
    AdTimingAdsBannerLayoutAttributeVertically = 5
};

/// The methods declared by the AdTimingBannerDelegate protocol allow the adopting delegate to respond to messages from the AdTimingBanner class and thus respond to operations such as whether the ad has been loaded, the person has clicked the ad.
@protocol AdTimingAdsBannerDelegate<NSObject>

@optional

/// Sent when an ad has been successfully loaded.
- (void)adtimingBannerDidLoad:(AdTimingAdsBanner *)banner;

/// Sent after an AdTimingAdsBanner fails to load the ad.
- (void)adtimingBannerDidFailToLoad:(AdTimingAdsBanner *)banner withError:(NSError *)error;

/// Sent immediately before the impression of an AdTimingAdsBanner object will be logged.
- (void)adtimingBannerWillExposure:(AdTimingAdsBanner *)banner;

/// Sent after an ad has been clicked by the person.
- (void)adtimingBannerDidClick:(AdTimingAdsBanner *)banner;

/// Sent when a banner is about to present a full screen content
- (void)adtimingBannerWillPresentScreen:(AdTimingAdsBanner *)banner;

/// Sent after a full screen content has been dismissed.
- (void)adtimingBannerDidDismissScreen:(AdTimingAdsBanner *)banner;

 /// Sent when a user would be taken out of the application context.
- (void)adtimingBannerWillLeaveApplication:(AdTimingAdsBanner *)banner;

@end

/// A customized UIView to represent a AdTimingiming ad (banner ad).
@interface AdTimingAdsBanner : UIView

@property(nonatomic, readonly, nullable) NSString *placementID;

/// the delegate
@property (nonatomic, weak)id<AdTimingAdsBannerDelegate> delegate;

/// The banner's ad placement ID.
- (NSString*)placementID;

- (instancetype)initWithBannerType:(AdTimingAdsBannerType)type placementID:(NSString *)placementID;

- (instancetype)initWithBannerType:(AdTimingAdsBannerType)type placementID:(NSString *)placementID rootViewController:rootViewController;

/// set the banner position.
- (void)addLayoutAttribute:(AdTimingAdsBannerLayoutAttribute)attribute constant:(CGFloat)constant;

/// Begins loading the AdTimingAdsBanner content. And to show with default controller([UIApplication sharedApplication].keyWindow.rootViewController) when load success.
- (void)loadAndShow;

///load ad with bid payload
- (void)loadAndShowWithPayLoad:(NSString*)bidPayload;
@end



NS_ASSUME_NONNULL_END

#endif /* OMAdTimingBannerClass_h */
