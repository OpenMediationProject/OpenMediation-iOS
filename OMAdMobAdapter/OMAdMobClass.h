// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdMobClass_h
#define OMAdMobClass_h
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

@protocol GADFullScreenContentDelegate;

/// Protocol for ads that present full screen content.
@protocol GADFullScreenPresentingAd <NSObject>

/// Delegate object that receives full screen content messages.
@property(nonatomic, weak, nullable) id<GADFullScreenContentDelegate> fullScreenContentDelegate;

@end

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

#endif /* OMAdMobClass_h */
