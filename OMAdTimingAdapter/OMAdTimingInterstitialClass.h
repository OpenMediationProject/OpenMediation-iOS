// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingInterstitialClass_h
#define OMAdTimingInterstitialClass_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AdTimingMediatedInterstitialDelegate <NSObject>

@optional

/// Invoked when a interstitial video is available.
- (void)adtimingInterstitialChangedAvailability:(NSString*)placementID newValue:(BOOL)available;

/// Sent immediately when a interstitial video is opened.
- (void)adtimingInterstitialDidOpen:(NSString*)placementID;

/// Sent immediately when a interstitial video starts to play.
- (void)adtimingInterstitialDidShow:(NSString*)placementID;

/// Sent after a interstitial video has been clicked.
- (void)adtimingInterstitialDidClick:(NSString*)placementID;

/// Sent after a interstitial video has been closed.
- (void)adtimingInterstitialDidClose:(NSString*)placementID;

/// Sent after a interstitial video has failed to play.
- (void)adtimingInterstitialDidFailToShow:(NSString*)placementID withError:(NSError *)error;

@end

@interface AdTimingInterstitialAd : NSObject

+ (instancetype)sharedInstance;

- (void)addMediationDelegate:(id<AdTimingMediatedInterstitialDelegate>)delegate;

- (void)removeMediationDelegate:(id<AdTimingMediatedInterstitialDelegate>)delegate;

- (void)loadWithPlacementID:(NSString*)placementID;

- (BOOL)isReady:(NSString*)placementID;

- (void)showWithViewController:(UIViewController *)viewController placementID:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdTimingInterstitialClass_h */
