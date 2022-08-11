// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMGoogleAdBannerClass_h
#define OMGoogleAdBannerClass_h
#import "OMGoogleAdClass.h"
#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
#import <GoogleMobileAds/GoogleMobileAds.h>
#else
@class GADBannerView;
@class GADRequest;
@class GADRequestError;


@protocol GADBannerViewDelegate <NSObject>

@optional

#pragma mark Ad Request Lifecycle Notifications

/// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
/// the banner view to the view hierarchy if it hasn't been added yet.
- (void)bannerViewDidReceiveAd:(nonnull GADBannerView *)bannerView;

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)bannerView:(nonnull GADBannerView *)bannerView
    didFailToReceiveAdWithError:(nonnull NSError *)error;

/// Tells the delegate that an impression has been recorded for an ad.
- (void)bannerViewDidRecordImpression:(nonnull GADBannerView *)bannerView;


/// Tells the delegate that a click has been recorded for the ad.
- (void)bannerViewDidRecordClick:(nonnull GADBannerView *)bannerView;

#pragma mark Click-Time Lifecycle Notifications

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)bannerViewWillPresentScreen:(nonnull GADBannerView *)bannerView;

/// Tells the delegate that the full screen view will be dismissed.
- (void)bannerViewWillDismissScreen:(nonnull GADBannerView *)bannerView;

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling bannerViewWillPresentScreen:.
- (void)bannerViewDidDismissScreen:(nonnull GADBannerView *)bannerView;

@end

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

typedef struct GAD_BOXABLE GADAdSize GADAdSize;

/// Ad size.
///
/// @see typedef GADAdSize
struct GAD_BOXABLE GADAdSize {
  /// The ad size. Don't modify this value directly.
  CGSize size;
  /// Reserved.
  NSUInteger flags;
};

#pragma mark Standard Sizes

/// iPhone and iPod Touch ad size. Typically 320x50.
GAD_EXTERN GADAdSize const kGADAdSizeBanner;

/// Taller version of kGADAdSizeBanner. Typically 320x100.
GAD_EXTERN GADAdSize const kGADAdSizeLargeBanner;

/// Medium Rectangle size for the iPad (especially in a UISplitView's left pane). Typically 300x250.
GAD_EXTERN GADAdSize const kGADAdSizeMediumRectangle;

/// Full Banner size for the iPad (especially in a UIPopoverController or in
/// UIModalPresentationFormSheet). Typically 468x60.
GAD_EXTERN GADAdSize const kGADAdSizeFullBanner;

/// Leaderboard size for the iPad. Typically 728x90.
GAD_EXTERN GADAdSize const kGADAdSizeLeaderboard;

/// Skyscraper size for the iPad. Mediation only. AdMob/Google does not offer this size. Typically
/// 120x600.
GAD_EXTERN GADAdSize const kGADAdSizeSkyscraper;

/// An ad size that spans the full width of its container, with a height dynamically determined by
/// the ad.
GAD_EXTERN GADAdSize const kGADAdSizeFluid;

/// Invalid ad size marker.
GAD_EXTERN GADAdSize const kGADAdSizeInvalid;

#pragma mark Adaptive Sizes

/// Returns a GADAdSize with the given width and a Google-optimized height to create a banner ad.
/// The size returned has an aspect ratio similar to that of kGADAdSizeBanner, suitable for
/// anchoring near the top or bottom of your app. The height is never larger than 15% of the
/// device's portrait height and is always between 50-90 points. This function always returns the
/// same height for any width / device combination.
GAD_EXTERN GADAdSize GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(CGFloat width);

/// Returns a GADAdSize with the given width and a Google-optimized height to create a banner ad.
/// The size returned is suitable for use in a banner ad anchored near the top or bottom of your
/// app, similar to use of kGADAdSizeBanner. The height is never larger than 15% of the devices's
/// landscape height and is always between 50-90 points. This function always returns the same
/// height for any width / device combination.
GAD_EXTERN GADAdSize GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(CGFloat width);

/// Returns a GADAdSize with the given width and a Google-optimized height. This is a convenience
/// function to return GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth or
/// GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth based on the current interface orientation.
/// This function must be called on the main queue.
GAD_EXTERN GADAdSize GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(CGFloat width);

#pragma mark Custom Sizes

/// Returns a custom GADAdSize for the provided CGSize. Use this only if you require a non-standard
/// size. Otherwise, use one of the standard size constants above.
GAD_EXTERN GADAdSize GADAdSizeFromCGSize(CGSize size);

/// Returns a custom GADAdSize that spans the full width of the application in portrait orientation
/// with the height provided.
GAD_EXTERN GADAdSize GADAdSizeFullWidthPortraitWithHeight(CGFloat height);

/// Returns a custom GADAdSize that spans the full width of the application in landscape orientation
/// with the height provided.
GAD_EXTERN GADAdSize GADAdSizeFullWidthLandscapeWithHeight(CGFloat height);

#pragma mark Convenience Functions

/// Returns YES if the two GADAdSizes are equal, otherwise returns NO.
GAD_EXTERN BOOL GADAdSizeEqualToSize(GADAdSize size1, GADAdSize size2);

/// Returns a CGSize for the provided a GADAdSize constant. If the GADAdSize is unknown, returns
/// CGSizeZero.
GAD_EXTERN CGSize CGSizeFromGADAdSize(GADAdSize size);

