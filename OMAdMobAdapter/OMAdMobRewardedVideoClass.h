// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdMobRewardedVideoClass_h
#define OMAdMobRewardedVideoClass_h
#import <UIKit/UIKit.h>
#import "OMAdMobClass.h"


NS_ASSUME_NONNULL_BEGIN

// Ad metadata key type.
typedef NSString *GADAdMetadataKey NS_STRING_ENUM;

@protocol GADAdMetadataDelegate;

/// Protocol for ads that provide ad metadata.
@protocol GADAdMetadataProvider <NSObject>

/// The ad's metadata. Use adMetadataDelegate to receive ad metadata change messages.
@property(nonatomic, readonly, nullable) NSDictionary<GADAdMetadataKey, id> *adMetadata;

/// Delegate for receiving ad metadata changes.
@property(nonatomic, weak, nullable) id<GADAdMetadataDelegate> adMetadataDelegate;

@end

/// Delegate protocol for receiving ad metadata change messages from a GADAdMetadataProvider.
@protocol GADAdMetadataDelegate <NSObject>

/// Tells the delegate that the ad's metadata changed. Called when an ad loads and when a loaded
/// ad's metadata changes.
- (void)adMetadataDidChange:(nonnull id<GADAdMetadataProvider>)ad;

@end

@protocol GADFullScreenContentDelegate;

/// Protocol for ads that present full screen content.
@protocol GADFullScreenPresentingAd <NSObject>

/// Delegate object that receives full screen content messages.
@property(nonatomic, weak, nullable) id<GADFullScreenContentDelegate> fullScreenContentDelegate;

@end

/// Delegate methods for receiving notifications about presentation and dismissal of full screen
/// content. Full screen content covers your application's content. The delegate may want to pause
/// animations or time sensitive interactions. Full screen content may be presented in the following
/// cases:
/// 1. A full screen ad is presented.
/// 2. An ad interaction opens full screen content.
@protocol GADFullScreenContentDelegate <NSObject>

@optional

/// Tells the delegate that an impression has been recorded for the ad.
- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad;

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error;

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad;

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad;

@end

@class GADRewardedAd;
@class GADResponseInfo;
@class GADServerSideVerificationOptions;
@class GADRequest;

/// A block to be executed when the user earns a reward.
typedef void (^GADUserDidEarnRewardHandler)(void);

/// Ad reward information.
@interface GADAdReward : NSObject

/// Type of the reward.
@property(nonatomic, readonly, nonnull) NSString *type;

/// Amount rewarded to the user.
@property(nonatomic, readonly, nonnull) NSDecimalNumber *amount;

/// Returns an initialized GADAdReward with the provided reward type and reward amount.
- (nonnull instancetype)initWithRewardType:(nonnull NSString *)rewardType
                              rewardAmount:(nonnull NSDecimalNumber *)rewardAmount
    NS_DESIGNATED_INITIALIZER;

@end


/// A block to be executed when the ad request operation completes. On success,
/// rewardedAd is non-nil and |error| is nil. On failure, rewardedAd is nil
/// and |error| is non-nil.
typedef void (^GADRewardedAdLoadCompletionHandler)(GADRewardedAd *_Nullable rewardedAd,
                                                   NSError *_Nullable error);

/// A rewarded ad. Rewarded ads are ads that users have the option of interacting with in exchange
/// for in-app rewards.
@interface GADRewardedAd : NSObject <GADAdMetadataProvider, GADFullScreenPresentingAd>

/// The ad unit ID.
@property(nonatomic, readonly, nonnull) NSString *adUnitID;

/// Information about the ad response that returned the ad.
@property(nonatomic, readonly, nonnull) GADResponseInfo *responseInfo;

/// The reward earned by the user for interacting with the ad.
@property(nonatomic, readonly, nonnull) GADAdReward *adReward;

/// Options specified for server-side user reward verification. Must be set before presenting this
/// ad.
@property(nonatomic, copy, nullable)
    GADServerSideVerificationOptions *serverSideVerificationOptions;

/// Delegate for handling full screen content messages.
@property(nonatomic, weak, nullable) id<GADFullScreenContentDelegate> fullScreenContentDelegate;

/// Loads a rewarded ad.
///
/// @param adUnitID An ad unit ID created in the AdMob or Ad Manager UI.
/// @param request An ad request object. If nil, a default ad request object is used.
/// @param completionHandler A handler to execute when the load operation finishes or times out.
+ (void)loadWithAdUnitID:(nonnull NSString *)adUnitID
                 request:(nullable GADRequest *)request
       completionHandler:(nonnull GADRewardedAdLoadCompletionHandler)completionHandler;

/// Returns whether the rewarded ad can be presented from the provided root view
/// controller. Sets the error out parameter if the ad can't be presented. Must be called on the
/// main thread.
- (BOOL)canPresentFromRootViewController:(nonnull UIViewController *)rootViewController
                                   error:(NSError *_Nullable __autoreleasing *_Nullable)error;

/// Presents the rewarded ad. Must be called on the main thread.
///
/// @param rootViewController A view controller to present the ad.
/// @param userDidEarnRewardHandler A handler to execute when the user earns a reward.
- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController
             userDidEarnRewardHandler:(nonnull GADUserDidEarnRewardHandler)userDidEarnRewardHandler;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdMobRewardedVideoClass_h */
