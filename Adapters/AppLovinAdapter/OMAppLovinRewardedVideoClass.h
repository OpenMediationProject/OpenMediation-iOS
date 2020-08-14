// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAppLovinRewardedVideoClass_h
#define OMAppLovinRewardedVideoClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ALAd;
@class ALSdk;
@class ALAdService;

@protocol ALAdRewardDelegate <NSObject>

@required

/**
 *  This method is invoked if a user viewed a rewarded video and their reward was approved by the AppLovin server.
 *
 * If you are using reward validation for incentivized videos, this method
 * will be invoked if we contacted AppLovin successfully. This means that we believe the
 * reward is legitimate and should be awarded. Please note that ideally you should refresh the
 * user's balance from your server at this point to prevent tampering with local data on jailbroken devices.
 *
 * The response NSDictionary will typically includes the keys "currency" and "amount", which point to NSStrings containing the name and amount of the virtual currency to be awarded.
 *
 *  @param ad       Ad which was viewed.
 *  @param response Dictionary containing response data, including "currency" and "amount".
 */
- (void)rewardValidationRequestForAd:(ALAd *)ad didSucceedWithResponse:(NSDictionary *)response;

/**
 * This method will be invoked if we were able to contact AppLovin, but the user has already received
 * the maximum number of coins you allowed per day in the web UI.
 *
 *  @param ad       Ad which was viewed.
 *  @param response Dictionary containing response data from the server.
 */
- (void)rewardValidationRequestForAd:(ALAd *)ad didExceedQuotaWithResponse:(NSDictionary *)response;

/**
 * This method will be invoked if the AppLovin server rejected the reward request.
 * This would usually happen if the user fails to pass an anti-fraud check.
 *
 *  @param ad       Ad which was viewed.
 *  @param response Dictionary containing response data from the server.
 */
- (void)rewardValidationRequestForAd:(ALAd *)ad wasRejectedWithResponse:(NSDictionary *)response;

/**
 * This method will be invoked if were unable to contact AppLovin, so no ping will be heading to your server.
 *
 *  @param ad           Ad which was viewed.
 *  @param responseCode A failure code corresponding to a constant defined in <code>ALErrorCodes.h</code>.
 */
- (void)rewardValidationRequestForAd:(ALAd *)ad didFailWithError:(NSInteger)responseCode;

@optional

/**
 * This method will be invoked if the user chooses 'no' when asked if they want to view a rewarded video.
 *
 * This is only possible if you have the pre-video modal enabled in the Manage Apps UI.
 *
 * @param ad       Ad which was offered to the user, but declined.
 */
- (void)userDeclinedToViewAd:(ALAd *)ad;

@end

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

@interface ALIncentivizedInterstitialAd : NSObject

#pragma mark - Ad Delegates

/**
 *  An object conforming to the ALAdDisplayDelegate protocol, which, if set, will be notified of ad show/hide events.
 */
@property (strong, nonatomic) id <ALAdDisplayDelegate> adDisplayDelegate;

/**
 *  An object conforming to the ALAdVideoPlaybackDelegate protocol, which, if set, will be notified of video start/stop events.
 */
@property (strong, nonatomic) id <ALAdVideoPlaybackDelegate> adVideoPlaybackDelegate;

#pragma mark - Integration, Class Methods

/**
 * Get a reference to the shared instance of ALIncentivizedInterstitialAd.
 *
 * This wraps the [ALSdk shared] call, and will only work if you hve set your SDK key in Info.plist.
*/
+ (ALIncentivizedInterstitialAd *)shared;

/**
 * Pre-load an incentivized interstitial, and notify your provided Ad Load Delegate.
 *
 * Invoke once to preload, then do not invoke again until the ad has has been closed (e.g., ALAdDisplayDelegate's adWasHidden callback).
 * You may pass a nil argument to preloadAndNotify if you intend to use the synchronous ( isIncentivizedAdReady ) flow. Note that this is NOT recommended; we HIGHLY RECOMMEND you use an ad load delegate.
 * This method uses the shared instance, and will only work if you have set your SDK key in Info.plist.
 * Note that we internally try to pull down the next ad's resources before you need it. Therefore, this method may complete immediately in many circumstances.
 *
 * @param adLoadDelegate The delegate to notify that preloading was completed. May be nil.
 */
+ (void)preloadAndNotify:(nullable id<ALAdLoadDelegate>)adLoadDelegate;

/**
 * Check if an ad is currently ready on this object. You must call preloadAndNotify in order to reach this state.
 *
 * It is highly recommended that you implement an asynchronous flow (using an ALAdLoadDelegate with preloadAndNotify) rather than checking this property. This class does not contain a queue and can hold only one preloaded ad at a time. Therefore, you should NOT simply call preloadAndNotify: any time this method returns NO; it is important to invoke only one ad load - then not invoke any further loads until the ad has been closed (e.g., ALAdDisplayDelegate's adWasHidden callback).
 *
 * @return YES if an ad has been loaded into this incentivized interstitial and is ready to display. NO otherwise.
 */
+ (BOOL)isReadyForDisplay;

/**
 * Show an incentivized interstitial over the current key window, using the most recently pre-loaded ad.
 *
 * You must call preloadAndNotify before calling showOver.
 */
+ (void)show;

