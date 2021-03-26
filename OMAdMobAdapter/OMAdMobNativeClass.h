// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdMobNativeClass_h
#define OMAdMobNativeClass_h
#import <UIKit/UIKit.h>
#import "OMAdMobClass.h"
#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
#import <GoogleMobileAds/GoogleMobileAds.h>
#else

@class GADAdLoader;
@class GADVideoController;
@class GADNativeAdImageAdLoaderOptions;
@class GADAdLoaderOptions;
@class GADRequestError;

#if defined(__cplusplus)
#define GAD_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define GAD_EXTERN extern __attribute__((visibility("default")))
#endif  // defined(__cplusplus)

#if !defined(__has_feature)
#error "Use latest Xcode version."
#endif  // !defined(__has_feature)

#if !defined(__has_attribute)
#error "Use latest Xcode version."
#endif  // !defined(__has_attribute)

#if __has_feature(attribute_deprecated_with_message)
#define GAD_DEPRECATED_MSG_ATTRIBUTE(s) __attribute__((deprecated(s)))
#elif __has_attribute(deprecated)
#define GAD_DEPRECATED_MSG_ATTRIBUTE(s) __attribute__((deprecated))
#else
#define GAD_DEPRECATED_MSG_ATTRIBUTE(s)
#endif  // __has_feature(attribute_deprecated_with_message)

#if __has_attribute(deprecated)
#define GAD_DEPRECATED_ATTRIBUTE __attribute__((deprecated))
#else
#define GAD_DEPRECATED_ATTRIBUTE
#endif  // __has_attribute(deprecated)

#if __has_feature(nullability)  // Available starting in Xcode 6.3.
#define GAD_NULLABLE_TYPE __nullable
#define GAD_NONNULL_TYPE __nonnull
#define GAD_NULLABLE nullable
#else
#error "Use latest Xcode version."
#endif  // __has_feature(nullability)

#if __has_attribute(objc_boxable)  // Available starting in Xcode 7.3.
#define GAD_BOXABLE __attribute__((objc_boxable))
#else
#error "Use latest Xcode version."
#endif  // __has_attribute(objc_boxable)

#if defined(NS_STRING_ENUM)  // Available starting in Xcode 8.0.
#define GAD_STRING_ENUM NS_STRING_ENUM
#else
#error "Use latest Xcode version."
#endif

// Pre-Xcode 11 versions must replace UIWindowScene with NSObject.
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
#ifndef UIWindowScene
#define UIWindowScene NSObject
#endif
#endif


typedef NSString *GADNativeAssetIdentifier NS_STRING_ENUM;

GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeHeadlineAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeCallToActionAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeIconAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeBodyAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeStoreAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativePriceAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeImageAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeStarRatingAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeAdvertiserAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeMediaViewAsset;
GAD_EXTERN GADNativeAssetIdentifier _Nonnull const GADNativeAdChoicesViewAsset;

typedef NSString *GADAdLoaderAdType NS_STRING_ENUM;

/// Use with GADAdLoader to request native custom template ads. To receive ads, the ad loader's
/// delegate must conform to the GADCustomNativeAdLoaderDelegate protocol. See GADCustomNativeAd.h.
GAD_EXTERN GADAdLoaderAdType _Nonnull const kGADAdLoaderAdTypeCustomNative;

/// Use with GADAdLoader to request Google Ad Manager banner ads. To receive ads, the ad loader's
/// delegate must conform to the GAMBannerAdLoaderDelegate protocol. See GAMBannerView.h.
GAD_EXTERN GADAdLoaderAdType _Nonnull const kGADAdLoaderAdTypeGAMBanner;

/// Use with GADAdLoader to request native ads. To receive ads, the ad loader's delegate must
/// conform to the GADNativeAdLoaderDelegate protocol. See GADNativeAd.h.
GAD_EXTERN GADAdLoaderAdType _Nonnull const kGADAdLoaderAdTypeNative;

NS_ASSUME_NONNULL_BEGIN

@class GADNativeAd;

@protocol GADAdLoaderDelegate<NSObject>

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error;

