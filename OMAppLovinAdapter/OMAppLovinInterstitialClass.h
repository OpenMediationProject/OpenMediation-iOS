// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAppLovinInterstitialClass_h
#define OMAppLovinInterstitialClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ALAd;
@class ALSdk;
@class ALAdService;
@class ALAdSize;

@protocol ALAdDisplayDelegate <NSObject>

/**
 * This method is invoked when the ad is displayed in the view.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just displayed. Will not be nil.
 * @param view   Ad view in which the ad was displayed. Will not be nil.
 */
- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view;

/**
 * This method is invoked when the ad is hidden from in the view.
 * This occurs when the user "X's" out of an interstitial.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just hidden. Will not be nil.
 * @param view   Ad view in which the ad was hidden. Will not be nil.
 */
- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view;

/**
 * This method is invoked when the ad is clicked from in the view.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just clicked. Will not be nil.
 * @param view   Ad view in which the ad was hidden. Will not be nil.
 */
- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view;

@end

@protocol ALAdVideoPlaybackDelegate <NSObject>

/**
 * This method is invoked when a video starts playing in an ad.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad Ad in which video playback began.
 */
- (void)videoPlaybackBeganInAd:(ALAd *)ad;

/**
 * This method is invoked when a video stops playing in an ad.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad                Ad in which video playback ended.
 * @param percentPlayed     How much of the video was watched, as a percent.
 * @param wasFullyWatched   Whether or not the video was watched to, or very near to, completion.
 */
- (void)videoPlaybackEndedInAd:(ALAd *)ad atPlaybackPercent:(NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched;

@end

@protocol ALAdLoadDelegate <NSObject>

/**
 * This method is invoked when an ad is loaded by the AdService.
 *
 * This method is invoked on the main UI thread.
 *
 * @param adService AdService which loaded the ad. Will not be nil.
 * @param ad        Ad that was loaded. Will not be nil.
 */
- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad;

/**
 * This method is invoked when an ad load fails.
 *
 * This method is invoked on the main UI thread.
 *
 * @param adService AdService which failed to load an ad. Will not be nil.
 * @param code      An error code corresponding with a constant defined in <code>ALErrorCodes.h</code>.
 */
- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code;

@end

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
 *
 * Note that this method is functionally equivalent to calling
 * showOver: and passing [[UIApplication sharedApplication] keyWindow].
 */
+ (ALInterstitialAd *)show;

/**
 * Show a new interstitial ad. This method will display an interstitial*
 * over the given UIWindow.
 *
 * @param window  A window to show the interstitial over
 */
+ (ALInterstitialAd *)showOver:(UIWindow *)window;

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
 *
 * Note that this method is functionally equivalent to calling
 * showOver: and passing [[UIApplication sharedApplication] keyWindow].
 */
- (void)show;

/**
 * Show an interstitial over a given window.
 * @param window An instance of window to show the interstitial over.
 */
- (void)showOver:(UIWindow *)window;

/**
 * Show current interstitial over a given window and render a specified ad loaded by ALAdService.
 *
 * @param window An instance of window to show the interstitial over.
 * @param ad     The ad to render into this interstitial.
 */
- (void)showOver:(UIWindow *)window andRender:(ALAd *)ad;

#pragma mark - Dismissing Interstitials Expliticly

/**
 * Dismiss this interstitial.
 *
 * In general, this is not recommended as it negatively impacts click through rate.
 */
- (void)dismiss;

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
