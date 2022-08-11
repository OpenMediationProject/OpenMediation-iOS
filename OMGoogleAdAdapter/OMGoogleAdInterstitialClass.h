// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMGoogleAdInterstitialClass_h
#define OMGoogleAdInterstitialClass_h
#import <UIKit/UIKit.h>
#import "OMGoogleAdClass.h"
#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
#import <GoogleMobileAds/GoogleMobileAds.h>
#else

NS_ASSUME_NONNULL_BEGIN

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

/// Tells the delegate that a click has been recorded for the ad.
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad;

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error;

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad;

/// Tells the delegate that the ad will dismiss full screen content.
- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad;

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad;

@end


@class GADInterstitialAd;

/// A block to be executed when the ad request operation completes. On success,
/// interstitialAd is non-nil and |error| is nil. On failure, interstitialAd is nil
/// and |error| is non-nil.
typedef void (^GADInterstitialAdLoadCompletionHandler)(GADInterstitialAd *_Nullable interstitialAd,
                                                       NSError *_Nullable error);

/// An interstitial ad. This is a full-screen advertisement shown at natural transition points in
/// your application such as between game levels or news stories. See
/// https://developers.google.com/admob/ios/interstitial to get started.
@interface GADInterstitialAd : NSObject <GADFullScreenPresentingAd>

/// The ad unit ID.
@property(nonatomic, readonly, nonnull) NSString *adUnitID;

/// Information about the ad response that returned the ad.
@property(nonatomic, readonly, nonnull) GADResponseInfo *responseInfo;

/// Delegate for handling full screen content messages.
@property(nonatomic, weak, nullable) id<GADFullScreenContentDelegate> fullScreenContentDelegate;

/// Loads an interstitial ad.
///
/// @param adUnitID An ad unit ID created in the AdMob or Ad Manager UI.
/// @param request An ad request object. If nil, a default ad request object is used.
/// @param completionHandler A handler to execute when the load operation finishes or times out.
+ (void)loadWithAdUnitID:(nonnull NSString *)adUnitID
                 request:(nullable GADRequest *)request
       completionHandler:(nonnull GADInterstitialAdLoadCompletionHandler)completionHandler;

/// Returns whether the interstitial ad can be presented from the provided root view
/// controller. Sets the error out parameter if the ad can't be presented. Must be called on the
/// main thread.
- (BOOL)canPresentFromRootViewController:(nonnull UIViewController *)rootViewController
                                   error:(NSError *_Nullable __autoreleasing *_Nullable)error;

/// Presents the interstitial ad. Must be called on the main thread.
///
/// @param rootViewController A view controller to present the ad.
- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController;

@end

@class GAMInterstitialAd;

typedef void (^GAMInterstitialAdLoadCompletionHandler)(GAMInterstitialAd *_Nullable interstitialAd,
                                                       NSError *_Nullable error);

/// Google Ad Manager interstitial ad, a full-screen advertisement shown at natural
/// transition points in your application such as between game levels or news stories.
@interface GAMInterstitialAd : GADInterstitialAd

/// Optional delegate that is notified when creatives send app events.
@property(nonatomic, weak, nullable) id<GADAppEventDelegate> appEventDelegate;

/// Loads an interstitial ad.
///
/// @param adUnitID An ad unit ID created in the Ad Manager UI.
/// @param request An ad request object. If nil, a default ad request object is used.
/// @param completionHandler A handler to execute when the load operation finishes or times out.
+ (void)loadWithAdManagerAdUnitID:(nonnull NSString *)adUnitID
                          request:(nullable GAMRequest *)request
                completionHandler:(nonnull GAMInterstitialAdLoadCompletionHandler)completionHandler;

+ (void)loadWithAdUnitID:(nonnull NSString *)adUnitID
                 request:(nullable GADRequest *)request
       completionHandler:(nonnull GADInterstitialAdLoadCompletionHandler)completionHandler
    NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

#endif

#endif /* OMGoogleAdInterstitialClass_h */
