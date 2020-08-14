//
//  OMChartboostBidRouter.h
//  AdTimingChartboostBidAdapter
//
//  Created by ylm on 2020/6/30.
//  Copyright © 2020 AdTiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMChartboostBidClass.h"
NS_ASSUME_NONNULL_BEGIN


@protocol OMChartboostBidAdapterDelegate <NSObject>

- (void)omChartboostBiDdidLoadWithError:(nullable HeliumError *)error;
- (void)omChartboostBidDidShowWithError:(HeliumError *)error;
- (void)omChartboostBidDidClickWithError:(HeliumError *)error;
- (void)omChartboostBidDidCloseWithError:(HeliumError *)error;
- (void)omChartboostBidDidLoadWinningBidWithInfo:(NSDictionary*)bidInfo;
@optional
- (void)omChartboostBidDidGetReward:(NSInteger)reward;

@end

@interface OMChartboostBidRouter : NSObject <CHBHeliumInterstitialAdDelegate,CHBHeliumRewardedAdDelegate>
@property (nonatomic, strong) NSMutableDictionary *placementDelegateMap;
@property (nonatomic, strong) NSMutableDictionary *placementAdMap;

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;
- (void)loadInterstitialWithPlacmentID:(NSString *)pid;
- (void)loadRewardedVideoWithPlacmentID:(NSString *)pid;
- (BOOL)isReady:(NSString *)pid;
- (void)showAd:(NSString *)pid withVC:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
