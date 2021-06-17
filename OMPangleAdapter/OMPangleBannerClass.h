// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleBannerClass_h
#define OMPangleBannerClass_h

NS_ASSUME_NONNULL_BEGIN

@class BUNativeExpressBannerView;
@class BUDislikeWords;
@class BUSize;

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

@interface BUNativeExpressBannerView : UIView<BUMopubAdMarkUpDelegate>

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

NS_ASSUME_NONNULL_END

#endif /* OMPangleBannerClass_h */
