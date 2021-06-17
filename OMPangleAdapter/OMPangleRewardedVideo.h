// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMPangleRewardedVideoClass.h"
#import "OMRewardedVideoCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMPangleRewardedVideo : NSObject<BURewardedVideoAdDelegate,BUNativeExpressRewardedVideoAdDelegate,OMRewardedVideoCustomEvent>
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;
@property (nonatomic, assign) BOOL adReadyFlag;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
