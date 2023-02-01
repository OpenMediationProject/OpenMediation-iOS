// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdMobInterstitialClass_h
#define OMAdMobInterstitialClass_h
#import <UIKit/UIKit.h>
#import "OMAdMobClass.h"
#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
#import <GoogleMobileAds/GoogleMobileAds.h>
#else

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END

#endif

#endif /* OMAdMobInterstitialClass_h */
