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

@interface ALInterstitialAd : NSObject

#pragma mark - Ad Delegates

/**
 * An object that conforms to the @c ALAdLoadDelegate protocol. If you provide a value for @c adLoadDelegate in your instance, the SDK will notify
 * this delegate of ad load events.
 */
@property (nonatomic, strong, nullable) id<ALAdLoadDelegate> adLoadDelegate;

/**
 * An object that conforms to the @c ALAdDisplayDelegate protocol. If you provide a value for @c adDisplayDelegate in your instance, the SDK will
 * notify this delegate of ad show/hide events.
 */
@property (nonatomic, strong, nullable) id<ALAdDisplayDelegate> adDisplayDelegate;

/**
 * An object that conforms to the @c ALAdVideoPlaybackDelegate protocol. If you provide a value for @c adVideoPlaybackDelegate in your instance,
 * the SDK will notify this delegate of video start/finish events.
 */
@property (nonatomic, strong, nullable) id<ALAdVideoPlaybackDelegate> adVideoPlaybackDelegate;

#pragma mark - Loading and Showing Ads, Class Methods

/**
 * Shows an interstitial over the application’s key window. This loads the next interstitial and displays it.
 */
+ (instancetype)show;

/**
 * Gets a reference to the shared singleton instance.
 *
 * This method calls @code +[ALSdk shared] @endcode which requires that you have an SDK key defined in @code Info.plist @endcode.
 *
 * @warning If you use @code +[ALSdk sharedWithKey:] @endcode then you will need to use the instance methods instead.
 */
+ (instancetype)shared;

#pragma mark - Loading and Showing Ads, Instance Methods

/**
 * Shows an interstitial over the application’s key window. This loads the next interstitial and displays it.
 */
- (void)show;

/**
 * Shows the current interstitial over a given window and renders a specified ad loaded by @c ALAdService.
 *
 * @param ad The ad to render into this interstitial.
 */
- (void)showAd:(ALAd *)ad;

#pragma mark - Initialization

/**
 * Initializes an instance of this class with an SDK instance.
 *
 * @param sdk The AppLovin SDK instance to use.
 */
- (instancetype)initWithSdk:(ALSdk *)sdk;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

/**
 * This class provides and displays ads.
 */
@interface ALAdService : NSObject

/**
 * Fetches a new ad, of a given size, and notifies a supplied delegate on completion.
 *
 * @param adSize    Size of an ad to load.
 * @param delegate  A callback that @c loadNextAd calls to notify of the fact that the ad is loaded.
 */
- (void)loadNextAd:(ALAdSize *)adSize andNotify:(id<ALAdLoadDelegate>)delegate;

/**
 * Fetches a new ad, for a given zone, and notifies a supplied delegate on completion.
 *
 * @param zoneIdentifier  The identifier of the zone to load an ad for.
 * @param delegate        A callback that @c loadNextAdForZoneIdentifier calls to notify of the fact that the ad is loaded.
 */
- (void)loadNextAdForZoneIdentifier:(NSString *)zoneIdentifier andNotify:(id<ALAdLoadDelegate>)delegate;

/**
 * A token used for advanced header bidding.
 */
@property (nonatomic, copy, readonly) NSString *bidToken;

/**
 * Fetches a new ad for the given ad token. The provided ad token must be one that was received from AppLovin S2S API.
 *
 * @warning This method is designed to be called by SDK mediation providers. Use @code -[ALAdService loadNextAdForZoneIdentifiers:andNotify:] @endcode for
 *          regular integrations.
 *
 * @param adToken   Ad token returned from AppLovin S2S API.
 * @param delegate  A callback that @c loadNextAdForAdToken calls to notify that the ad has been loaded.
 */
- (void)loadNextAdForAdToken:(NSString *)adToken andNotify:(id<ALAdLoadDelegate>)delegate;

/**
 * Fetch a new ad for any of the provided zone identifiers.
 *
 * @warning This method is designed to be called by SDK mediation providers. Use @code -[ALAdService loadNextAdForZoneIdentifiers:andNotify:] @endcode for
 *          regular integrations.
 *
 * @param zoneIdentifiers  An array of zone identifiers for which an ad should be loaded.
 * @param delegate         A callback that @c loadNextAdForZoneIdentifiers calls to notify that the ad has been loaded.
 */
- (void)loadNextAdForZoneIdentifiers:(NSArray<NSString *> *)zoneIdentifiers andNotify:(id<ALAdLoadDelegate>)delegate;

- (instancetype)init __attribute__((unavailable("Access ALAdService through ALSdk's adService property.")));
+ (instancetype)new NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END

#endif /* OMAppLovinInterstitialClass_h */
