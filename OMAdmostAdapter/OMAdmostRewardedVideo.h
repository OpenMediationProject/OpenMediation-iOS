// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMRewardedVideoCustomEvent.h"
#import "OMAdmostRewardedVideoClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdmostRewardedVideo : NSObject<OMRewardedVideoCustomEvent,AMRRewardedVideoDelegate>
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) AMRRewardedVideo *rewardedVideo;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;
@property (nonatomic, weak) id<AdmostBidDelegate> bidDelegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