/**
 * Show an incentivized interstitial over the current key window, using the most recently pre-loaded ad.
 *
 * You must call preloadAndNotify before calling showOver.
 *
 * Using the ALAdRewardDelegate, you will be able to verify with AppLovin servers the the video view is legitimate,
 * as we will confirm whether the specific ad was actually served - then we will ping your server with a url for you to update
 * the user's balance. The Reward Validation Delegate will tell you whether we were able to reach our servers or not. If you receive
 * a successful response, you should refresh the user's balance from your server. For more info, see the documentation.
 *
 * @param adRewardDelegate The reward delegate to notify upon validating reward authenticity with AppLovin.
 *
 */
+ (void)showAndNotify:(nullable id<ALAdRewardDelegate>)adRewardDelegate;

#pragma mark - Integration, Instance Methods

/**
 * Initialize an incentivized interstitial with a specific custom SDK.
 *
 * This is necessary if you use <code>[ALSdk sharedWithKey: ...]</code>.
 *
 * @param sdk An SDK instance to use.
 */
- (instancetype)initWithSdk:(ALSdk *)sdk;

#pragma mark - Integration, zones

/**
 * Initialize an incentivized interstitial with a zone.
 *
 * @param zoneIdentifier The identifier of the zone for which to load ads for.
 */
- (instancetype)initWithZoneIdentifier:(NSString *)zoneIdentifier;

/**
 * Initialize an incentivized interstitial with a zone and a specific custom SDK.
 *
 * This is necessary if you use <code>[ALSdk sharedWithKey: ...]</code>.
 *
 * @param zoneIdentifier The identifier of the zone for which to load ads for.
 * @param sdk            An SDK instance to use.
 */
- (instancetype)initWithZoneIdentifier:(NSString *)zoneIdentifier sdk:(ALSdk *)sdk;

/**
 *  The zone identifier this incentivized ad was initialized with and is loading ads for, if any.
 */
@property (copy, nonatomic, readonly, nullable) NSString *zoneIdentifier;

/**
 * Pre-load an incentivized interstitial, and notify your provided Ad Load Delegate.
 *
 * Invoke once to preload, then do not invoke again until the ad has has been closed (e.g., ALAdDisplayDelegate's adWasHidden callback).
 * You may pass a nil argument to preloadAndNotify if you intend to use the synchronous ( isIncentivizedAdReady ) flow. Note that this is NOT recommended; we HIGHLY RECOMMEND you use an ad load delegate.
 * Note that we internally try to pull down the next ad's resources before you need it. Therefore, this method may complete immediately in many circumstances.
 *
 * @param adLoadDelegate The delegate to notify that preloading was completed.
 */
- (void)preloadAndNotify:(nullable id<ALAdLoadDelegate>)adLoadDelegate;

/**
 * Check if an ad is currently ready on this object. You must call preloadAndNotify in order to reach this state.
 *
 * It is highly recommended that you implement an asynchronous flow (using an ALAdLoadDelegate with preloadAndNotify) rather than checking this property. This class does not contain a queue and can hold only one preloaded ad at a time. Therefore, you should NOT simply call preloadAndNotify: any time this method returns NO; it is important to invoke only one ad load - then not invoke any further loads until the ad has been closed (e.g., ALAdDisplayDelegate's adWasHidden callback).
 *
 * @return YES if an ad has been loaded into this incentivized interstitial and is ready to display. NO otherwise.
 */
@property (readonly, atomic, getter=isReadyForDisplay) BOOL readyForDisplay;

/**
 * Show an incentivized interstitial over the current key window, using the most recently pre-loaded ad.
 *
 * You must call preloadAndNotify before calling showOver.
 */
- (void)show;

/**
 * Show an incentivized interstitial over the current key window, using the most recently pre-loaded ad.
 *
 * You must call preloadAndNotify before calling showOver.
 *
 * Using the ALAdRewardDelegate, you will be able to verify with AppLovin servers the the video view is legitimate,
 * as we will confirm whether the specific ad was actually served - then we will ping your server with a url for you to update
 * the user's balance. The Reward Validation Delegate will tell you whether we were able to reach our servers or not. If you receive
 * a successful response, you should refresh the user's balance from your server. For more info, see the documentation.
 *
 * @param adRewardDelegate The reward delegate to notify upon validating reward authenticity with AppLovin.
 *
 */
- (void)showAndNotify:(nullable id<ALAdRewardDelegate>)adRewardDelegate;

/**
 * Show an incentivized interstitial, using the most recently pre-loaded ad.
 *
 * You must call preloadAndNotify before calling showOver.
 *
 * Using the ALAdRewardDelegate, you will be able to verify with AppLovin servers that the video view is legitimate,
 * as we will confirm whether the specific ad was actually served - then we will ping your server with a url for you to update
 * the user's balance. The Reward Validation Delegate will tell you whether we were able to reach our servers or not. If you receive
 * a successful response, you should refresh the user's balance from your server. For more info, see the documentation.
 *
 * @param ad               The ad to render into this incentivized ad.
 * @param adRewardDelegate The reward delegate to notify upon validating reward authenticity with AppLovin.
 */
- (void)showAd:(ALAd *)ad andNotify:(nullable id<ALAdRewardDelegate>)adRewardDelegate;


- (instancetype)init __attribute__((unavailable("Use initWithSdk:, initWithZoneIdentifier:, or [ALIncentivizedInterstitialAd shared] instead.")));

@end

NS_ASSUME_NONNULL_END

#endif /* OMAppLovinRewardedVideoClass_h */
