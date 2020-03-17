// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMAppLovinRewardedVideoClass.h"
#import "OMRewardedVideoCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAppLovinRewardedVideo : NSObject<ALAdLoadDelegate,ALAdDisplayDelegate,ALAdVideoPlaybackDelegate,OMRewardedVideoCustomEvent>
@property (nonatomic, strong, nullable) ALIncentivizedInterstitialAd *alAd;
@property (nonatomic, strong) ALAd *ad;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;
@property (nonatomic, assign) NSInteger playPercent;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
