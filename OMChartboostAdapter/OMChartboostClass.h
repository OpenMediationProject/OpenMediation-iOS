// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMChartboostClass_h
#define OMChartboostClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CHBDataUseConsent;
@class CHBStartError;
@class CHBClickError;

typedef NS_ENUM(NSInteger, CHBCacheErrorCode) {
    CHBCacheErrorCodeInternal,
    CHBCacheErrorCodeInternetUnavailable,
    CHBCacheErrorCodeNetworkFailure,
    CHBCacheErrorCodeNoAdFound,
    CHBCacheErrorCodeSessionNotStarted,
    CHBCacheErrorCodeAssetDownloadFailure,
    CHBCacheErrorCodePublisherDisabled,
    CHBCacheErrorCodeServerError
};

@interface CHBCacheError : NSError
/*! @brief Error code that indicates the failure reason. */
@property (nonatomic, readonly) CHBCacheErrorCode code;
@end

NS_ASSUME_NONNULL_BEGIN

/*!
 @typedef NS_ENUM (NSUInteger, CHBShowErrorCode)
 @brief Error codes for failed show operations.
 */
typedef NS_ENUM(NSInteger, CHBShowErrorCode) {
    CHBShowErrorCodeInternal,
    CHBShowErrorCodeSessionNotStarted,
    CHBShowErrorCodeInternetUnavailable,
    CHBShowErrorCodePresentationFailure,
    CHBShowErrorCodeNoCachedAd,
    CHBShowErrorCodeNoViewController
};

/*!
 @class CHBShowError
 @brief An error object passed on show-related delegate methods.
 */
@interface CHBShowError : NSError
/*! @brief Error code that indicates the failure reason. */
@property (nonatomic, readonly) CHBShowErrorCode code;
@end


typedef NS_ENUM(NSUInteger, CBLoggingLevel) {
    CBLoggingLevelOff,
    CBLoggingLevelError,
    CBLoggingLevelWarning,
    CBLoggingLevelInfo,
    CBLoggingLevelVerbose
};


typedef NSString * const CBLocation;

/*! "Startup" - Initial startup of game. */
FOUNDATION_EXPORT CBLocation const CBLocationStartup;
/*! "Home Screen" - Home screen the player first sees. */
FOUNDATION_EXPORT CBLocation const CBLocationHomeScreen;
/*! "Main Menu" - Menu that provides game options. */
FOUNDATION_EXPORT CBLocation const CBLocationMainMenu;
/*! "Game Screen" - Game screen where all the magic happens. */
FOUNDATION_EXPORT CBLocation const CBLocationGameScreen;
/*! "Achievements" - Screen with list of achievements in the game. */
FOUNDATION_EXPORT CBLocation const CBLocationAchievements;
/*! "Quests" - Quest, missions or goals screen describing things for a player to do. */
FOUNDATION_EXPORT CBLocation const CBLocationQuests;
/*!  "Pause" - Pause screen. */
FOUNDATION_EXPORT CBLocation const CBLocationPause;
/*! "Level Start" - Start of the level. */
FOUNDATION_EXPORT CBLocation const CBLocationLevelStart;
/*! "Level Complete" - Completion of the level */
FOUNDATION_EXPORT CBLocation const CBLocationLevelComplete;
/*! "Turn Complete" - Finishing a turn in a game. */
FOUNDATION_EXPORT CBLocation const CBLocationTurnComplete;
/*! "IAP Store" - The store where the player pays real money for currency or items. */
FOUNDATION_EXPORT CBLocation const CBLocationIAPStore;
/*! "Item Store" - The store where a player buys virtual goods. */
FOUNDATION_EXPORT CBLocation const CBLocationItemStore;
/*! "Game Over" - The game over screen after a player is finished playing. */
FOUNDATION_EXPORT CBLocation const CBLocationGameOver;
/*! "Leaderboard" - List of leaders in the game. */
FOUNDATION_EXPORT CBLocation const CBLocationLeaderBoard;
/*! "Settings" - Screen where player can change settings such as sound. */
FOUNDATION_EXPORT CBLocation const CBLocationSettings;
/*! "Quit" - Screen displayed right before the player exits a game. */
FOUNDATION_EXPORT CBLocation const CBLocationQuit;
/*! "Default" - Supports legacy applications that only have one "Default" location */
FOUNDATION_EXPORT CBLocation const CBLocationDefault;


