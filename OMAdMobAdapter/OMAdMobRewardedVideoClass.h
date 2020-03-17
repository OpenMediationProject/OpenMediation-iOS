// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdMobRewardedVideoClass_h
#define OMAdMobRewardedVideoClass_h
#import <UIKit/UIKit.h>
#import "OMAdMobClass.h"
@class GADAdReward;
@class GADRewardedAd;

NS_ASSUME_NONNULL_BEGIN

@protocol GADRewardedAdDelegate <NSObject>

@required

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
 userDidEarnReward:(nonnull GADAdReward *)reward;

@optional

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
didFailToPresentWithError:(nonnull NSError *)error;

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(nonnull GADRewardedAd *)rewardedAd;

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(nonnull GADRewardedAd *)rewardedAd;

@end

typedef void (^GADRewardedAdLoadCompletionHandler)(GADRequestError *_Nullable error);

@interface GADRewardedAd : NSObject

@property(nonatomic, readonly, getter=isReady) BOOL ready;

/// The ad unit ID.
@property(nonatomic, readonly, nonnull) NSString *adUnitID;

/// Initializes a rewarded ad with the provided ad unit ID. Create ad unit IDs using the AdMob
/// website for each unique ad placement in your app. Unique ad units improve targeting and
/// statistics.
///
/// Example AdMob ad unit ID: @"ca-app-pub-3940256099942544/1712485313"
- (nonnull instancetype)initWithAdUnitID:(nonnull NSString *)adUnitID;

/// Requests an rewarded ad and calls the provided completion handler when the request finishes.
- (void)loadRequest:(nullable GADRequest *)request
  completionHandler:(nullable GADRewardedAdLoadCompletionHandler)completionHandler;

/// Presents the rewarded ad with the provided view controller and rewarded delegate to call back on
/// various intermission events. The delegate is strongly retained by the receiver until a terminal
/// delegate method is called. Terminal methods are -rewardedAd:didFailToPresentWithError: and
/// -rewardedAdDidClose: of GADRewardedAdDelegate.
- (void)presentFromRootViewController:(nonnull UIViewController *)viewController
                             delegate:(nonnull id<GADRewardedAdDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdMobRewardedVideoClass_h */
