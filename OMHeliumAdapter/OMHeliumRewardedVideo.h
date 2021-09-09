// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMHeliumRouter.h"
#import "OMRewardedVideoCustomEvent.h"
#import "OMBidCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMHeliumRewardedVideo : NSObject <OMRewardedVideoCustomEvent,OMHeliumAdapterDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;
@property (nonatomic, weak) id<OMBidCustomEventDelegate> bidDelegate;
@property (nonatomic, strong) NSDictionary *biInfo;
- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
