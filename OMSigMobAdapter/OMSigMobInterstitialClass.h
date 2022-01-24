// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMSigMobInterstitialClass_h
#define OMSigMobInterstitialClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMSigMobClass.h"

@class WindIntersititialAd;

@protocol WindIntersititialAdDelegate<NSObject>

/**
 This method is called when video ad material loaded successfully.
 */
- (void)intersititialAdDidLoad:(WindIntersititialAd *)intersititialAd;

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)intersititialAdDidLoad:(WindIntersititialAd *)intersititialAd didFailWithError:(NSError *)error;

/**
 This method is called when video ad slot will be showing.
 */
- (void)intersititialAdWillVisible:(WindIntersititialAd *)intersititialAd;

/**
 This method is called when video ad slot has been shown.
 */
- (void)intersititialAdDidVisible:(WindIntersititialAd *)intersititialAd;

/**
 This method is called when video ad is clicked.
 */
- (void)intersititialAdDidClick:(WindIntersititialAd *)intersititialAd;

/**
 This method is called when video ad is clicked skip button.
 */
- (void)intersititialAdDidClickSkip:(WindIntersititialAd *)intersititialAd;

/**
 This method is called when video ad is about to close.
 */
- (void)intersititialAdDidClose:(WindIntersititialAd *)intersititialAd;

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)intersititialAdDidPlayFinish:(WindIntersititialAd *)intersititialAd didFailWithError:(NSError *)error;

/**
 This method is called when return ads from sigmob ad server.
 */
- (void)intersititialAdServerResponse:(WindIntersititialAd *)intersititialAd isFillAd:(BOOL)isFillAd;



@end

@interface WindIntersititialAd : NSObject

@property (nonatomic, weak) id<WindIntersititialAdDelegate> delegate;

@property (nonatomic, strong, readonly) NSString *placementId;

@property (nonatomic, getter=isAdReady, readonly) BOOL ready;


- (instancetype)initWithPlacementId:(NSString *)placementId request:(WindAdRequest *)request;

- (void)loadAdData;

/**
 Display video ad.
 @param rootViewController : root view controller for displaying ad.
 @param extras : Extended parameters for displaying ad.
 */
- (void)showAdFromRootViewController:(UIViewController *)rootViewController
                             options:(NSDictionary<NSString *, NSString *> *)extras;

@end


#endif /* OMSigMobInterstitialClass_h */