@optional

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader;

@end


/// Loads ads. See GADAdLoaderAdTypes.h for available ad types.
@interface GADAdLoader : NSObject

/// Object notified when an ad request succeeds or fails. Must conform to requested ad types'
/// delegate protocols.
@property(nonatomic, weak, nullable) id<GADAdLoaderDelegate> delegate;

/// The ad loader's ad unit ID.
@property(nonatomic, readonly, nonnull) NSString *adUnitID;

/// Indicates whether the ad loader is loading.
@property(nonatomic, getter=isLoading, readonly) BOOL loading;

/// Returns an initialized ad loader configured to load the specified ad types.
///
/// @param rootViewController The root view controller is used to present ad click actions.
/// @param adTypes An array of ad types. See GADAdLoaderAdTypes.h for available ad types.
/// @param options An array of GADAdLoaderOptions objects to configure how ads are loaded, or nil
/// to use default options. See each ad type's header for available GADAdLoaderOptions subclasses.
- (nonnull instancetype)initWithAdUnitID:(nonnull NSString *)adUnitID
                      rootViewController:(nullable UIViewController *)rootViewController
                                 adTypes:(nonnull NSArray<GADAdLoaderAdType> *)adTypes
                                 options:(nullable NSArray<GADAdLoaderOptions *> *)options;

/// Loads the ad and informs the delegate of the outcome.
- (void)loadRequest:(nullable GADRequest *)request;

@end



/// Identifies native ad assets.
@protocol GADNativeAdDelegate <NSObject>

@optional

#pragma mark - Ad Lifecycle Events

/// Called when an impression is recorded for an ad. Only called for Google ads and is not supported
/// for mediated ads.
- (void)nativeAdDidRecordImpression:(nonnull GADNativeAd *)nativeAd;

/// Called when a click is recorded for an ad. Only called for Google ads and is not supported for
/// mediated ads.
- (void)nativeAdDidRecordClick:(nonnull GADNativeAd *)nativeAd;

#pragma mark - Click-Time Lifecycle Notifications

/// Called before presenting the user a full screen view in response to an ad action. Use this
/// opportunity to stop animations, time sensitive interactions, etc.
///
/// Normally the user looks at the ad, dismisses it, and control returns to your application with
/// the nativeAdDidDismissScreen: message. However, if the user hits the Home button or clicks on an
/// App Store link, your application will be backgrounded. The next method called will be the
/// applicationWillResignActive: of your UIApplicationDelegate object.
- (void)nativeAdWillPresentScreen:(nonnull GADNativeAd *)nativeAd;

/// Called before dismissing a full screen view.
- (void)nativeAdWillDismissScreen:(nonnull GADNativeAd *)nativeAd;

/// Called after dismissing a full screen view. Use this opportunity to restart anything you may
/// have stopped as part of nativeAdWillPresentScreen:.
- (void)nativeAdDidDismissScreen:(nonnull GADNativeAd *)nativeAd;

#pragma mark - Mute This Ad

/// Used for Mute This Ad feature. Called after the native ad is muted. Only called for Google ads
/// and is not supported for mediated ads.
- (void)nativeAdIsMuted:(nonnull GADNativeAd *)nativeAd;

@end


@protocol GADVideoControllerDelegate<NSObject>

@optional

- (void)videoControllerDidPlayVideo:(GADVideoController *)videoController;

- (void)videoControllerDidPauseVideo:(GADVideoController *)videoController;

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController;

- (void)videoControllerDidMuteVideo:(GADVideoController *)videoController;

- (void)videoControllerDidUnmuteVideo:(GADVideoController *)videoController;

@end

@interface GADNativeAdImage : NSObject
@property (nonatomic, readonly, strong, nullable) UIImage *image;
@property (nonatomic, readonly, copy) NSURL *imageURL;
@property (nonatomic, readonly, assign) CGFloat scale;
@end

@interface GADVideoOptions : NSObject

/// Indicates if videos should start muted. By default this property value is YES.
@property(nonatomic, assign) BOOL startMuted;

