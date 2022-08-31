// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleSplashClass_h
#define OMPangleSplashClass_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OMPangleClass.h"

@class BUMaterialMeta;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BUSplashAdCloseType) {
    BUSplashAdCloseType_Unknow = 0,             // unknow
    BUSplashAdCloseType_ClickSkip = 1,          // click skip
    BUSplashAdCloseType_CountdownToZero = 2,    // countdown
    BUSplashAdCloseType_ClickAd = 3             // click Ad
};

typedef NS_ENUM(NSInteger, BUSplashAdErrorCode) {
    BUSplashAdError_Unknow = 0,
    BUSplashAdError_DataError = 1,              // data load failed
    BUSplashAdError_TimeOut = 2,                // timeout
    BUSplashAdError_RenderFailed = 3            // render failed
};

@protocol BUSplashAdDelegate;
@protocol BUSplashCardDelegate;
@protocol BUSplashZoomOutDelegate;


@class BUAdError;
@class BUSplashView;
@class BUSplashCardView;
@class BUSplashZoomOutView;


/// Please note: This Class does not take effect on Pangle global, only use it when you have traffic from mainland China.
@interface BUSplashAd : BUInterfaceBaseObject <BUMopubAdMarkUpDelegate, BUAdClientBiddingProtocol>

@property (nonatomic, weak, nullable) id<BUSplashAdDelegate> delegate;

@property (nonatomic, weak, nullable) id<BUSplashCardDelegate> cardDelegate;

@property (nonatomic, weak, nullable) id<BUSplashZoomOutDelegate> zoomOutDelegate;

/**
 Whether support splash zoomout view, default NO.
 */
@property (nonatomic, assign) BOOL supportZoomOutView;

/**
 Whether support splash card view, default NO.
 The display priority of cardview is higher than that of zoomout view.
 */
@property (nonatomic, assign) BOOL supportCardView;

/**
 Whether hide skip button, default NO.
 If you hide the skip button, you need to customize the countdown.
 */
@property (nonatomic, assign) BOOL hideSkipButton;

/// Maximum allowable load timeout, default 3s, unit s.
@property (nonatomic, assign) NSTimeInterval tolerateTimeout;

/// The unique identifier of splash ad.
@property (nonatomic, copy, readonly, nonnull) NSString *slotID;

/// media configuration parameters.
@property (nonatomic, copy, readonly) NSDictionary *mediaExt;

///
@property (nonatomic, weak, readonly, nullable) UIViewController *splashRootViewController;

/**
 When splash ad load or render failed, it will be nil.
 When splash ad cloesd, it will be released.
*/
@property (nonatomic, strong, readonly, nullable) BUSplashView *splashView;

/// When it is support splash card advertisement, it has value.
@property (nonatomic, strong, readonly, nullable) BUSplashCardView *cardView;

/// When it is support splash zoomout advertisement, it has value.
@property (nonatomic, strong, readonly, nullable) BUSplashZoomOutView *zoomOutView;

/// The screenshot of the last frame
@property (nonatomic, strong, readonly, nullable) UIView *splashViewSnapshot;


/**
 Initializes splash ad with slot id and sise.
 @param slotID : the unique identifier of splash ad
 @param adSize : the adSize of splashAd view. It is recommended for the mobile phone screen.
 @return BUSplashView
 */
- (instancetype)initWithSlotID:(NSString *)slotID adSize:(CGSize)adSize;

/**
 Initializes Splash video ad with ad slot, adSize and rootViewController.
 @param slot A object, through which you can pass in the splash unique identifier, ad type, and so on.
 @param adSize the adSize of splashAd view. It is recommended for the mobile phone screen.
 @return BUSplashView
 */
- (instancetype)initWithSlot:(BUAdSlot *)slot adSize:(CGSize)adSize;

/**
 Load splash ad datas.
 Start the countdown(@tolerateTimeout) as soon as you request datas.
 */
- (void)loadAdData;

/**
 Show splash ad view.
 Suggest call it after splash ad loaded successfully.
 You can call it at any time after loadAdData. The splash view will be added to the rootViewController only when render successfull.
 */
