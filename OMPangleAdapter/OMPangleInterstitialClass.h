// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleInterstitialClass_h
#define OMPangleInterstitialClass_h
#import <UIKit/UIKit.h>
#import "OMPangleClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BUFullScreenVideoAdType) {
    BUFullScreenAdTypeEndcard        = 0,    // video + endcard
    BUFullScreenAdTypeVideoPlayable  = 1,    // video + playable
    BUFullScreenAdTypePurePlayable   = 2     // pure playable
};

@class BUFullscreenVideoAd;

@protocol BUFullscreenVideoAdDelegate <NSObject>

@optional

/**
 视频广告物料加载成功
 */
- (void)fullscreenVideoMaterialMetaAdDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告视频素材缓存成功
 */
- (void)fullscreenVideoAdVideoDataDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd;

/**
 广告位即将展示
 */
- (void)fullscreenVideoAdWillVisible:(BUFullscreenVideoAd *)fullscreenVideoAd;

/**
 广告位已经展示
 */
- (void)fullscreenVideoAdDidVisible:(BUFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告即将关闭
 */
- (void)fullscreenVideoAdWillClose:(BUFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告关闭
 */
- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告点击
 */
- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告素材加载失败
 
 @param fullscreenVideoAd 当前视频对象
 @param error 错误对象
 */
- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error;

/**
 视频广告播放完成或发生错误
 
 @param fullscreenVideoAd 当前视频对象
 @param error 错误对象
 */
- (void)fullscreenVideoAdDidPlayFinish:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error;

/**
 视频广告播放点击跳过
 
 @param fullscreenVideoAd 当前视频对象
 */
- (void)fullscreenVideoAdDidClickSkip:(BUFullscreenVideoAd *)fullscreenVideoAd;

- (void)fullscreenVideoAdCallback:(BUFullscreenVideoAd *)fullscreenVideoAd withType:(BUFullScreenVideoAdType)fullscreenVideoAdType;

@end

@interface BUFullscreenVideoAd : NSObject

@property (nonatomic, weak, nullable) id<BUFullscreenVideoAdDelegate> delegate;
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid __attribute__((deprecated("Use fullscreenVideoMaterialMetaAdDidLoad: instead.")));

/**
 初始化 BUFullscreenVideoAd
 
 @param slotID 代码位ID
 @return BUFullscreenVideoAd
 */
- (instancetype)initWithSlotID:(NSString *)slotID;

/**
 加载数据
 */
- (void)loadAdData;

/**
 展示视频广告
 
 @param rootViewController 展示视频的根视图
 @return 是否成功展示
 */
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;

@end


@class BUNativeExpressFullscreenVideoAd;

//define the type of native express video ad
typedef NS_ENUM(NSUInteger, BUNativeExpressFullScreenAdType) {
    BUNativeExpressFullScreenAdTypeEndcard              = 0,        // video + endcard
    BUNativeExpressFullScreenAdTypeVideoPlayable        = 1,        // video + playable
    BUNativeExpressFullScreenAdTypePurePlayable         = 2         // pure playable
};


@protocol BUNativeExpressFullscreenVideoAdDelegate <NSObject>

@optional
/**
 This method is called when video ad material loaded successfully.
 */
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error;

/**
 This method is called when rendering a nativeExpressAdView successed.
 It will happen when ad is show.
 */
- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd;

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error;

/**
 This method is called when video cached successfully.
 For a better user experience, it is recommended to display video ads at this time.
 And you can call [BUNativeExpressFullscreenVideoAd showAdFromRootViewController:].
 */
- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when video ad slot will be showing.
 */
- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when video ad slot has been shown.
 */
- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when video ad is clicked.
 */
- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when the user clicked skip button.
 */
- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when video ad is about to close.
 */
- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when video ad is closed.
 */
- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error;

/**
This method is used to get the type of nativeExpressFullScreenVideo ad
 */
- (void)nativeExpressFullscreenVideoAdCallback:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd withType:(BUNativeExpressFullScreenAdType) nativeExpressVideoAdType;

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressFullscreenVideoAdDidCloseOtherController:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd interactionType:(BUInteractionType)interactionType;

@end

@class BUAdSlot;

@protocol BUMopubAdMarkUpDelegate <NSObject>
@optional

/** Mopub AdMarkUp
  */
- (void)setMopubAdMarkUp:(NSString *)adm;

/// Bidding Token. Now for MSDK in domestic, used for every ad type.
- (NSString *)biddingToken;

/** Mopub Adaptor get AD type from rit
  *   @return  @{@"adSlotType": @(1), @"renderType": @(1)}
  *   adSlotType refer from BUAdSlotAdType in "BUAdSlot.h"
  *   showType: @"1" express AD   @"2" native AD
  */
+ (nullable NSDictionary *)AdTypeWithRit:(NSString *)rit error:(NSError **)error;

/** Mopub bidding Adaptor get AD type from adm
  *  @return  @{@"adSlotType": @(1), @"renderType": @(1)}
  *  adSlotType refer from BUAdSlotAdType in "BUAdSlot.h"
  *  showType: @"1" express AD   @"2" native AD
  */
+ (NSDictionary *)AdTypeWithAdMarkUp:(NSString *)adm;


/// Mopub Bidding Token
+ (NSString *)mopubBiddingToken;

@end

@interface BUNativeExpressFullscreenVideoAd : NSObject<BUMopubAdMarkUpDelegate>

@property (nonatomic, weak, nullable) id<BUNativeExpressFullscreenVideoAdDelegate> delegate;
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid __attribute__((deprecated("Use nativeExpressFullscreenVideoAdDidLoad: instead.")));

/// media configuration parameters.
@property (nonatomic, copy, readonly) NSDictionary *mediaExt;

/**
 Initializes video ad with slot id.
 @param slotID : the unique identifier of video ad.
 @return BUFullscreenVideoAd
 */
- (instancetype)initWithSlotID:(NSString *)slotID;

/**
 Initializes video ad with slot.
 @param slot : A object, through which you can pass in the fullscreen unique identifier, ad type, and so on.
 @return BUNativeExpressFullscreenVideoAd
*/
- (instancetype)initWithSlot:(BUAdSlot *)slot;

/**
 Load video ad datas.
 */
- (void)loadAdData;

/**
 Display video ad.
 @param rootViewController : root view controller for displaying ad.
 @return : whether it is successfully displayed.
 */
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;

/**
 Display video ad.
 @param rootViewController : root view controller for displaying ad.
 @param sceneDescirbe : optional. Identifies a custom description of the presentation scenario.
 @return : whether it is successfully displayed.
 */
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController ritSceneDescribe:(NSString *_Nullable)sceneDescirbe;

@end

NS_ASSUME_NONNULL_END

#endif /* OMPangleInterstitialClass_h */
