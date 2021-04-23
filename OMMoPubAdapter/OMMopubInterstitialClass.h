// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMopubInterstitialClass_h
#define OMMopubInterstitialClass_h
#import <UIKit/UIKit.h>
#import "OMMopubClass.h"
NS_ASSUME_NONNULL_BEGIN

@class MPAdView;

@class MPInterstitialAdController;

/**
 * The delegate of an `MPAdView` object must adopt the `MPAdViewDelegate` protocol. It must
 * implement `viewControllerForPresentingModalView` to provide a root view controller from which
 * the ad view should present modal content.
 *
 * Optional methods of this protocol allow the delegate to be notified of banner success or
 * failure, as well as other lifecycle events.
 */

@protocol MPAdViewDelegate <MPMoPubAdDelegate>

@required

/** @name Managing Modal Content Presentation */

/**
 * Asks the delegate for a view controller to use for presenting modal content, such as the in-app
 * browser that can appear when an ad is tapped.
 *
 * @return A view controller that should be used for presenting modal content.
 */
- (UIViewController *)viewControllerForPresentingModalView;

@optional

/** @name Detecting When a Banner Ad is Loaded */

/**
 * Sent when an ad view successfully loads an ad.
 *
 * Your implementation of this method should insert the ad view into the view hierarchy, if you
 * have not already done so.
 *
 * @param view The ad view sending the message.
 */
- (void)adViewDidLoadAd:(MPAdView *)view __attribute__((deprecated("Deprecated; please use adViewDidLoadAd:adSize: instead.")));

/**
 * Sent when an ad view successfully loads an ad.
 *
 * Your implementation of this method should insert the ad view into the view hierarchy, if you
 * have not already done so.
 *
 * @param view The ad view sending the message.
 * @param adSize The size of the ad that was successfully loaded. It is recommended to resize
 * the @c MPAdView frame to match the height of the loaded ad.
 */
- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize;

/**
 * Sent when an ad view fails to load an ad.
 *
 * To avoid displaying blank ads, you should hide the ad view in response to this message.
 *
 * @param view The ad view sending the message.
 */
- (void)adViewDidFailToLoadAd:(MPAdView *)view __attribute__((deprecated("Deprecated; please use adView:didFailToLoadAdWithError: instead.")));

/**
 * Sent when an ad view fails to load an ad.
 *
 * To avoid displaying blank ads, you should hide the ad view in response to this message.
 *
 * @param view The ad view sending the message.
 * @param error The error
 */
- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error;

/** @name Detecting When a User Interacts With the Ad View */

/**
 * Sent when an ad view is about to present modal content.
 *
 * This method is called when the user taps on the ad view. Your implementation of this method
 * should pause any application activity that requires user interaction.
 *
 * @param view The ad view sending the message.
 * @see `didDismissModalViewForAd:`
 */
- (void)willPresentModalViewForAd:(MPAdView *)view;

/**
 * Sent when an ad view has dismissed its modal content, returning control to your application.
 *
 * Your implementation of this method should resume any application activity that was paused
 * in response to `willPresentModalViewForAd:`.
 *
 * @param view The ad view sending the message.
 * @see `willPresentModalViewForAd:`
 */
- (void)didDismissModalViewForAd:(MPAdView *)view;

/**
 * Sent when a user is about to leave your application as a result of tapping
 * on an ad.
 *
 * Your application will be moved to the background shortly after this method is called.
 *
 * @param view The ad view sending the message.
 */
- (void)willLeaveApplicationFromAd:(MPAdView *)view;

@end


/**
 * The MPAdView class provides a view that can display banner advertisements.
 */
IB_DESIGNABLE


/**
 * The delegate of an `MPInterstitialAdController` object must adopt the
 * `MPInterstitialAdControllerDelegate` protocol.
 *
 * The optional methods of this protocol allow the delegate to be notified of interstitial state
 * changes, such as when an ad has loaded, when an ad has been presented or dismissed from the
 * screen, and when an ad has expired.
 */

