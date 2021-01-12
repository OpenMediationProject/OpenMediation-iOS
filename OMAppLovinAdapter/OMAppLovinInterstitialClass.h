// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAppLovinInterstitialClass_h
#define OMAppLovinInterstitialClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMAppLovinClass.h"

NS_ASSUME_NONNULL_BEGIN

@class ALAd;
@class ALSdk;
@class ALAdService;
@class ALAdSize;

/**
 *  This class is used to display full-screen ads to the user.
 */
@interface ALInterstitialAd : NSObject

#pragma mark - Ad Delegates

/**
 *  An object conforming to the ALAdLoadDelegate protocol, which, if set, will be notified of ad load events.
 */
@property (strong, nonatomic) id <ALAdLoadDelegate> adLoadDelegate;

/**
 *  An object conforming to the ALAdDisplayDelegate protocol, which, if set, will be notified of ad show/hide events.
 */
@property (strong, nonatomic) id <ALAdDisplayDelegate> adDisplayDelegate;

/**
 *  An object conforming to the ALAdVideoPlaybackDelegate protocol, which, if set, will be notified of video start/finish events.
 */
@property (strong, nonatomic) id <ALAdVideoPlaybackDelegate> adVideoPlaybackDelegate;

#pragma mark - Loading and Showing Ads, Class Methods

/**
 * Show an interstitial over the application's key window.
 * This will load the next interstitial and display it.
 */
+ (ALInterstitialAd *)show;

/**
 * Get a reference to the shared singleton instance.
 *
 * This method calls [ALSdk shared] which requires you to have an SDK key defined in <code>Info.plist</code>.
 * If you use <code>[ALSdk sharedWithKey: ...]</code> then you will need to use the instance methods instead.
 */
+ (ALInterstitialAd *)shared;

#pragma mark - Loading and Showing Ads, Instance Methods

/**
 * Show an interstitial over the application's key window.
 * This will load the next interstitial and display it.
 */
- (void)show;

/**
 * Show current interstitial over a given window and render a specified ad loaded by ALAdService.
 *
 * @param ad The ad to render into this interstitial.
 */
- (void)showAd:(ALAd *)ad;

#pragma mark - Initialization

/**
 * Init this interstitial ad with a custom SDK instance.
 *
 * To simply display an interstitial, use [ALInterstitialAd showOver:window]
 *
 * @param sdk Instance of AppLovin SDK to use.
 */
- (instancetype)initWithSdk:(ALSdk *)sdk;

/**
 * Init this interstitial ad with a custom SDK instance and frame.
 *
 * To simply display an interstitial, use [ALInterstitialAd showOver:window].
 * In general, setting a custom frame is not recommended, unless absolutely necessary.
 * Interstitial ads are intended to be full-screen and may not look right if sized otherwise.
 *
 * @param frame Frame to use with the new interstitial.
 * @param sdk   Instance of AppLovin SDK to use.
 */
- (instancetype)initWithFrame:(CGRect)frame sdk:(ALSdk *)sdk;

#pragma mark - Advanced Configuration

/**
 *  Frame to be passed through to the descendent UIView containing this interstitial.
 *
 *  Note that this has no effect on video ads, as they are presented in their own view controller.
 */
@property (assign, nonatomic) CGRect frame;

/**
 *  Hidden setting to be passed through to the descendent UIView containing this interstitial.
 *
 *  Note that this has no effect on video ads, as they are presented in their own view controller.
 */
@property (assign, nonatomic) BOOL hidden;


- (instancetype) init __attribute__((unavailable("Use [ALInterstitialAd shared] or initInterstitialAdWithSdk: instead.")));

@end

@interface ALAdService : NSObject
- (void)loadNextAd:(ALAdSize *)adSize andNotify:(id<ALAdLoadDelegate>)delegate;
- (void)loadNextAdForZoneIdentifier:(NSString *)zoneIdentifier andNotify:(id<ALAdLoadDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END

#endif /* OMAppLovinInterstitialClass_h */