/*!
@typedef CHBPrivacyStandard
@brief Constant that identifies a privacy standard to comply to.
*/
typedef NSString * CHBPrivacyStandard NS_TYPED_EXTENSIBLE_ENUM;
/*! @brief GDPR privacy standard identifier */
FOUNDATION_EXPORT CHBPrivacyStandard const CHBPrivacyStandardGDPR;
/*! @brief CCPA privacy standard identifier */
FOUNDATION_EXPORT CHBPrivacyStandard const CHBPrivacyStandardCCPA;
/*! @brief COPPA privacy standard identifier */
FOUNDATION_EXPORT CHBPrivacyStandard const CHBPrivacyStandardCOPPA;
/*! @brief LGPD privacy standard identifier */
FOUNDATION_EXPORT CHBPrivacyStandard const CHBPrivacyStandardLGPD;

/*!
@class CHBDataUseConsent
@brief Abstract class. Subclasses define a data use consent option for a privacy standard.
Not intended to be used directly, always use a subclass to pass to +[Chartboost addDataUseConsent:] or to cast the result of +[Chartboost dataUseConsentForPrivacyStandard:]
*/
@interface CHBDataUseConsent: NSObject
/*! @brief The identifier for the privacy standard this consent applies to. */
@property (nonatomic, readonly) CHBPrivacyStandard privacyStandard;
/*! @brief Use the subclasses initializers to obtain a valid consent instance. */
- (instancetype)init NS_UNAVAILABLE;

@end

// MARK: - GDPR

/*!
@typedef NS_ENUM (NSUInteger, CHBGDPRConsent)
@brief Consent options for GDPR compliance.
*/
typedef NS_ENUM(NSUInteger, CHBGDPRConsent) {
    /*! User does not consent to behavioral targeting in compliance with GDPR. */
    CHBGDPRConsentNonBehavioral,
    /*! User consents to behavioral targeting in compliance with GDPR. */
    CHBGDPRConsentBehavioral
} NS_SWIFT_NAME(CHBGDPRDataUseConsent.Consent);

/*!
@class CHBGDPRDataUseConsent
@brief CHBDataUseConsent subclass for compliance with GDPR.
*/
NS_SWIFT_NAME(CHBDataUseConsent.GDPR)
@interface CHBGDPRDataUseConsent: CHBDataUseConsent
/*! @brief The GDPR consent option. */
@property (nonatomic, readonly) CHBGDPRConsent consent;
/*!
 @brief Returns a GDPR consent object.
 @param consent The desired GDPR consent option.
 */
+ (CHBGDPRDataUseConsent *)gdprConsent:(CHBGDPRConsent)consent NS_SWIFT_NAME(init(_:));

@end

// MARK: - CCPA

/*!
@typedef NS_ENUM (NSUInteger, CHBCCPAConsent)
@brief Consent options for CCPA compliance.
*/
typedef NS_ENUM(NSUInteger, CHBCCPAConsent) {
    /*! User does not consent to the sale of his or her personal information in compliance with CCPA. */
    CHBCCPAConsentOptOutSale,
    /*! User consents to the sale of his or her personal information in compliance with CCPA. */
    CHBCCPAConsentOptInSale
} NS_SWIFT_NAME(CHBCCPADataUseConsent.Consent);

