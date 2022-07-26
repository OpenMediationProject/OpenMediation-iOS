// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleRewardedVideoClass_h
#define OMPangleRewardedVideoClass_h
#import <UIKit/UIKit.h>
#import "OMPangleClass.h"

NS_ASSUME_NONNULL_BEGIN


@class BUNativeExpressRewardedVideoAd;
@class BURewardedVideoModel;

typedef NS_ENUM(NSInteger, BURitSceneType) {
    BURitSceneType_custom                  = 0,//custom
    BURitSceneType_home_open_bonus         = 1,//Login/open rewards (login, sign-in, offline rewards doubling, etc.)
    BURitSceneType_home_svip_bonus         = 2,//Special privileges (VIP privileges, daily rewards, etc.)
    BURitSceneType_home_get_props          = 3,//Watch rewarded video ad to gain skin, props, levels, skills, etc
    BURitSceneType_home_try_props          = 4,//Watch rewarded video ad to try out skins, props, levels, skills, etc
    BURitSceneType_home_get_bonus          = 5,//Watch rewarded video ad to get gold COINS, diamonds, etc
    BURitSceneType_home_gift_bonus         = 6,//Sweepstakes, turntables, gift boxes, etc
    BURitSceneType_game_start_bonus        = 7,//Before the opening to obtain physical strength, opening to strengthen, opening buff, task props
    BURitSceneType_game_reduce_waiting     = 8,//Reduce wait and cooldown on skill CD, building CD, quest CD, etc
    BURitSceneType_game_more_opportunities = 9,//More chances (resurrect death, extra game time, decrypt tips, etc.)
    BURitSceneType_game_finish_rewards     = 10,//Settlement multiple times/extra bonus (completion of chapter, victory over boss, first place, etc.)
    BURitSceneType_game_gift_bonus         = 11//The game dropped treasure box, treasures and so on
};

/// define the type of  native express rewarded video Ad
typedef NS_ENUM(NSUInteger, BUNativeExpressRewardedVideoAdType) {
    BUNativeExpressRewardedVideoAdTypeEndcard         = 0,  // video + endcard
    BUNativeExpressRewardedVideoAdTypeVideoPlayable   = 1,  // video + playable
    BUNativeExpressRewardedVideoAdTypePurePlayable    = 2,  // pure playable
};

@protocol BUNativeExpressRewardedVideoAdDelegate <NSObject>

@optional
/**
 This method is called when video ad material loaded successfully.
 */
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error;
/**
  this methods is to tell delegate the type of native express rewarded video Ad
 */
- (void)nativeExpressRewardedVideoAdCallback:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd withType:(BUNativeExpressRewardedVideoAdType)nativeExpressVideoType;

/**
 This method is called when cached successfully.
 For a better user experience, it is recommended to display video ads at this time.
 And you can call [BUNativeExpressRewardedVideoAd showAdFromRootViewController:].
 */
- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when rendering a nativeExpressAdView successed.
 It will happen when ad is show.
 */
- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error;

/**
 This method is called when video ad slot will be showing.
 */
- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad slot has been shown.
 */
- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad is about to close.
 */
- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad is closed.
 */
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad is clicked.
 */
- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when the user clicked skip button.
 */
- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error;

/**
 Server verification which is requested asynchronously is succeeded. now include two v erify methods:
      1. C2C need  server verify  2. S2S don't need server verify
 @param verify :return YES when return value is 2000.
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify;

/**
 Server verification which is requested asynchronously is failed.
 Return value is not 2000.
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd  __attribute__((deprecated("Use nativeExpressRewardedVideoAdServerRewardDidFail: error: instead.")));

/**
  Server verification which is requested asynchronously is failed.
  @param rewardedVideoAd express rewardVideo Ad
  @param error request error info
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error;

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressRewardedVideoAdDidCloseOtherController:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd interactionType:(BUInteractionType)interactionType;

@end

/// Please note: This Class does not take effect on Pangle global, only use it when you have traffic from mainland China.
 __attribute__((objc_subclassing_restricted))
@interface BUNativeExpressRewardedVideoAd : BUInterfaceBaseObject <BUMopubAdMarkUpDelegate, BUAdClientBiddingProtocol>
@property (nonatomic, strong) BURewardedVideoModel *rewardedVideoModel;
@property (nonatomic, weak, nullable) id<BUNativeExpressRewardedVideoAdDelegate> delegate;
@property (nonatomic, weak, nullable) id<BUNativeExpressRewardedVideoAdDelegate> rewardPlayAgainInteractionDelegate;

/// media configuration parameters.
@property (nonatomic, copy, readonly) NSDictionary *mediaExt;

/**
 Is  materialMeta from the preload, default is NO
 @warning:Pure playable, the value of this field is accurate after the material is downloaded successfully. For others, the value of this field needs to be accurate after the video is downloaded successfully.
 @Note :  This field is only useful in China area.
*/
@property (nonatomic, assign, readonly) BOOL materialMetaIsFromPreload;

