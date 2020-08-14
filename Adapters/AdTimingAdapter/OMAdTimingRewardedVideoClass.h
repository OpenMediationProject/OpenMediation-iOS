// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingRewardedVideoClass_h
#define OMAdTimingRewardedVideoClass_h
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol AdTimingAdsRewardedVideoDelegate <NSObject>

@optional

/// Invoked when a rewarded video did load.

- (void)adtimingRewardedVideoDidLoad:(NSString *)placementID;

/// Sent after an rewarded video fails to load the ad.
- (void)adtimingRewardedVideoDidFailToLoad:(NSString *)placementID withError:(NSError *)error;

/// Sent immediately when a rewarded video is opened.
- (void)adtimingRewardedVideoDidOpen:(NSString *)placementID;

/// Sent immediately when a rewarded video starts to play.
- (void)adtimingRewardedVideoPlayStart:(NSString *)placementID;

/// Send after a rewarded video has been completed.
- (void)adtimingRewardedVideoPlayEnd:(NSString *)placementID;

/// Sent after a rewarded video has been clicked.
- (void)adtimingRewardedVideoDidClick:(NSString *)placementID;

/// Sent after a user has been granted a reward.
- (void)adtimingRewardedVideoDidReceiveReward:(NSString *)placementID;

/// Sent after a rewarded video has been closed.
- (void)adtimingRewardedVideoDidClose:(NSString *)placementID;

/// Sent after a rewarded video has failed to play.
- (void)adtimingRewardedVideoDidFailToShow:(NSString *)placementID withError:(NSError *)error;

@end

@interface AdTimingAdsRewardedVideo : NSObject

/// Returns the singleton instance.
+ (instancetype)sharedInstance;

/// Add delegate
- (void)addDelegate:(id<AdTimingAdsRewardedVideoDelegate>)delegate;

/// Remove delegate
- (void)removeDelegate:(id<AdTimingAdsRewardedVideoDelegate>)delegate;

/// loadAd
- (void)loadWithPlacementID:(NSString*)placementID;

///load ad with bid payload
- (void)loadWithPlacementID:(NSString*)placementID payLoad:(NSString*)bidPayload;

/// Indicates whether the rewarded video is ready to show ad.
- (BOOL)isReady:(NSString*)placementID;


- (void)showAdFromRootViewController:(UIViewController *)viewController placementID:(NSString *)placementID;


- (void)showAdFromRootViewController:(UIViewController *)viewController placementID:(NSString *)placementID extraParams:(NSString*)extraParams;

@end


NS_ASSUME_NONNULL_END

#endif /* OMAdTimingRewardedVideoClass_h */