- (void)showSplashViewInRootViewController:(UIViewController *)viewController;

/**
 Show splash card view.
 You can call it when splashCardReadyToShow: callback.
 */
- (void)showCardViewInRootViewController:(UIViewController *)viewController;

/**
 Show splash zoomout view.
 You can call it when splashZoomOutReadyToShow: callback.
 */
- (void)showZoomOutViewInRootViewController:(UIViewController *)viewController;

/**
 Remove splash view.Stop the countdown as soon as you call this method.
 If you customize the skip button, you need to call this method to close the splash ad.
 */
- (void)removeSplashView;

/**
 Ad slot material id
 */
- (NSString *)getAdCreativeToken;

@end


@protocol BUSplashAdDelegate <NSObject>
/// This method is called when material load successful
- (void)splashAdLoadSuccess:(BUSplashAd *)splashAd;

/// This method is called when material load failed
- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error;

/// This method is called when splash view render successful
- (void)splashAdRenderSuccess:(BUSplashAd *)splashAd;

/// This method is called when splash view render failed
- (void)splashAdRenderFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error;

/// This method is called when splash view will show
- (void)splashAdWillShow:(BUSplashAd *)splashAd;

/// This method is called when splash view did show
- (void)splashAdDidShow:(BUSplashAd *)splashAd;

/// This method is called when splash card is clicked.
- (void)splashAdDidClick:(BUSplashAd *)splashAd;

/// This method is called when splash card is closed.
- (void)splashAdDidClose:(BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType;

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)splashDidCloseOtherController:(BUSplashAd *)splashAd interactionType:(BUInteractionType)interactionType;

/// This method is called when when video ad play completed or an error occurred.
- (void)splashVideoAdDidPlayFinish:(BUSplashAd *)splashAd didFailWithError:(NSError *)error;

@end


@protocol BUSplashCardDelegate <NSObject>

/// This method is called when splash card is ready to show.
- (void)splashCardReadyToShow:(BUSplashAd *)splashAd;

/// This method is called when splash card is clicked.
- (void)splashCardViewDidClick:(BUSplashAd *)splashAd;

/// This method is called when splash card is closed.
- (void)splashCardViewDidClose:(BUSplashAd *)splashAd;

@end


@protocol BUSplashZoomOutDelegate <NSObject>

/// This method is called when splash card is ready to show.
- (void)splashZoomOutReadyToShow:(BUSplashAd *)splashAd;

/// This method is called when splash ad is clicked.
- (void)splashZoomOutViewDidClick:(BUSplashAd *)splashAd;

/// This method is called when splash ad is closed.
- (void)splashZoomOutViewDidClose:(BUSplashAd *)splashAd;


@end


@interface BUAdError : NSError

@property (nonatomic, assign) BUSplashAdErrorCode errorCode;

@end


// 海外 Splash
@class PAGLAppOpenAd;
@class PAGAppOpenRequest;


@protocol PAGLAppOpenAdDelegate <PAGAdDelegate>

@end

/// Callback for loading ad results.
/// @param appOpenAd Ad instance after successfully loaded.
/// @param error Loading error.
typedef void (^PAGAppOpenADLoadCompletionHandler)(PAGLAppOpenAd * _Nullable appOpenAd,
                                                 NSError * _Nullable error);

@interface PAGLAppOpenAd : NSObject<PAGAdProtocol>

/// Ad event delegate.
@property (nonatomic, weak, nullable) id<PAGLAppOpenAdDelegate> delegate;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;


/// Load open ad
/// @param slotID Required. The unique identifier of open ad.
/// @param request Required. An instance of an open ad request.
/// @param completionHandler Handler which will be called when the request completes.
+ (void)loadAdWithSlotID:(NSString *)slotID
                 request:(PAGAppOpenRequest *)request
       completionHandler:(PAGAppOpenADLoadCompletionHandler)completionHandler;


/// Present the open ad
/// @param rootViewController View controller the open ad will be presented on.
/// @warning This method must be called on the main thread.
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END


#endif /* OMPangleSplashClass_h */
