// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingBannerClass_h
#define OMAdTimingBannerClass_h

@class AdTimingBidBanner;

NS_ASSUME_NONNULL_BEGIN

/// Banner Ad Size
typedef NS_ENUM(NSInteger, AdTimingBidBannerType) {
    AdTimingBidBannerTypeDefault = 0,       ///ad size: 320 x 50
    AdTimingBidBannerTypeLarge = 1,         ///ad size: 320 x 100
    AdTimingBidBannerTypeLeaderboard = 2,   ///ad size: 728x90
    AdTimingBidBannerTypeSmart = 3,
};


/// Banner Ad layout attribute
typedef NS_ENUM(NSInteger, AdTimingBidBannerLayoutAttribute) {
    AdTimingBidBannerLayoutAttributeTop = 0,
    AdTimingBidBannerLayoutAttributeLeft = 1,
    AdTimingBidBannerLayoutAttributeBottom = 2,
    AdTimingBidBannerLayoutAttributeRight = 3,
    AdTimingBidBannerLayoutAttributeHorizontally = 4,
    AdTimingBidBannerLayoutAttributeVertically = 5
};

/// The methods declared by the AdTimingBidBannerDelegate protocol allow the adopting delegate to respond to messages from the AdTimingBidBanner class and thus respond to operations such as whether the ad has been loaded, the person has clicked the ad.
@protocol AdTimingBidBannerDelegate<NSObject>

@optional

/// Sent when an ad has been successfully loaded.
- (void)AdTimingBidBannerDidLoad:(AdTimingBidBanner *)banner;

/// Sent after an AdTimingBidBanner fails to load the ad.
- (void)AdTimingBidBannerDidFailToLoad:(AdTimingBidBanner *)banner withError:(NSError *)error;

/// Sent immediately before the impression of an AdTimingBidBanner object will be logged.
- (void)AdTimingBidBannerWillExposure:(AdTimingBidBanner *)banner;

/// Sent after an ad has been clicked by the person.
- (void)AdTimingBidBannerDidClick:(AdTimingBidBanner *)banner;

/// Sent when a banner is about to present a full screen content
- (void)AdTimingBidBannerWillPresentScreen:(AdTimingBidBanner *)banner;

/// Sent after a full screen content has been dismissed.
- (void)AdTimingBidBannerDidDismissScreen:(AdTimingBidBanner *)banner;

 /// Sent when a user would be taken out of the application context.
- (void)AdTimingBidBannerWillLeaveApplication:(AdTimingBidBanner *)banner;

@end

/// A customized UIView to represent a AdTimingBidiming ad (banner ad).
@interface AdTimingBidBanner : UIView

@property(nonatomic, readonly, nullable) NSString *placementID;

/// the delegate
@property (nonatomic, weak)id<AdTimingBidBannerDelegate> delegate;

/// The banner's ad placement ID.
- (NSString*)placementID;

- (instancetype)initWithBannerType:(AdTimingBidBannerType)type placementID:(NSString *)placementID;

- (instancetype)initWithBannerType:(AdTimingBidBannerType)type placementID:(NSString *)placementID rootViewController:rootViewController;

/// set the banner position.
- (void)addLayoutAttribute:(AdTimingBidBannerLayoutAttribute)attribute constant:(CGFloat)constant;

///load ad with bid payload
- (void)loadAndShowWithPayLoad:(NSString*)bidPayload;
@end



NS_ASSUME_NONNULL_END

#endif /* OMAdTimingBannerClass_h */
