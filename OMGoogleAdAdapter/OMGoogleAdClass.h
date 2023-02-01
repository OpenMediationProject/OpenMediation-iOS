// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMGoogleAdClass_h
#define OMGoogleAdClass_h
#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
#import <GoogleMobileAds/GoogleMobileAds.h>
#else

NS_ASSUME_NONNULL_BEGIN

@protocol GADAdNetworkExtras <NSObject>
@end

@interface GADExtras : NSObject <GADAdNetworkExtras>

/// Additional parameters to be sent to Google networks.
@property(nonatomic, copy, nullable) NSDictionary *additionalParameters;

@end

@interface GADRequest : NSObject<NSCopying>

+ (nonnull NSString *)sdkVersion;
+ (instancetype)request;
- (void)registerAdNetworkExtras:(nonnull id<GADAdNetworkExtras>)extras;

@end

@interface GADResponseInfo : NSObject

/// A class name that identifies the ad network that returned the ad. Nil if no ad was returned.
@property(nonatomic, readonly, nullable) NSString *adNetworkClassName;

@end

@interface GADRequestError : NSError

@end

@class GADInitializationStatus;

typedef void (^GADInitializationCompletionHandler)(GADInitializationStatus *_Nonnull status);

@interface GADRequestConfiguration : NSObject
- (void)tagForUnderAgeOfConsent:(BOOL)underAgeOfConsent;
- (void)tagForChildDirectedTreatment:(BOOL)childDirectedTreatment;
@end

@interface GADMobileAds : NSObject
+ (nonnull GADMobileAds *)sharedInstance;
@property(nonatomic, nonnull, readonly) NSString *sdkVersion;
@property(nonatomic, readonly, strong, nonnull) GADRequestConfiguration *requestConfiguration;
+ (void)configureWithApplicationID:(NSString *)applicationID;
- (void)startWithCompletionHandler:(nullable GADInitializationCompletionHandler)completionHandler;
@end


@class GADBannerView;
@class GADInterstitialAd;
/// Implement your app event within these methods. The delegate will be notified when the SDK
/// receives an app event message from the ad.
@protocol GADAppEventDelegate <NSObject>

@optional

/// Called when the banner receives an app event.
- (void)adView:(nonnull GADBannerView *)banner
    didReceiveAppEvent:(nonnull NSString *)name
              withInfo:(nullable NSString *)info;

/// Called when the interstitial receives an app event.
- (void)interstitialAd:(nonnull GADInterstitialAd *)interstitialAd
    didReceiveAppEvent:(nonnull NSString *)name
              withInfo:(nullable NSString *)info;

@end

/// Specifies optional parameters for ad requests.
@interface GAMRequest : GADRequest

/// Publisher provided user ID.
@property(nonatomic, copy, nullable) NSString *publisherProvidedID;

/// Array of strings used to exclude specified categories in ad results.
@property(nonatomic, copy, nullable) NSArray<NSString *> *categoryExclusions;

/// Key-value pairs used for custom targeting.
@property(nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *customTargeting;

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

NS_ASSUME_NONNULL_END

#endif

#endif /* OMGoogleAdClass_h */
