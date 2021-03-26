// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMHyBidRewardedVideoClass_h
#define OMHyBidRewardedVideoClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HyBidAd;

@protocol HyBidRewardedAdDelegate<NSObject>

- (void)rewardedDidLoad;
- (void)rewardedDidFailWithError:(NSError *)error;
- (void)rewardedDidTrackImpression;
- (void)rewardedDidTrackClick;
- (void)rewardedDidDismiss;
- (void)onReward;

@end

@protocol HyBidSignalDataProcessorDelegate<NSObject>

- (void)signalDataDidFinishWithAd:(HyBidAd *)ad;
- (void)signalDataDidFailWithError:(NSError *)error;

@end

@interface HyBidRewardedAd: NSObject <HyBidSignalDataProcessorDelegate>

@property (nonatomic, strong) HyBidAd *ad;
@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) BOOL isMediation;

- (instancetype)initWithZoneID:(NSString *)zoneID andWithDelegate:(NSObject<HyBidRewardedAdDelegate> *)delegate;
- (instancetype)initWithDelegate:(NSObject<HyBidRewardedAdDelegate> *)delegate;
- (void)load;
- (void)prepareAdWithContent:(NSString *)adContent;

/**
 Presents the rewarded ad modally from the current view controller.
 This method will do nothing if the rewarded ad has not been loaded (i.e. the value of its `isReady` property is NO).
 */
- (void)show;

/**
* Presents the rewarded ad modally from the specified view controller.
*
* This method will do nothing if the rewarded ad has not been loaded (i.e. the value of its
* `isReady` property is NO).
*
* @param viewController The view controller that should be used to present the rewarded ad.
*/
- (void)showFromViewController:(UIViewController *)viewController;
- (void)hide;

@end

NS_ASSUME_NONNULL_END

#endif /* OMHyBidRewardedVideoClass_h */
