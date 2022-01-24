// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMRewardedVideoCustomEvent.h"
#import "OMSigMobRewardedVideoClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMSigMobRewardedVideo : NSObject<OMRewardedVideoCustomEvent,WindRewardVideoAdDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) WindRewardVideoAd *rewardedVideoAd;
@property (nonatomic, getter=isAdReady, readonly) BOOL ready;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
