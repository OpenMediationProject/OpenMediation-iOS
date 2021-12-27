// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMUnityAdapter.h"
#import "OMUnityRouter.h"
#import "OMRewardedVideoCustomEvent.h"


NS_ASSUME_NONNULL_BEGIN


@interface OMUnityRewardedVideo : NSObject<OMUnityAdapterDelegate,OMRewardedVideoCustomEvent>
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, assign) BOOL isUnityAdReady;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