/// Indicates if the requested video should have custom controls enabled for play/pause/mute/unmute.
@property(nonatomic, assign) BOOL customControlsRequested;

/// Indicates whether the requested video should have the click to expand behavior.
@property(nonatomic, assign) BOOL clickToExpandRequested;

@end

@class GADMediaContent;
@class GADAdChoicesView;
@class GADMediaView;
@class GADMuteThisAdReason;
@class GADResponseInfo;


@interface GADNativeAd : NSObject

#pragma mark - Must be displayed if available

/// Headline.
@property(nonatomic, readonly, copy, nullable) NSString *headline;

#pragma mark - Recommended to display

/// Text that encourages user to take some action with the ad. For example "Install".
@property(nonatomic, readonly, copy, nullable) NSString *callToAction;
/// Icon image.
@property(nonatomic, readonly, strong, nullable) GADNativeAdImage *icon;
/// Description.
@property(nonatomic, readonly, copy, nullable) NSString *body;
/// Array of GADNativeAdImage objects.
@property(nonatomic, readonly, strong, nullable) NSArray<GADNativeAdImage *> *images;
/// App store rating (0 to 5).
@property(nonatomic, readonly, copy, nullable) NSDecimalNumber *starRating;
/// The app store name. For example, "App Store".
@property(nonatomic, readonly, copy, nullable) NSString *store;
/// String representation of the app's price.
@property(nonatomic, readonly, copy, nullable) NSString *price;
/// Identifies the advertiser. For example, the advertiser’s name or visible URL.
@property(nonatomic, readonly, copy, nullable) NSString *advertiser;
/// Media content. Set the associated media view's mediaContent property to this object to display
/// this content.
@property(nonatomic, readonly, nonnull) GADMediaContent *mediaContent;

#pragma mark - Other properties

/// Optional delegate to receive state change notifications.
@property(nonatomic, weak, nullable) id<GADNativeAdDelegate> delegate;

/// Reference to a root view controller that is used by the ad to present full screen content after
/// the user interacts with the ad. The root view controller is most commonly the view controller
/// displaying the ad.
@property(nonatomic, weak, nullable) UIViewController *rootViewController;

/// Dictionary of assets which aren't processed by the receiver.
@property(nonatomic, readonly, copy, nullable) NSDictionary<NSString *, id> *extraAssets;

/// Information about the ad response that returned the ad.
@property(nonatomic, readonly, nonnull) GADResponseInfo *responseInfo;


/// Indicates whether custom Mute This Ad is available for the native ad.
@property(nonatomic, readonly, getter=isCustomMuteThisAdAvailable) BOOL customMuteThisAdAvailable;

/// An array of Mute This Ad reasons used to render customized mute ad survey. Use this array to
/// implement your own Mute This Ad feature only when customMuteThisAdAvailable is YES.
@property(nonatomic, readonly, nullable) NSArray<GADMuteThisAdReason *> *muteThisAdReasons;

/// Registers ad view, clickable asset views, and nonclickable asset views with this native ad.
/// Media view shouldn't be registered as clickable.
/// @param clickableAssetViews Dictionary of asset views that are clickable, keyed by asset IDs.
/// @param nonclickableAssetViews Dictionary of asset views that are not clickable, keyed by asset
///        IDs.
- (void)registerAdView:(nonnull UIView *)adView
       clickableAssetViews:
           (nonnull NSDictionary<GADNativeAssetIdentifier, UIView *> *)clickableAssetViews
    nonclickableAssetViews:
        (nonnull NSDictionary<GADNativeAssetIdentifier, UIView *> *)nonclickableAssetViews;

/// Unregisters ad view from this native ad. The corresponding asset views will also be
/// unregistered.
- (void)unregisterAdView;

/// Reports the mute event with the mute reason selected by user. Use nil if no reason was selected.
/// Call this method only if customMuteThisAdAvailable is YES.
- (void)muteThisAdWithReason:(nullable GADMuteThisAdReason *)reason;

@end

#pragma mark - Protocol and constants