/// Returns YES if |size| is one of the predefined constants or is a custom GADAdSize generated by
/// GADAdSizeFromCGSize.
GAD_EXTERN BOOL IsGADAdSizeValid(GADAdSize size);

/// Returns YES if |size| is a fluid ad size.
GAD_EXTERN BOOL GADAdSizeIsFluid(GADAdSize size);

/// Returns a NSString describing the provided GADAdSize.
GAD_EXTERN NSString *_Nonnull NSStringFromGADAdSize(GADAdSize size);

/// Returns an NSValue representing the GADAdSize.
GAD_EXTERN NSValue *_Nonnull NSValueFromGADAdSize(GADAdSize size);

/// Returns a GADAdSize from an NSValue. Returns kGADAdSizeInvalid if the value is not a GADAdSize.
GAD_EXTERN GADAdSize GADAdSizeFromNSValue(NSValue *_Nonnull value);

#pragma mark Deprecated

/// An ad size that spans the full width of the application in portrait orientation. The height is
/// typically 50 points on an iPhone/iPod UI, and 90 points tall on an iPad UI.
GAD_EXTERN GADAdSize const kGADAdSizeSmartBannerPortrait
    GAD_DEPRECATED_MSG_ATTRIBUTE("Use GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth.");

/// An ad size that spans the full width of the application in landscape orientation. The height is
/// typically 32 points on an iPhone/iPod UI, and 90 points tall on an iPad UI.
GAD_EXTERN GADAdSize const kGADAdSizeSmartBannerLandscape
    GAD_DEPRECATED_MSG_ATTRIBUTE("Use GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth");


@interface GADBannerView : UIView

/// Initializes and returns a banner view with the specified ad size and origin relative to the
/// banner's superview.
- (nonnull instancetype)initWithAdSize:(GADAdSize)adSize origin:(CGPoint)origin;

/// Initializes and returns a banner view with the specified ad size placed at its superview's
/// origin.
- (nonnull instancetype)initWithAdSize:(GADAdSize)adSize;

@property(nonatomic, copy, nullable) IBInspectable NSString *adUnitID;

@property(nonatomic, weak, nullable) UIViewController *rootViewController;

@property(nonatomic, readonly, nullable) GADResponseInfo *responseInfo;

@property(nonatomic, weak, nullable) id<GADBannerViewDelegate> delegate;

- (void)loadRequest:(nullable GADRequest *)request;

@end


@class GADAdLoader;
@class GAMBannerView;

@protocol GADAdLoaderDelegate<NSObject>

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error;

@optional

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader;

@end

/// The delegate of a GADAdLoader object must conform to this protocol to receive GAMBannerViews.
@protocol GAMBannerAdLoaderDelegate <GADAdLoaderDelegate>

/// Asks the delegate which banner ad sizes should be requested.
- (nonnull NSArray<NSValue *> *)validBannerSizesForAdLoader:(nonnull GADAdLoader *)adLoader;

/// Tells the delegate that a Google Ad Manager banner ad was received.
- (void)adLoader:(nonnull GADAdLoader *)adLoader
    didReceiveGAMBannerView:(nonnull GAMBannerView *)bannerView;

@end


@class GADVideoController;
@class GADAdLoaderOptions;

/// The class implementing this protocol will be notified when the GADBannerView's ad content
/// changes size. Any views that may be affected by the banner size change will have time to adjust.
@protocol GADAdSizeDelegate <NSObject>

/// Called before the ad view changes to the new size.
- (void)adView:(nonnull GADBannerView *)bannerView willChangeAdSizeTo:(GADAdSize)size;

@end


@interface GAMBannerView : GADBannerView

@property(nonatomic, copy, nullable) NSString *adUnitID;

/// Optional delegate that is notified when creatives send app events.
@property(nonatomic, weak, nullable) IBOutlet id<GADAppEventDelegate> appEventDelegate;

/// Optional delegate that is notified when creatives cause the banner to change size.
@property(nonatomic, weak, nullable) IBOutlet id<GADAdSizeDelegate> adSizeDelegate;

/// Optional array of NSValue encoded GADAdSize structs, specifying all valid sizes that are
/// appropriate for this slot. Never create your own GADAdSize directly. Use one of the predefined
/// standard ad sizes (such as GADAdSizeBanner), or create one using the GADAdSizeFromCGSize
/// method.
///
/// Example:
///
///   \code
///   NSArray *validSizes = @[
///     NSValueFromGADAdSize(GADAdSizeBanner),
///     NSValueFromGADAdSize(GADAdSizeLargeBanner)
///   ];
///
///   bannerView.validAdSizes = validSizes;
///   \endcode
@property(nonatomic, copy, nullable) NSArray<NSValue *> *validAdSizes;

/// Indicates that the publisher will record impressions manually when the ad becomes visible to the
/// user.
@property(nonatomic) BOOL enableManualImpressions;

/// Video controller for controlling video rendered by this ad view.
@property(nonatomic, readonly, nonnull) GADVideoController *videoController;

/// If you've set enableManualImpressions to YES, call this method when the ad is visible.
- (void)recordImpression;

/// Use this function to resize the banner view without launching a new ad request.
- (void)resize:(GADAdSize)size;

/// Sets options that configure ad loading.
///
/// @param adOptions An array of GADAdLoaderOptions objects. The array is deep copied and option
/// objects cannot be modified after calling this method.
- (void)setAdOptions:(nonnull NSArray<GADAdLoaderOptions *> *)adOptions;

@end

#endif

#endif /* OMGoogleAdBannerClass_h */