@protocol MPInterstitialAdControllerDelegate <MPMoPubAdDelegate>

@optional

/** @name Detecting When an Interstitial Ad is Loaded */

/**
 Sent when an interstitial ad object successfully loads an ad.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial;

/**
 Sent when an interstitial ad object fails to load an ad.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial __deprecated_msg("Use `interstitialDidFailToLoadAd:withError:` instead.");

/**
 Sent when an interstitial ad object fails to load an ad.

 @param interstitial The interstitial ad object sending the message.
 @param error The error that occurred during the load.
 */
- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
                          withError:(NSError *)error;

/** @name Detecting When an Interstitial Ad is Presented */

/**
 Sent immediately before an interstitial ad object is presented on the screen.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial;

/**
 Sent after an interstitial ad object has been presented on the screen.

 Your implementation of this method should pause any application activity that requires user
 interaction.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial;

/** @name Detecting When an Interstitial Ad is Dismissed */

/**
 Sent immediately before an interstitial ad object will be dismissed from the screen.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial DEPRECATED_MSG_ATTRIBUTE("interstitialWillDisappear: is deprecated. Use interstitialWillDismiss: instead.");

/**
 Sent after an interstitial ad object has been dismissed from the screen, returning control
 to your application.

 Your implementation of this method should resume any application activity that was paused
 prior to the interstitial being presented on-screen.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial DEPRECATED_MSG_ATTRIBUTE("interstitialDidDisappear: is deprecated. Use interstitialDidDismiss: instead.");

/**
 Sent immediately before an interstitial ad object will be dismissed from the screen.

 Your implementation of this method should resume any application activity that was paused
 prior to the interstitial being presented on-screen.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialWillDismiss:(MPInterstitialAdController *)interstitial;

/**
 Sent after an interstitial ad object has been dismissed from the screen, returning control
 to your application.

 Your implementation of this method should resume any application activity that was paused
 prior to the interstitial being presented on-screen.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialDidDismiss:(MPInterstitialAdController *)interstitial;

/** @name Detecting When an Interstitial Ad Expires */

/**
 Sent when a loaded interstitial ad is no longer eligible to be displayed.

 Interstitial ads from certain networks may expire their content at any time,
 even if the content is currently on-screen. This method notifies you when the currently-
 loaded interstitial has expired and is no longer eligible for display.

 If the ad was on-screen when it expired, you can expect that the ad will already have been
 dismissed by the time this message is sent.

 Your implementation may include a call to `loadAd` to fetch a new ad, if desired.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial;

/**
 Sent when the user taps the interstitial ad and the ad is about to perform its target action.

 This action may include displaying a modal or leaving your application. Certain ad networks
 may not expose a "tapped" callback so you should not rely on this callback to perform
 critical tasks.

 @param interstitial The interstitial ad object sending the message.
 */
- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial;

@end


@interface MPInterstitialAdController : NSObject <MPMoPubAd>

/** @name Obtaining an Interstitial Ad */

/**
 * Returns an interstitial ad object matching the given ad unit ID.
 *
 * The first time this method is called for a given ad unit ID, a new interstitial ad object is
 * created, stored in a shared pool, and returned. Subsequent calls for the same ad unit ID will
 * return that object, unless you have disposed of the object using
 * `removeSharedInterstitialAdController:`.
 *
 * There can only be one interstitial object for an ad unit ID at a given time.
 *
 * @param adUnitId A string representing a MoPub ad unit ID.
 */
+ (MPInterstitialAdController *)interstitialAdControllerForAdUnitId:(NSString *)adUnitId;

/** @name Setting and Getting the Delegate */

/**
 * The delegate (`MPInterstitialAdControllerDelegate`) of the interstitial ad object.
 */
@property (nonatomic, weak) id<MPInterstitialAdControllerDelegate> delegate;

/** @name Setting Request Parameters */

