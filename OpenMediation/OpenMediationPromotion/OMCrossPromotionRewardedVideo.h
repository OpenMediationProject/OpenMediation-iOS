// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

#import "OMToolUmbrella.h"
#import "OMCrossPromotionVideoController.h"
#import "OMCustomEventDelegate.h"
#import "OMRewardedVideoCustomEvent.h"
NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionRewardedVideo : NSObject<promotionVideoDelegate,OMRewardedVideoCustomEvent>
@property (nonatomic, strong) OMCrossPromotionVideoController *crossPromotionVideo;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *showSceneID;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;
@property (nonatomic, strong) OMCrossPromotionCampaign *campaign;
@property (nonatomic, assign) BOOL autorotate;
- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAdWithBidPayload:(NSString*)bidPayload;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;
@end
NS_ASSUME_NONNULL_END
