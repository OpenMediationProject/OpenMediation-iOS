// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingInterstitialClass_h
#define OMAdTimingInterstitialClass_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AdTimingAdsInterstitialDelegate <NSObject>

@optional


/// Invoked when a interstitial  did load.
- (void)adtimingInterstitialDidLoad:(NSString *)placementID;

/// Sent after an  interstitial fails to load the ad.
- (void)adtimingInterstitialDidFailToLoad:(NSString *)placementID withError:(NSError *)error;

- (void)adtimingInterstitialDidOpen:(NSString *)placementID;

/// Sent immediately when a interstitial video starts to play.
- (void)adtimingInterstitialDidShow:(NSString *)placementID;

/// Sent after a interstitial video has been clicked.
- (void)adtimingInterstitialDidClick:(NSString *)placementID;

/// Sent after a interstitial video has been closed.
- (void)adtimingInterstitialDidClose:(NSString *)placementID;

/// Sent after a interstitial video has failed to play.
- (void)adtimingInterstitialDidFailToShow:(NSString *)placementID withError:(NSError *)error;

@end

@interface AdTimingAdsInterstitial : NSObject

/// Returns the singleton instance.
+ (instancetype)sharedInstance;

/// Add delegate
- (void)addDelegate:(id<AdTimingAdsInterstitialDelegate>)delegate;

/// Remove delegate
- (void)removeDelegate:(id<AdTimingAdsInterstitialDelegate>)delegate;

/// loadAd
- (void)loadWithPlacementID:(NSString*)placementID;

///load ad with bid payload
- (void)loadWithPlacementID:(NSString*)placementID payLoad:(NSString*)bidPayload;

/// Indicates whether the interstitial video is ready to show ad.
- (BOOL)isReady:(NSString*)placementID;


- (void)showAdFromRootViewController:(UIViewController *)rootViewController placementID:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdTimingInterstitialClass_h */