/**
 The expiration timestamp of materialMeta
 @warning:Pure playable, the value of this field is accurate after the material is downloaded successfully. For others, the value of this field needs to be accurate after the video is downloaded successfully.
 @Note :  This field is only useful in China area.
 */
@property (nonatomic, assign, readonly) NSTimeInterval expireTimestamp;

/**
 Whether material is effective.
 Setted to YES when data is not empty and has not been displayed.
 Repeated display is not billed.
 */
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid __attribute__((deprecated("Use nativeExpressRewardedVideoAdDidLoad: instead.")));

- (instancetype)initWithSlotID:(NSString *)slotID rewardedVideoModel:(BURewardedVideoModel *)model;

/**
 Initializes Rewarded video ad with ad slot and frame.
 @param slot A object, through which you can pass in the reward unique identifier, ad type, and so on.
 @param model Rewarded video model.
 @return BUNativeExpressRewardedVideoAd
*/
- (instancetype)initWithSlot:(BUAdSlot *)slot rewardedVideoModel:(BURewardedVideoModel *)model;

/**
 Ad slot material id
 */
- (NSString *)getAdCreativeToken;

- (void)loadAdData;

/**
 Display video ad.
 @param rootViewController : root view controller for displaying ad.
 @return : whether it is successfully displayed.
 */
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;

/**
 If ritSceneType is custom, you need to pass in the values for sceneDescirbe.
 @param ritSceneType  : optional. Identifies a custom description of the presentation scenario.
 @param sceneDescirbe : optional. Identify the scene of presentation.
 */
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController ritScene:(BURitSceneType)ritSceneType ritSceneDescribe:(NSString *_Nullable)sceneDescirbe;

/**
 Get the expiration timestamp of materialMeta
 @warning: The value of this field is only accurate after the video is downloaded successfully or after the access is successfully obtained
 @Note :  This API is only useful in China area.
 */
- (NSTimeInterval)getExpireTimestamp;

@end


// 海外

@class PAGRewardedAd;
@class PAGRewardModel;


@interface PAGRewardedRequest : PAGRequest

@end

@protocol PAGRewardedAdDelegate <PAGAdDelegate>

@optional

/// Tells the delegate that the user has earned the reward.
/// @param rewardedAd rewarded ad instance
/// @param rewardModel user's reward info
- (void)rewardedAd:(PAGRewardedAd *)rewardedAd userDidEarnReward:(PAGRewardModel *)rewardModel;


/// Tells the delegate that the user failed to earn the reward.
/// @param rewardedAd rewarded ad instance
/// @param error failed reson
- (void)rewardedAd:(PAGRewardedAd *)rewardedAd userEarnRewardFailWithError:(NSError *)error;

@end

@class PAGRewardedAd;
/// Callback for loading ad results.
/// @param rewardedAd Ad instance after successfully loaded which will be non-nil on success.
/// @param error Loading error which will be non-nil on fail.
typedef void (^PAGRewardedAdLoadCompletionHandler)(PAGRewardedAd * _Nullable rewardedAd,
                                                  NSError * _Nullable error);

@interface PAGRewardedAd : NSObject<PAGAdProtocol,PAGAdClientBiddingProtocol>

/// Ad event delegate.
@property (nonatomic, weak, nullable) id<PAGRewardedAdDelegate> delegate;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;


/// Load rewarded ad
/// @param slotID Required. The unique identifier of rewarded ad.
/// @param request Required. An instance of a rewarded ad request.
/// @param completionHandler Handler which will be called when the request completes.
+ (void)loadAdWithSlotID:(NSString *)slotID
                 request:(PAGRewardedRequest *)request
       completionHandler:(PAGRewardedAdLoadCompletionHandler)completionHandler;


/// Present the rewarded ad
/// @param rootViewController View controller the rewarded ad will be presented on.
/// @warning This method must be called on the main thread.
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END

#endif /* OMPangleRewardedVideoClass_h */
