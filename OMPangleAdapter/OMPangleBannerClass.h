// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleBannerClass_h
#define OMPangleBannerClass_h
#import "OMPangleClass.h"

NS_ASSUME_NONNULL_BEGIN

@class BUNativeExpressBannerView;
@class BUDislikeWords;

@protocol BUNativeExpressBannerViewDelegate <NSObject>

@optional
/**
 This method is called when bannerAdView ad slot loaded successfully.
 @param bannerAdView : view for bannerAdView
 */
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView;

/**
 This method is called when bannerAdView ad slot failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error;

/**
 This method is called when rendering a nativeExpressAdView successed.
 */
- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView;

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError * __nullable)error;

/**
 This method is called when bannerAdView ad slot showed new ad.
 */
- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView;

/**
 This method is called when bannerAdView is clicked.
 */
- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView;

/**
 This method is called when the user clicked dislike button and chose dislike reasons.
 @param filterwords : the array of reasons for dislike.
 */
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords;

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressBannerAdViewDidCloseOtherController:(BUNativeExpressBannerView *)bannerAdView interactionType:(BUInteractionType)interactionType;

/**
 This method is called when the Ad view container is forced to be removed.
 @param bannerAdView : Express Banner Ad view container
 */
- (void)nativeExpressBannerAdViewDidRemoved:(BUNativeExpressBannerView *)bannerAdView;
@end

 __attribute__((objc_subclassing_restricted))
@interface BUNativeExpressBannerView : BUInterfaceBaseView <BUMopubAdMarkUpDelegate, BUAdClientBiddingProtocol>

@property (nonatomic, weak, nullable) id<BUNativeExpressBannerViewDelegate> delegate;

/**
 The carousel interval, in seconds, is set in the range of 30~120s, and is passed during initialization. If it does not meet the requirements, it will not be in carousel ad.
 */
@property (nonatomic, assign, readonly) NSInteger interval;

/// media configuration parameters.
@property (nonatomic, copy, readonly) NSDictionary *mediaExt;

/**
 Initializes express banner ad.
 @param slotID The unique identifier of banner ad.
 @param rootViewController The root controller where the banner is located.
 @param adsize Customize the size of the view. Please make sure that the width and height passed in are available.
 @return BUNativeExpressBannerView
 */
- (instancetype)initWithSlotID:(NSString *)slotID
            rootViewController:(UIViewController *)rootViewController
                        adSize:(CGSize)adsize;

/**
 Initializes carousel express banner ad.
 @param slotID The unique identifier of banner ad.
 @param rootViewController The root controller where the banner is located.
 @param adsize Customize the size of the view. Please make sure that the width and height passed in are available.
 @param interval The carousel interval, in seconds, is set in the range of 30~120s, and is passed during initialization. If it does not meet the requirements, it will not be in carousel ad.
 @return BUNativeExpressBannerView
 */
- (instancetype)initWithSlotID:(NSString *)slotID
            rootViewController:(UIViewController *)rootViewController
                        adSize:(CGSize)adsize
                      interval:(NSInteger)interval;

/**
 Initializes express banner ad.
 @param slot A object, through which you can pass in the banner unique identifier, ad type, and so on
 @param rootViewController The root controller where the banner is located.
 @param adsize Customize the size of the view. Please make sure that the width and height passed in are available.
 @return BUNativeExpressBannerView
 */
- (instancetype)initWithSlot:(BUAdSlot *)slot
            rootViewController:(UIViewController *)rootViewController
                      adSize:(CGSize)adsize;

/**
 Initializes carousel express banner ad.
 @param slot A object, through which you can pass in the banner unique identifier, ad type, and so on
 @param rootViewController The root controller where the banner is located.
 @param adsize Customize the size of the view. Please make sure that the width and height passed in are available.
 @param interval The carousel interval, in seconds, is set in the range of 30~120s, and is passed during initialization. If it does not meet the requirements, it will not be in carousel ad.
 @return BUNativeExpressBannerView
 */
- (instancetype)initWithSlot:(BUAdSlot *)slot
            rootViewController:(UIViewController *)rootViewController
                        adSize:(CGSize)adsize
                      interval:(NSInteger)interval;

- (void)loadAdData;

/**
 Ad slot material id
 */
- (NSString *)getAdCreativeToken;

@end

@interface BUNativeExpressBannerView (Deprecated)
- (instancetype)initWithSlotID:(NSString *)slotID
            rootViewController:(UIViewController *)rootViewController
                        adSize:(CGSize)adsize
             IsSupportDeepLink:(BOOL)isSupportDeepLink DEPRECATED_MSG_ATTRIBUTE("Use initWithSlotID:rootViewController:adSize: instead.");
- (instancetype)initWithSlotID:(NSString *)slotID
            rootViewController:(UIViewController *)rootViewController
                        adSize:(CGSize)adsize
             IsSupportDeepLink:(BOOL)isSupportDeepLink
                      interval:(NSInteger)interval DEPRECATED_MSG_ATTRIBUTE("Use initWithSlotID:rootViewController:adSize:interval: instead.");
@end


struct PAGAdSize {
    CGSize size;
};

typedef struct PAGAdSize PAGBannerAdSize;

CG_EXTERN PAGBannerAdSize const kPAGBannerSize320x50;
CG_EXTERN PAGBannerAdSize const kPAGBannerSize300x250;
/// Only for iPad banner ad
CG_EXTERN PAGBannerAdSize const kPAGBannerSize728x90;

// 海外
@class PAGBannerAd;

@protocol PAGBannerAdDelegate <PAGAdDelegate>

@end

@interface PAGBannerRequest : PAGRequest

+(instancetype)request UNAVAILABLE_ATTRIBUTE;
+ (instancetype)requestWithBannerSize:(PAGBannerAdSize)bannerSize;

@end

/// Callback for loading ad results.
/// @param bannerAd Ad instance after successfully loaded which will be non-nil on success.
/// @param error Loading error which will be non-nil on fail.
typedef void (^PAGBannerADLoadCompletionHandler)(PAGBannerAd * _Nullable bannerAd,
                                                  NSError * _Nullable error);

@interface PAGBannerAd : NSObject<PAGAdProtocol,PAGAdClientBiddingProtocol>

/// Ad event delegate.
@property (nonatomic, weak, nullable) id<PAGBannerAdDelegate> delegate;
/// View of the banner ad.
@property (nonatomic, strong, readonly) UIView *bannerView;
/// View controller the banner ad will be presented on.
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;


/// Load banner ad
/// @param slotID Required. The unique identifier of banner ad.
/// @param request Required. An instance of a banner ad request.
/// @param completionHandler Handler which will be called when the request completes.
+ (void)loadAdWithSlotID:(NSString *)slotID
                 request:(PAGBannerRequest *)request
       completionHandler:(PAGBannerADLoadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END

#endif /* OMPangleBannerClass_h */
