// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMyTargetInterstitialClass.h"
#import "OMRewardedVideoCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMMyTargetRewardedVideo : NSObject<OMRewardedVideoCustomEvent,MTRGInterstitialAdDelegate>
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, assign) BOOL ready;
@property (nonatomic,strong)  MTRGInterstitialAd *ivAd;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