/*!
@class CHBCCPADataUseConsent
@brief CHBDataUseConsent subclass for compliance with CCPA.
*/
NS_SWIFT_NAME(CHBDataUseConsent.CCPA)
@interface CHBCCPADataUseConsent: CHBDataUseConsent
/*! @brief The CCPA consent option. */
@property (nonatomic, readonly) CHBCCPAConsent consent;
/*!
@brief Returns a CCPA consent object.
@param consent The desired CCPA consent option.
*/
+ (CHBCCPADataUseConsent *)ccpaConsent:(CHBCCPAConsent)consent NS_SWIFT_NAME(init(_:));
@end

// MARK: - COPPA

/*!
@class CHBCOPPADataUseConsent
@brief CHBDataUseConsent subclass for compliance with COPPA.
*/
NS_SWIFT_NAME(CHBDataUseConsent.COPPA)
@interface CHBCOPPADataUseConsent: CHBDataUseConsent
/*! @brief Indicates if the app is directed to children. */
@property (nonatomic, readonly) BOOL isChildDirected;
/*!
 @brief Returns a COPPA consent object.
 @param isChildDirected Pass `true` if your app is directed to children.
 */
+ (CHBCOPPADataUseConsent *)isChildDirected:(BOOL)isChildDirected NS_SWIFT_NAME(init(isChildDirected:));
@end

// MARK: - LGPD

/*!
@class CHBLGPDDataUseConsent
@brief CHBDataUseConsent subclass for compliance with LGPD.
*/
NS_SWIFT_NAME(CHBDataUseConsent.LGPD)
@interface CHBLGPDDataUseConsent: CHBDataUseConsent
/*! @brief Indicates if the user consents to behavioral targeting in compliance with LGPD. */
@property (nonatomic, readonly) BOOL allowBehavioralTargeting;
/*!
 @brief Returns a LGPD consent object.
 @param allowBehavioralTargeting Pass `true` if the user consents to behavioral targeting, `false` otherwise.
 */
+ (CHBLGPDDataUseConsent *)allowBehavioralTargeting:(BOOL)allowBehavioralTargeting NS_SWIFT_NAME(init(allowBehavioralTargeting:));
@end

// MARK: - Custom

/*!
@class CHBCustomDataUseConsent
@brief CHBDataUseConsent subclass for compliance with a custom privacy standard.
*/
NS_SWIFT_NAME(CHBDataUseConsent.Custom)
@interface CHBCustomDataUseConsent: CHBDataUseConsent
/*! @brief The custom consent value. */
@property (nonatomic, readonly) NSString *consent;
/*!
 @brief Returns a custom consent object.
 @discussion Normally you would use other CHBDataUseConsent subclasses instead, which provide predefined options for current privacy standards.
 If you decide to use this make sure you pass valid values, as defined in https://answers.chartboost.com/en-us/child_article/ios-privacy-methods
 @param privacyStandard The desired privacy standard identifier.
 @param consent The desired consent value.
*/
+ (CHBCustomDataUseConsent *)customConsentWithPrivacyStandard:(CHBPrivacyStandard)privacyStandard consent:(NSString *)consent NS_SWIFT_NAME(init(privacyStandard:consent:));

@end


/*!
 @class Chartboost
 @brief Provides global settings and shared functionality for the Chartboost SDK.
 @discussion Make sure to start Chartboost before requesting any ad.
 Setting data use consent information beforehand is also highly recommended, otherwise Chartboost's ability to provide ads might be hindered.
 */
@interface Chartboost : NSObject

/*!
 @brief Starts the SDK with the publisher app credentials.
 @param appID The Chartboost application ID for this app.
 @param appSignature The Chartboost application signature for this app.
 @param completion A completion block to be executed when the SDK finishes initializing.
 It takes an error parameter which indicates if the initialization succeeded or not.
 @discussion This method must be called before creating an ad. Other methods, like data use consent or logging level methods, are fine to call before start.
 */
+ (void)startWithAppID:(NSString *)appID appSignature:(NSString *)appSignature completion:(void (^)(CHBStartError * _Nullable error))completion;

