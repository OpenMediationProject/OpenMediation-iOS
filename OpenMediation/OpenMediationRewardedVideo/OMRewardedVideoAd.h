// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMAdBase.h"

NS_ASSUME_NONNULL_BEGIN

@class OMRewardedVideoAd;

@protocol RewardedVideoDelegate <NSObject>

- (void)rewardedVideoChangedAvailability:(OMRewardedVideoAd *)video newValue:(BOOL)available;

- (void)rewardedVideoDidOpen:(OMRewardedVideoAd*)video;

- (void)rewardedVideoDidStart:(OMRewardedVideoAd*)video;

- (void)rewardedVideoDidEnd:(OMRewardedVideoAd*)video;

- (void)rewardedVideoDidClick:(OMRewardedVideoAd*)video;

- (void)rewardedVideoDidReceiveReward:(OMRewardedVideoAd*)video;

- (void)rewardedVideoDidClose:(OMRewardedVideoAd*)video;

- (void)rewardedVideoDidFailToShow:(OMRewardedVideoAd*)video error:(NSError*)error;

@end

@interface OMRewardedVideoAd : OMAdBase

@property (nonatomic, weak)id<RewardedVideoDelegate> delegate;
- (NSString*)placementID;
- (instancetype)initWithPlacementID:(NSString*)placementID;
- (void)preload;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)viewController;
- (void)show:(UIViewController*)viewController extraParams:(NSString*)extraParams scene:(NSString*)sceneName;
@end

NS_ASSUME_NONNULL_END
