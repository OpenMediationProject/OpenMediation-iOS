// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMRewardedVideoCustomEvent.h"
NS_ASSUME_NONNULL_BEGIN


@interface OMAdMobRewardedVideo : NSObject<GADFullScreenContentDelegate,OMRewardedVideoCustomEvent>
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) GADRewardedAd *videoAd;
@property (nonatomic, strong) GADAdReward *reward;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;
@property (nonatomic, assign) BOOL ready;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
