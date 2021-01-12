// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingInterstitialClass_h
#define OMAdTimingInterstitialClass_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AdTimingBidInterstitialDelegate <NSObject>

@optional


/// Invoked when a interstitial  did load.
- (void)AdTimingBidInterstitialDidLoad:(NSString *)placementID;

/// Sent after an  interstitial fails to load the ad.
- (void)AdTimingBidInterstitialDidFailToLoad:(NSString *)placementID withError:(NSError *)error;

- (void)AdTimingBidInterstitialDidOpen:(NSString *)placementID;

/// Sent immediately when a interstitial video starts to play.
- (void)AdTimingBidInterstitialDidShow:(NSString *)placementID;

/// Sent after a interstitial video has been clicked.
- (void)AdTimingBidInterstitialDidClick:(NSString *)placementID;

/// Sent after a interstitial video has been closed.
- (void)AdTimingBidInterstitialDidClose:(NSString *)placementID;

/// Sent after a interstitial video has failed to play.
- (void)AdTimingBidInterstitialDidFailToShow:(NSString *)placementID withError:(NSError *)error;

@end

@interface AdTimingBidInterstitial : NSObject

/// Returns the singleton instance.
+ (instancetype)sharedInstance;

/// Add delegate
- (void)addDelegate:(id<AdTimingBidInterstitialDelegate>)delegate;

/// Remove delegate
- (void)removeDelegate:(id<AdTimingBidInterstitialDelegate>)delegate;

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
