// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdMobNativeClass_h
#define OMAdMobNativeClass_h
#import <UIKit/UIKit.h>
#import "OMAdMobClass.h"
@class GADAdLoader;
@class GADUnifiedNativeAd;
@class GADVideoController;
@class GADNativeAdImageAdLoaderOptions;
@class GADAdLoaderOptions;
@class GADRequestError;

NS_ASSUME_NONNULL_BEGIN

@protocol GADAdLoaderDelegate<NSObject>

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error;

@optional

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader;

@end

@protocol GADUnifiedNativeAdLoaderDelegate<GADAdLoaderDelegate>

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd;
@end


@interface GADAdLoader : NSObject

@property(nonatomic, weak, nullable) id<GADAdLoaderDelegate> delegate;
- (instancetype)initWithAdUnitID:(NSString *)adUnitID
              rootViewController:(nullable UIViewController *)rootViewController
                         adTypes:(NSArray *)adTypes
                         options:(nullable NSArray *)options;

- (void)loadRequest:(nullable GADRequest *)request;

@end



//NativeAd
@protocol GADUnifiedNativeAdDelegate<NSObject>

@optional

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd;

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd;

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd;

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd;

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd;

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd;

- (void)nativeAdIsMuted:(GADUnifiedNativeAd *)nativeAd;

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

@interface GADUnifiedNativeAd : NSObject
@property (nonatomic, readonly, copy, nullable) NSString *headline;
@property (nonatomic, readonly, copy, nullable) NSString *callToAction;
@property (nonatomic, readonly, strong, nullable) GADNativeAdImage *icon;
@property (nonatomic, readonly, copy, nullable) NSString *body;
@property (nonatomic, readonly, strong, nullable) NSArray<GADNativeAdImage *> *images;
@property (nonatomic, readonly, copy, nullable) NSDecimalNumber *starRating;
@property (nonatomic, readonly, copy, nullable) NSString *store;
@property (nonatomic, readonly, copy, nullable) NSString *price;
@property (nonatomic, readonly, copy, nullable) NSString *advertiser;

@property(nonatomic, weak, nullable) id<GADUnifiedNativeAdDelegate> delegate;
@property(nonatomic, strong, readonly, nullable) GADVideoController *videoController;
@end

@interface GADVideoController : NSObject
@property (nonatomic, weak, nullable) id<GADVideoControllerDelegate> delegate;
- (BOOL)hasVideoContent;
- (double)aspectRatio;
@end



//view

@interface GADMediaView : UIView

@end

@interface GADUnifiedNativeAdView : UIView

@property (nonatomic, strong) GADUnifiedNativeAd *nativeAd;
@property(nonatomic, weak, nullable) UIView *headlineView;
@property (nonatomic, strong) UIView *mediaView;
@property (nonatomic, weak, nullable) id<GADUnifiedNativeAdDelegate> delegate;

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

/// Indicates preferred image orientation. Defaults to
/// GADNativeAdImageAdLoaderOptionsOrientationAny.
@property(nonatomic, assign) GADNativeAdImageAdLoaderOptionsOrientation preferredImageOrientation;

@end

@interface GADNativeAdMediaAdLoaderOptions : GADAdLoaderOptions
@property (assign, readwrite, nonatomic) NSInteger mediaAspectRatio;
@end

NS_ASSUME_NONNULL_END

#endif /* OMAdMobNativeClass_h */
