// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMSigMobRewardedVideoClass_h
#define OMSigMobRewardedVideoClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMSigMobClass.h"

@class WindRewardInfo;
@class WindRewardVideoAd;

@protocol WindRewardVideoAdDelegate<NSObject>

/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardVideoAdDidLoad:(WindRewardVideoAd *)rewardVideoAd;

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardVideoAdDidLoad:(WindRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error;

/**
 This method is called when video ad slot will be showing.
 */
- (void)rewardVideoAdWillVisible:(WindRewardVideoAd *)rewardVideoAd;

/**
 This method is called when video ad slot has been shown.
 */
- (void)rewardVideoAdDidVisible:(WindRewardVideoAd *)rewardVideoAd;

/**
 This method is called when video ad is clicked.
 */
- (void)rewardVideoAdDidClick:(WindRewardVideoAd *)rewardVideoAd;

/**
 This method is called when video ad is clicked skip button.
 */
- (void)rewardVideoAdDidClickSkip:(WindRewardVideoAd *)rewardVideoAd;

/**
 This method is called when video ad is about to close.
 */
- (void)rewardVideoAdDidClose:(WindRewardVideoAd *)rewardVideoAd reward:(WindRewardInfo *)reward;

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)rewardVideoAdDidPlayFinish:(WindRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error;

/**
 This method is called when return ads from sigmob ad server.
 */
- (void)rewardVideoAdServerResponse:(WindRewardVideoAd *)rewardVideoAd isFillAd:(BOOL)isFillAd;



@end


@interface WindRewardVideoAd : NSObject

@property (nonatomic, weak) id<WindRewardVideoAdDelegate> delegate;

@property (nonatomic, strong, readonly) NSString *placementId;

@property (nonatomic, getter=isAdReady, readonly) BOOL ready;


- (instancetype)initWithPlacementId:(NSString *)placementId request:(WindAdRequest *)request;

- (void)loadAdData;

/**
 Display video ad.
 @param rootViewController : root view controller for displaying ad.
 @param extras : Extended parameters for displaying ad.
 */
- (void)showAdFromRootViewController:(UIViewController *)rootViewController
                             options:(NSDictionary<NSString *, NSString *> *)extras;

@end

#endif /* OMSigMobRewardedVideoClass_h */