/*!
 @brief Use to restrict Chartboost's ability to collect personal data from the user.
 @discussion This method can be called multiple times to set the consent for different privacy standards.
 If a consent has already been set for a privacy standard, adding a consent object for that standard will overwrite the previous value.
 
 This method should be called before starting the Chartboost SDK with startWithAppID:appSignature:completion: if possible.
 The added consents are persisted, so you may just call this when the consent status needs to be updated.
*/
+ (void)addDataUseConsent:(CHBDataUseConsent *)consent NS_SWIFT_NAME(addDataUseConsent(_:));

/*!
 @brief Clears the previously added consent for the desired privacy standard.
 @param privacyStandard The privacy standard for which you want to clear the consent.
 @discussion Chartboost persists the added consents, so you'll need to call this method if you want to withdraw a previously added consent.
 If no consent was available for the indicated standard nothing will happen.
*/
+ (void)clearDataUseConsentForPrivacyStandard:(CHBPrivacyStandard)privacyStandard NS_SWIFT_NAME(clearDataUseConsent(for:));

/*!
 @brief Returns the current consent status for the desired privacy standard.
 @param privacyStandard The privacy standard for which you want to obtain the consent status.
 @returns A CHBDataUseConsent subclass (the same one used to set the consent in addDataUseConsent:) or nil if no consent status is currently available.
 @discussion Use this to check the current consent status, either set by a call to addDataUseConsent: or persisted from a call to the same method on a previous app run. You may need to cast the returned object to the proper CHBDataUseConsent subclass in order to read its consent value.
 
 For example, to check if a consent is not set for GDPR:
 @code
 // Obj-C
 if (![Chartboost dataUseConsentForPrivacyStandard:CHBPrivacyStandardGDPR]) { ... }
 // Swift
 if Chartboost.dataUseConsent(for: .GDPR) == nil { ... }
 @endcode
 
 To check the specific consent status for GDPR:
 @code
 // Obj-C
 CHBGDPRDataUseConsent *gdpr = [Chartboost dataUseConsentForPrivacyStandard:CHBPrivacyStandardGDPR];
 if (gdpr && gdpr.consent == CHBGDPRConsentNonBehavioral) { ... }
 // Swift
 let gdpr = Chartboost.dataUseConsent(for: .GDPR) as? CHBDataUseConsent.GDPR
 if gdpr?.consent == .nonBehavioral { ... }
 @endcode
 */
+ (nullable __kindof CHBDataUseConsent *)dataUseConsentForPrivacyStandard:(CHBPrivacyStandard)privacyStandard NS_SWIFT_NAME(dataUseConsent(for:));

/*!
 @brief The version of the Chartboost SDK.
 */
+ (NSString *)getSDKVersion;

/*!
 @brief Sets a logging level.
 @param loggingLevel The minimum level that's going to be logged
 @discussion Logging by default is off.
 */
+ (void)setLoggingLevel:(CBLoggingLevel)loggingLevel;

/*!
 @brief Mute/unmute Chartboost ads.
 @param muted `true` to mute ads, `false` to unmute them.
 @discussion The default value is `false` (non-muted).
 Due to limitations of Apple's WebKit framework and its WKWebView class, used by Chartboost to display ads, some ads may not be muted regardless of this setting.
 */
+ (void)setMuted:(BOOL)muted;

@end

@protocol CHBAdDelegate;

@protocol CHBAd <NSObject>

/*!
 @brief The delegate instance to receive ad callbacks.
 */
@property (nonatomic, weak, nullable) id<CHBAdDelegate> delegate;

/*!
 @brief Chartboost location for the ad.
 @discussion Used to obtain ads with increased performance.
 */
@property (nonatomic, readonly) CBLocation location;

/*!
 @brief Determines if a cached ad exists.
 @return YES if there is a cached ad, and NO if not.
 */
@property (nonatomic, readonly) BOOL isCached;

