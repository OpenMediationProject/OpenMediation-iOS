// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMGoogleAdSplashClass_h
#define OMGoogleAdSplashClass_h
#import <UIKit/UIKit.h>
#import "OMGoogleAdClass.h"
#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
#import <GoogleMobileAds/GoogleMobileAds.h>
#else

@class GADRequest;
@class GADResponseInfo;

typedef NS_ENUM(NSInteger, GADAdValuePrecision) {
  /// An ad value with unknown precision.
  GADAdValuePrecisionUnknown = 0,
  /// An ad value estimated from aggregated data.
  GADAdValuePrecisionEstimated = 1,
  /// A publisher-provided ad value, such as manual CPMs in a mediation group.
  GADAdValuePrecisionPublisherProvided = 2,
  /// The precise value paid for this ad.
  GADAdValuePrecisionPrecise = 3
};

@class GADAdValue;

/// Handles ad events that are estimated to have earned money.
typedef void (^GADPaidEventHandler)(GADAdValue *_Nonnull value);

/// The monetary value earned from an ad.
@interface GADAdValue : NSObject <NSCopying>

/// The precision of the reported ad value.
@property(nonatomic, readonly) GADAdValuePrecision precision;

/// The ad's value.
@property(nonatomic, nonnull, readonly) NSDecimalNumber *value;

/// The value's currency code.
@property(nonatomic, nonnull, readonly) NSString *currencyCode;

@end

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


@class GADAppOpenAd;

/// The handler block to execute when the ad load operation completes. On failure, the
/// appOpenAd is nil and the |error| is non-nil. On success, the appOpenAd is non-nil and the
/// |error| is nil.
typedef void (^GADAppOpenAdLoadCompletionHandler)(GADAppOpenAd *_Nullable appOpenAd,
                                                  NSError *_Nullable error);

/// An app open ad. Used to monetize app load screens.
@interface GADAppOpenAd : NSObject <GADFullScreenPresentingAd>

/// Loads an app open ad.
///
/// @param adUnitID An ad unit ID created in the AdMob or Ad Manager UI.
/// @param request An ad request object. If nil, a default ad request object is used.
/// @param completionHandler A handler to execute when the load operation finishes or times out.
+ (void)loadWithAdUnitID:(nonnull NSString *)adUnitID
                 request:(nullable GADRequest *)request
       completionHandler:(nonnull GADAppOpenAdLoadCompletionHandler)completionHandler;

/// Optional delegate object that receives notifications about presentation and dismissal of full
/// screen content from this ad. Full screen content covers your application's content. The delegate
/// may want to pause animations and time sensitive interactions. Set this delegate before
/// presenting the ad.
@property(nonatomic, weak, nullable) id<GADFullScreenContentDelegate> fullScreenContentDelegate;

/// Information about the ad response that returned the ad.
@property(nonatomic, readonly, nonnull) GADResponseInfo *responseInfo;

/// Called when the ad is estimated to have earned money. Available for allowlisted accounts only.
@property(nonatomic, nullable, copy) GADPaidEventHandler paidEventHandler;

/// Returns whether the app open ad can be presented from the provided root view controller. Sets
/// the error out parameter if the app open ad can't be presented. Must be called on the main
/// thread.
- (BOOL)canPresentFromRootViewController:(nonnull UIViewController *)rootViewController
                                   error:(NSError *_Nullable __autoreleasing *_Nullable)error;

/// Presents the app open ad with the provided view controller. Must be called on the main thread.
- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController;

#pragma mark - Deprecated
/// Deprecated. Use +loadWithAdUnitID:request:completionHandler instead.
+ (void)loadWithAdUnitID:(nonnull NSString *)adUnitID
                 request:(nullable GADRequest *)request
             orientation:(UIInterfaceOrientation)orientation
       completionHandler:(nonnull GADAppOpenAdLoadCompletionHandler)completionHandler;

@end

#endif

#endif /* OMGoogleAdSplashClass_h */