/**
 * The MoPub ad unit ID for this interstitial ad.
 *
 * Ad unit IDs are created on the MoPub website. An ad unit is a defined placement in your
 * application set aside for advertising. If no ad unit ID is set, the ad object will use a default
 * ID that only receives test ads.
 */
@property (nonatomic, copy) NSString *adUnitId;

/**
 * A string representing a set of non-personally identifiable keywords that should be passed to the MoPub ad server to receive
 * more relevant advertising.

 * Note: If a user is in General Data Protection Regulation (GDPR) region and MoPub doesn't obtain consent from the user, "keywords" will still be sent to the server.
 *
 */
@property (nonatomic, copy) NSString *keywords;

/**
 * A string representing a set of personally identifiable keywords that should be passed to the MoPub ad server to receive
 * more relevant advertising.
 *
 * Keywords are typically used to target ad campaigns at specific user segments. They should be
 * formatted as comma-separated key-value pairs (e.g. "marital:single,age:24").
 *
 * On the MoPub website, keyword targeting options can be found under the "Advanced Targeting"
 * section when managing campaigns.
 *
 * Note: If a user is in General Data Protection Regulation (GDPR) region and MoPub doesn't obtain consent from the user, personally identifiable keywords will not be sent to the server.
 */
@property (nonatomic, copy) NSString *userDataKeywords;


/**
 * An optional dictionary containing extra local data.
 */
@property (nonatomic, copy) NSDictionary *localExtras;

/** @name Loading an Interstitial Ad */

/**
 * Begins loading ad content for the interstitial.
 *
 * You can implement the `interstitialDidLoadAd:` and `interstitialDidFailToLoadAd:` methods of
 * `MPInterstitialAdControllerDelegate` if you would like to be notified as loading succeeds or
 * fails.
 */
- (void)loadAd;

/** @name Detecting Whether the Interstitial Ad Has Loaded */

/**
 * A Boolean value that represents whether the interstitial ad has loaded an advertisement and is
 * ready to be presented.
 *
 * After obtaining an interstitial ad object, you can use `loadAd` to tell the object to begin
 * loading ad content. Once the content has been loaded, the value of this property will be YES.
 *
 * The value of this property can be NO if the ad content has not finished loading, has already
 * been presented, or has expired. The expiration condition only applies for ads from certain
 * third-party ad networks. See `MPInterstitialAdControllerDelegate` for more details.
 */
@property (nonatomic, assign, readonly) BOOL ready;

/** @name Presenting an Interstitial Ad */

/**
 * Presents the interstitial ad modally from the specified view controller.
 *
 * This method will do nothing if the interstitial ad has not been loaded (i.e. the value of its
 * `ready` property is NO).
 *
 * `MPInterstitialAdControllerDelegate` provides optional methods that you may implement to stay
 * informed about when an interstitial takes over or relinquishes the screen.
 *
 * @param controller The view controller that should be used to present the interstitial ad.
 */
- (void)showFromViewController:(UIViewController *)controller;

/** @name Disposing of an Interstitial Ad */

/**
 * Removes the given interstitial object from the shared pool of interstitials available to your
 * application.
 *
 * This method removes the mapping from the interstitial's ad unit ID to the interstitial ad
 * object. In other words, you will receive a different ad object if you subsequently call
 * `interstitialAdControllerForAdUnitId:` for the same ad unit ID.
 *
 * @warning **Important**: This method is intended to be used for deallocating the interstitial
 * ad object when it is no longer needed. You should `nil` out any references you have to the
 * object after calling this method.
 *
 * @param controller The interstitial ad object that should be disposed.
 */
+ (void)removeSharedInterstitialAdController:(MPInterstitialAdController *)controller;

/*
 * Returns the shared pool of interstitial objects for your application.
 */
+ (NSMutableArray *)sharedInterstitialAdControllers DEPRECATED_MSG_ATTRIBUTE("This functionality will be removed in a future SDK release.");

@end

NS_ASSUME_NONNULL_END

#endif /* OMMopubInterstitialClass_h */