/*!
 @brief Caches an ad.
 @discussion This method will first check if there is a cached ad and, if found, will do nothing.
 If no cached ad exists the method will attempt to fetch it from the Chartboost server.
 Implement didCacheAd:error: in your ad delegate to be notified of a cache request result.
 */
- (void)cache;

/*!
 @brief Shows an ad.
 @param viewController The view controller to present the ad on.
 @discussion This method will first check if there is a cached ad, if found it will present it.
 It is highly recommended that a non-nil view controller is passed, as it is required for enhanced ad presentation and some features like opening links in an in-app web browser.
 */
- (void)showFromViewController:(nullable UIViewController *)viewController;

@end

@interface CHBAdEvent : NSObject
/*!
 @brief The ad related to the event.
 */
@property (nonatomic, readonly) id<CHBAd> ad;
@end

/*!
 @class CHBCacheEvent
 @brief A CHBAdEvent subclass passed on cache-related delegate methods.
 */
@interface CHBCacheEvent : CHBAdEvent
@end

/*!
 @class CHBShowEvent
 @brief A CHBAdEvent subclass passed on show-related delegate methods.
 */
@interface CHBShowEvent : CHBAdEvent
@end

/*!
 @class CHBClickEvent
 @brief A CHBAdEvent subclass passed on click-related delegate methods.
 */
@interface CHBClickEvent : CHBAdEvent
/*!
 @brief The view controller used to present the viewer for the link associated with the click.
 @discussion This is the view controller you passed on the showFromViewController: call or a Chartboost ad view controller which was presented on top of it. If you called showFromViewController: passing a nil view controller this property will be nil too.
 You may use it to present your custom click confirmation gate if you implement the shouldConfirmClick:confirmationHandler: ad delegate method.
 */
@property (nonatomic, readonly, nullable) UIViewController *viewController;
@end

/*!
 @class CHBDismissEvent
 @brief A CHBAdEvent subclass passed on dismiss-related delegate methods.
 */
@interface CHBDismissEvent : CHBAdEvent
@end

/*!
 @class CHBRewardEvent
 @brief A CHBAdEvent subclass passed on reward-related delegate methods.
 */
@interface CHBRewardEvent : CHBAdEvent
/*!
 @brief The earned reward.
 */
@property (nonatomic, readonly) NSInteger reward;
@end

@interface CHBImpressionEvent : CHBAdEvent
@end

// MARK: - Delegate

/*!
 @protocol CHBAdDelegate
 @brief The protocol which all Chartboost ad delegates inherit from.
 @discussion Provides methods to receive notifications related to an ad's actions and to control its behavior.
 */
@protocol CHBAdDelegate <NSObject>

@optional

/*!
 @brief Called after a cache call, either if an ad has been loaded from the Chartboost servers and cached, or tried to but failed.
 @param event A cache event with info related to the cached ad.
 @param error An error specifying the failure reason, or nil if the operation was successful.
 @discussion Implement to be notified of when an ad is ready to be shown after the cache method has been called.
 
 A typical implementation would look like this:
 @code
 - (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error {
    if (error) {
        // Handle error
    } else {
        // At this point event.ad.isCached will be true, and the ad is ready to be shown.
    }
 }
 @endcode
 */
