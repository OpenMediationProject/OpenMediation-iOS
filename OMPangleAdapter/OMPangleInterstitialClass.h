// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleInterstitialClass_h
#define OMPangleInterstitialClass_h
#import <UIKit/UIKit.h>
#import "OMPangleClass.h"

NS_ASSUME_NONNULL_BEGIN

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

/// Please note: This Class does not take effect on Pangle global, only use it when you have traffic from mainland China.
 __attribute__((objc_subclassing_restricted))
@interface BUNativeExpressFullscreenVideoAd : BUInterfaceBaseObject <BUMopubAdMarkUpDelegate, BUAdClientBiddingProtocol>

@property (nonatomic, weak, nullable) id<BUNativeExpressFullscreenVideoAdDelegate> delegate;
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid __attribute__((deprecated("Use nativeExpressFullscreenVideoAdDidLoad: instead.")));

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
 @warning: Pure playable, the value of this field is accurate after the material is downloaded successfully. For others, the value of this field needs to be accurate after the video is downloaded successfully.
 @Note :  This field is only useful in China area.
 */
@property (nonatomic, assign, readonly) NSTimeInterval expireTimestamp;

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
 Ad slot material id
 */
- (NSString *)getAdCreativeToken;

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

/**
 Get the expiration timestamp of materialMeta
 @warning: The value of this field is only accurate after the video is downloaded successfully or after the access is successfully obtained
 @Note :  This API is only useful in China area.
 */
- (NSTimeInterval)getExpireTimestamp;

@end

// 海外

@class PAGLInterstitialAd;

@interface PAGInterstitialRequest : PAGRequest

@end

@protocol PAGLInterstitialAdDelegate <PAGAdDelegate>

@end

/// Callback for loading interstitial results.
/// @param interstitialAd Ad instance after successfully loaded which will be non-nil on success.
/// @param error Loading error which will be non-nil on fail.
typedef void (^PAGInterstitialAdLoadCompletionHandler)(PAGLInterstitialAd * _Nullable interstitialAd,
                                                  NSError * _Nullable error);

@interface PAGLInterstitialAd : NSObject<PAGAdProtocol,PAGAdClientBiddingProtocol>

/// Ad event delegate.
@property(nonatomic, weak, nullable) id<PAGLInterstitialAdDelegate> delegate;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;


/// Load interstitial ad
/// @param slotID Required. The unique identifier of interstitial ad.
/// @param request Required. An instance of an interstitial ad request.
/// @param completionHandler Handler which will be called when the request completes.
+ (void)loadAdWithSlotID:(NSString *)slotID
                 request:(PAGInterstitialRequest *)request
       completionHandler:(PAGInterstitialAdLoadCompletionHandler)completionHandler;


/// Present the interstitial ad
/// @param rootViewController View controller the interstitial ad will be presented on.
/// @warning This method must be called on the main thread.
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END

#endif /* OMPangleInterstitialClass_h */
