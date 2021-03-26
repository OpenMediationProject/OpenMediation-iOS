// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMHyBigInterstitialClass_h
#define OMHyBigInterstitialClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HyBidAd;

@protocol HyBidInterstitialAdDelegate<NSObject>

- (void)interstitialDidLoad;
- (void)interstitialDidFailWithError:(NSError *)error;
- (void)interstitialDidTrackImpression;
- (void)interstitialDidTrackClick;
- (void)interstitialDidDismiss;

@end

@protocol HyBidSignalDataProcessorDelegate<NSObject>

- (void)signalDataDidFinishWithAd:(HyBidAd *)ad;
- (void)signalDataDidFailWithError:(NSError *)error;

@end

@interface HyBidInterstitialAd : NSObject <HyBidSignalDataProcessorDelegate>

@property (nonatomic, strong) HyBidAd *ad;
@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) BOOL isMediation;

- (instancetype)initWithZoneID:(NSString *)zoneID andWithDelegate:(NSObject<HyBidInterstitialAdDelegate> *)delegate;
- (instancetype)initWithDelegate:(NSObject<HyBidInterstitialAdDelegate> *)delegate;
- (void)load;
- (void)prepareAdWithContent:(NSString *)adContent;
- (void)prepareVideoTagFrom:(NSString *)url;

/// Presents the interstitial ad modally from the current view controller.
///
/// This method will do nothing if the interstitial ad has not been loaded (i.e. the value of its `isReady` property is NO).
- (void)show;

/**
* Presents the interstitial ad modally from the specified view controller.
*
* This method will do nothing if the interstitial ad has not been loaded (i.e. the value of its
* `isReady` property is NO).
*
* @param viewController The view controller that should be used to present the interstitial ad.
*/
- (void)showFromViewController:(UIViewController *)viewController;
- (void)hide;

- (void)setSkipOffset:(NSInteger)seconds;

@end

#endif /* OMHyBigInterstitialClass_h */