- (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error;

/*!
 @brief Called after a showFromViewController: call, right before an ad is presented.
 @param event A show event with info related to the ad to be shown.
 @discussion Implement to be notified of when an ad is about to be presented.
 
 A typical implementation would look like this:
 @code
 - (void)willShowAd:(CHBShowEvent *)event {
    // Pause ongoing processes like video or gameplay.
 }
 @endcode
 */
- (void)willShowAd:(CHBShowEvent *)event;

/*!
 @brief Called after a showFromViewController: call, either if the ad has been presented and an ad impression logged, or if the operation failed.
 @param event A show event with info related to the ad shown.
 @param error An error specifying the failure reason, or nil if the operation was successful.
 @discussion Implement to be notified of when the ad presentation process has finished. Note that this method may be called more than once if some error occurs after the ad has been successfully shown.
 
 A common practice consists of caching an ad here so there's an ad ready for the next time you need to show it.
 Note that this is not necessary for banners with automaticallyRefreshesContent set to YES.
 @code
 - (void)didShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error {
    if (error) {
        // Handle error, possibly resuming processes paused in willShowAd:
    } else {
        [event.ad cache];
    }
 }
 @endcode
 */
- (void)didShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error;

/*!
 @brief Called whenever the user clicks an ad to give a chance to the developer to present a confirmation gate before the click is handled.
 @param event A click event with info related to the ad clicked.
 @param confirmationHandler A block to be executed only if the return value is YES. It takes a BOOL parameter that indicates if the confirmation gate was passed or not.
 @return YES if the handling of the triggering click should be paused for confirmation, NO if the click should be handled without confirmation.
 @warning If you return YES in your implementation make sure to execute the confirmationHandler at some point, since the ad flow will be paused until then.
 If you use the event's view controller to present a confirmation view make sure it has been dismissed by the time you execute the confirmation handler.
 @discussion If you return YES it is your responsibility to implement some confirmation method that triggers the execution of the confirmationHandler.
 
 If this method is not implemented clicks will be handled without confirmation.
 
 A typical implementation would look like this:
 @code
 - (BOOL)shouldConfirmClick:(CHBClickEvent *)event confirmationHandler:(void(^)(BOOL))confirmationHandler
    if (self.needsClickConfirmation) {
        MyAwesomeAgeGate *ageGate = [[MyAwesomeAgeGate alloc] initWithCompletion:^(BOOL confirmed) {
            [ageGate dismissViewControllerAnimated:YES completion:^{
                confirmationHandler(confirmed);
            }];
        }];
        [event.viewController presentViewController:ageGate animated:YES completion:nil];
        return YES;
    } else {
        return NO;
    }
 }
 @endcode
 */
- (BOOL)shouldConfirmClick:(CHBClickEvent *)event confirmationHandler:(void(^)(BOOL))confirmationHandler;

/*!
 @brief Called after an ad has been clicked.
 @param event A click event with info related to the ad clicked.
 @param error An error specifying the failure reason, or nil if the operation was successful.
 @discussion Implement to be notified of when an ad has been clicked.
 If the click does not result into the opening of a link an error will be provided explaning why.
 
 A typical implementation would look like this:
 @code
 - (void)didClickAd:(CHBClickEvent *)event error:(nullable CHBClickError *)error {
    if (error) {
        // Handle error
    } else {
        // Maybe pause ongoing processes like video or gameplay.
    }
 }
 @endcode
 */
- (void)didClickAd:(CHBClickEvent *)event error:(nullable CHBClickError *)error;

/*!
 @brief Called after an ad has recorded an impression.
 @param event An impression event with info related to the visible ad.
 @discussion Implement to be notified of when an ad has recorded an impression.
 This method will be called once a valid impression is recorded after showing the ad.
 */
- (void)didRecordImpression:(CHBImpressionEvent *)event;

@end

/*!
 @protocol CHBDismissableAdDelegate
 @brief Delegate protocol for ads that can be dismissed.
 @discussion Provides methods to receive notifications related to an ad's actions and to control its behavior.
 */
@protocol CHBDismissableAdDelegate <CHBAdDelegate>

@optional

/*!
 @brief Called after an ad is dismissed.
 @param event A dismiss event with info related to the dismissed ad.
 @discussion Implement to be notified of when an ad is no longer displayed.
 
 A typical implementation would look like this:
 @code
 - (void)didDismissAd:(CHBCacheEvent *)event {
    // Resume processes paused in willShowAd:
 }
 @endcode
 */
- (void)didDismissAd:(CHBDismissEvent *)event;

@end


@protocol CHBInterstitialDelegate <CHBDismissableAdDelegate>

@end

/*!
 @class CHBInterstitial
 
 @brief CHBInterstitial is a full-screen ad.
 
 @discussion To show an interstitial it first needs to be cached. Trying to show an uncached intersitital will always fail, thus it is recommended to always check if the ad is cached first.
 
 You can create and cache as many interstitial as you want, but only one can be presented at the same time.
 
 A basic implementation would look like this:
 @code
 - (void)createAndCacheInterstitial {
    CHBInterstitial *interstitial = [[CHBInterstitial alloc] initWithLocation:CBLocationDefault delegate:self];
    [interstitial cache];
 }
 
 - (void)showInterstitial {
    if (interstitial.isCached) {
        [interstitial showFromViewController:self];
    }
 }
 
 // Delegate methods
 
 - (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error {
    if (error) {
        // Handle error, possibly scheduling a retry
    }
 }
 
 - (void)willShowAd:(CHBShowEvent *)event {
    // Pause ongoing processes
 }
 
 - (void)didDismissAd:(CHBDismissEvent *)event {
    // Resume paused processes
 }
 @endcode
 
 If your application uses a View controller-based status bar appearance (usually the default), an ad shown with a valid view controller will hide the status bar. Otherwise it is your responsibility to hide it or not.
 
 For more information on integrating and using the Chartboost SDK please visit our help site documentation at https://help.chartboost.com
 */
@interface CHBInterstitial : NSObject

/*!
 @brief Chartboost location for the ad.
 @discussion Used to obtain ads with increased performance.
 */
@property (nonatomic, readonly) CBLocation location;

/*!
 @brief The delegate instance to receive interstitial callbacks.
 */
@property (nonatomic, weak, nullable) id<CHBInterstitialDelegate> delegate;

/*!
 @brief Determines if a cached ad exists.
 @return YES if there is a cached ad, and NO if not.
 @discussion A return value of YES here indicates that it is safe to call the showFromViewController: method.
 Calling this method when this value is NO will cause the show request to fail with a CHBShowErrorCodeNoCachedAd error.
 */
@property (nonatomic, readonly) BOOL isCached;

/*!
 @brief The initializer for the interstitial object.
 @param location Location for the interstitial. See the location property documentation.
 @param delegate Delegate for the interstitial. See the delegate property documentation.
 */
- (instancetype)initWithLocation:(CBLocation)location delegate:(nullable id<CHBInterstitialDelegate>)delegate;

/*!
 @brief Please use initWithLocation:delegate: instead.
*/
- (instancetype)init NS_UNAVAILABLE;

/*!
 @brief Caches an ad.
 @discussion This method will first check if there is a cached ad and, if found, will do nothing.
 If no cached ad exists the method will attempt to fetch it from the Chartboost server.
 Implement didCacheAd:error: in your ad delegate to be notified of a cache request result.
 */
- (void)cache;

/*!
 @brief Shows an ad.
 @param viewController The view controller to present the ad on.
 @discussion This method will first check if there is a cached ad, if found it will present it.
 If no cached ad exists the request will fail with a CHBShowErrorCodeNoCachedAd error.
 It is highly recommended that a non-nil view controller is passed, as it is required for enhanced ad presentation and some features like opening links in an in-app web browser.
 Implement didShowAd:error: in your ad delegate to be notified of a show request result.
 */
- (void)showFromViewController:(nullable UIViewController *)viewController;

@end

/*!
 @protocol CHBRewardableAdDelegate
 @brief Delegate protocol for ads that can provide a reward.
 @discussion Provides methods to receive notifications related to an ad's actions and to control its behavior.
 */
@protocol CHBRewardableAdDelegate <CHBAdDelegate>

@optional

/*!
 @brief Called when a rewarded ad has completed playing.
 @param event A reward event with info related to the ad and the reward.
 @discussion Implement to be notified when a reward is earned.
 */
- (void)didEarnReward:(CHBRewardEvent *)event;

@end


/*!
 @protocol CHBRewardedDelegate
 @brief Rewarded delegate protocol that inherits from CHBAdDelegate.
 @discussion Provides methods to receive notifications related to a rewarded ad's actions and to control its behavior.
 In a typical integration you would implement willShowAd: and didDismissAd:, pausing and resuming ongoing processes (e.g: gameplay, video) there.
 The method didEarnReward: needs to be implemented in order to be notified when the user earns a reward.
 */
@protocol CHBRewardedDelegate <CHBDismissableAdDelegate, CHBRewardableAdDelegate>
@end

/*!
 @class CHBRewarded
 
 @brief CHBRewarded is a full-screen ad that provides some reward to the user.
 
 @discussion To show a rewarded ad it first needs to be cached. Trying to show an uncached rewarded ad will always fail, thus it is recommended to always check if the ad is cached first.
 
 You can create and cache as many rewarded ads as you want, but only one can be presented at the same time.
 
 A basic implementation would look like this:
 @code
 - (void)createAndCacheRewarded {
    self.rewarded = [[CHBRewarded alloc] initWithLocation:CBLocationDefault delegate:self];
    [self.rewarded cache];
 }
 
 - (void)showRewarded {
    if (self.rewarded.isCached) {
        [self.rewarded showFromViewController:self];
    }
 }
 
 // Delegate methods
 
 - (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error {
    if (error) {
        // Handle error, possibly scheduling a retry
    }
 }
 
 - (void)willShowAd:(CHBShowEvent *)event {
    // Pause ongoing processes
 }

 - (void)didDismissAd:(CHBDismissEvent *)event {
    // Resume paused processes
 }
 
 - (void)didEarnReward:(CHBRewardEvent *)event {
    // Update app state with event.reward
 }
 @endcode
 
 If your application uses a View controller-based status bar appearance (usually the default), an ad shown with a valid view controller will hide the status bar. Otherwise it is your responsibility to hide it or not.

 For more information on integrating and using the Chartboost SDK please visit our help site documentation at https://help.chartboost.com
 */
@interface CHBRewarded : NSObject

/*!
 @brief Chartboost location for the ad.
 @discussion Used to obtain ads with increased performance.
 */
@property (nonatomic, readonly) CBLocation location;

/*!
 @brief The delegate instance to receive rewarded ad callbacks.
 */
@property (nonatomic, weak, nullable) id<CHBRewardedDelegate> delegate;

/*!
 @brief Determines if a cached ad exists.
 @return YES if there is a cached ad, and NO if not.
 @discussion A return value of YES here indicates that it is safe to call the showFromViewController: method.
 Calling this method when this value is NO will cause the show request to fail with a CHBShowErrorCodeNoCachedAd error.
 */
@property (nonatomic, readonly) BOOL isCached;

/*!
 @brief The initializer for the rewarded ad object.
 @param location Location for the rewarded ad. See the location property documentation.
 @param delegate Delegate for the rewarded ad. See the delegate property documentation.
 */
- (instancetype)initWithLocation:(CBLocation)location delegate:(nullable id<CHBRewardedDelegate>)delegate;

/*!
 @brief Please use initWithLocation:delegate: instead.
*/
- (instancetype)init NS_UNAVAILABLE;

/*!
 @brief Caches an ad.
 @discussion This method will first check if there is a cached ad and, if found, will do nothing.
 If no cached ad exists the method will attempt to fetch it from the Chartboost server.
 Implement didCacheAd:error: in your ad delegate to be notified of a cache request result.
 */
- (void)cache;

/*!
 @brief Shows an ad.
 @param viewController The view controller to present the ad on.
 @discussion This method will first check if there is a cached ad, if found it will present it.
 If no cached ad exists the request will fail with a CHBShowErrorCodeNoCachedAd error.
 It is highly recommended that a non-nil view controller is passed, as it is required for enhanced ad presentation and some features like opening links in an in-app web browser.
 Implement didShowAd:error: in your ad delegate to be notified of a show request result.
 */
- (void)showFromViewController:(nullable UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END

#endif /* OMChartboostClass_h */
