// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMChartboostBidRouter.h"
#import "OMRewardedVideoCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMChartboostBidRewardedVideo : NSObject <OMRewardedVideoCustomEvent,OMChartboostBidAdapterDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;
@property (nonatomic, weak) id<ChartboostBidDelegate> bidDelegate;
@property (nonatomic, strong) NSDictionary *biInfo;
- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