/// The delegate of a GADAdLoader object implements this protocol to receive GADNativeAd ads.
@protocol GADNativeAdLoaderDelegate <GADAdLoaderDelegate>
/// Called when a native ad is received.
- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveNativeAd:(nonnull GADNativeAd *)nativeAd;
@end

@interface GADVideoController : NSObject
@property (nonatomic, weak, nullable) id<GADVideoControllerDelegate> delegate;
- (BOOL)hasVideoContent;
- (double)aspectRatio;
@end



//view


#pragma mark - Native Ad View

/// Base class for native ad views. Your native ad view must be a subclass of this class and must
/// call superclass methods for all overridden methods.
@interface GADNativeAdView : UIView

/// This property must point to the native ad object rendered by this ad view.
@property(nonatomic, strong, nullable) GADNativeAd *nativeAd;

/// Weak reference to your ad view's headline asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *headlineView;
/// Weak reference to your ad view's call to action asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *callToActionView;
/// Weak reference to your ad view's icon asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *iconView;
/// Weak reference to your ad view's body asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *bodyView;
/// Weak reference to your ad view's store asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *storeView;
/// Weak reference to your ad view's price asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *priceView;
/// Weak reference to your ad view's image asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *imageView;
/// Weak reference to your ad view's star rating asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *starRatingView;
/// Weak reference to your ad view's advertiser asset view.
@property(nonatomic, weak, nullable) IBOutlet UIView *advertiserView;
/// Weak reference to your ad view's media asset view.
@property(nonatomic, weak, nullable) IBOutlet GADMediaView *mediaView;
/// Weak reference to your ad view's AdChoices view. Must set adChoicesView before setting
/// nativeAd, otherwise AdChoices will be rendered according to the preferredAdChoicesPosition
/// defined in GADNativeAdViewAdOptions.
@property(nonatomic, weak, nullable) IBOutlet GADAdChoicesView *adChoicesView;

@end


@interface GADAdLoaderOptions : NSObject
@end

/// Native ad image orientation preference.
typedef NS_ENUM(NSInteger, GADNativeAdImageAdLoaderOptionsOrientation) {
    GADNativeAdImageAdLoaderOptionsOrientationAny = 1,       ///< No orientation preference.
    GADNativeAdImageAdLoaderOptionsOrientationPortrait = 2,  ///< Prefer portrait images.
    GADNativeAdImageAdLoaderOptionsOrientationLandscape = 3  ///< Prefer landscape images.
};



/// Ad loader options for native ad image settings.
@interface GADNativeAdImageAdLoaderOptions : GADAdLoaderOptions

/// Indicates whether image asset content should be loaded by the SDK. If set to YES, the SDK will
/// not load image asset content and native ad image URLs can be used to fetch content. Defaults to
/// NO, image assets are loaded by the SDK.
@property(nonatomic, assign) BOOL disableImageLoading;

/// Indicates whether multiple images should be loaded for each asset. Defaults to NO.
@property(nonatomic, assign) BOOL shouldRequestMultipleImages;

@end

/// Ad loader options for requesting multiple ads. Requesting multiple ads in a single request is
/// currently only available for native app install ads and native content ads.
@interface GADMultipleAdsAdLoaderOptions : GADAdLoaderOptions

/// Number of ads the GADAdLoader should attempt to return for the request. By default, numberOfAds
/// is one. Requests are invalid and will fail if numberOfAds is less than one. If numberOfAds
/// exceeds the maximum limit (5), only the maximum number of ads are requested.
///
/// The ad loader makes at least one and up to numberOfAds calls to the "ad received" and
/// -didFailToReceiveAdWithError: methods found in GADAdLoaderDelegate and its extensions, followed
/// by a single call to -adLoaderDidFinishLoading: once loading is finished.
@property(nonatomic) NSInteger numberOfAds;

@end


@interface GADNativeAdMediaAdLoaderOptions : GADAdLoaderOptions
@property (assign, readwrite, nonatomic) NSInteger mediaAspectRatio;
@end

NS_ASSUME_NONNULL_END

#endif

#endif /* OMAdMobNativeClass_h */
