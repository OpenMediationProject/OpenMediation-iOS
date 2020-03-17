// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingRewardedVideoClass_h
#define OMAdTimingRewardedVideoClass_h
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol AdTimingMediatedRewardedVideoDelegate <NSObject>

@optional

/// Invoked when a rewarded video is available.
- (void)adtimingRewardedVideoChangedAvailability:(NSString*)placementID newValue:(BOOL)available;

/// Sent immediately when a rewarded video is opened.
- (void)adtimingRewardedVideoDidOpen:(NSString*)placementID;

/// Sent immediately when a rewarded video starts to play.
- (void)adtimingRewardedVideoPlayStart:(NSString*)placementID;

/// Send after a rewarded video has been completed.
- (void)adtimingRewardedVideoPlayEnd:(NSString*)placementID;

/// Sent after a rewarded video has been clicked.
- (void)adtimingRewardedVideoDidClick:(NSString*)placementID;

/// Sent after a user has been granted a reward.
- (void)adtimingRewardedVideoDidReceiveReward:(NSString*)placementID;

/// Sent after a rewarded video has been closed.
- (void)adtimingRewardedVideoDidClose:(NSString*)placementID;

/// Sent after a rewarded video has failed to play.
- (void)adtimingRewardedVideoDidFailToShow:(NSString*)placementID withError:(NSError *)error;

@end

@interface AdTimingRewardedVideoAd : NSObject

+ (instancetype)sharedInstance;

- (void)addMediationDelegate:(id<AdTimingMediatedRewardedVideoDelegate>)delegate;

- (void)removeMediationDelegate:(id<AdTimingMediatedRewardedVideoDelegate>)delegate;

- (void)loadWithPlacementID:(NSString*)placementID;

- (BOOL)isReady:(NSString*)placementID;

- (void)showWithViewController:(UIViewController *)viewController placementID:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdTimingRewardedVideoClass_h */
