// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMChartboostClass_h
#define OMChartboostClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CBLoggingLevel) {
    /*! Logging Off. */
    CBLoggingLevelOff,
    /*! Verbose. */
    CBLoggingLevelVerbose,
    /*! Info. */
    CBLoggingLevelInfo,
    /*! Warning. */
    CBLoggingLevelWarning,
    /*! Error. */
    CBLoggingLevelError,
};

typedef NS_ENUM(NSUInteger, CBFramework) {
    /*! Unity. */
    CBFrameworkUnity,
    /*! Corona. */
    CBFrameworkCorona,
    /*! Adobe AIR. */
    CBFrameworkAIR,
    /*! GameSalad. */
    CBFrameworkGameSalad,
    /*! Cordova. */
    CBFrameworkCordova,
    /*! CocoonJS. */
    CBFrameworkCocoonJS,
    /*! Cocos2d-x. */
    CBFrameworkCocos2dx,
    /*! Prime31Unreal. */
    CBFrameworkPrime31Unreal,
    /*! Weeby. */
    CBFrameworkWeeby,
    /*! Unknown. Other */
    CBFrameworkOther
};

/*!
 @typedef NS_ENUM (NSUInteger, CBPIDataUseConsent)
 
 @abstract
 GDPR compliance settings:
 */
typedef NS_ENUM(NSInteger, CBPIDataUseConsent) {
    /*! Publisher hasn't implemented functionality or the user has the option to not answer. */
    Unknown = -1,
    /*! User does not consent to targeting (Contextual ads). */
    NoBehavioral = 0,
    /*! User consents (Behavioral and Contextual Ads). */
    YesBehavioral = 1
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

@interface Chartboost : NSObject

/*!
 @abstract
 Start Chartboost with required appId, appSignature and delegate.
 
 @param appId The Chartboost application ID for this application.
 
 @param appSignature The Chartboost application signature for this application.
 
 @param completion A completion block to be executed when the SDK finishes initializing.
 It takes a boolean parameter which indicates if the initialization succeeded or not.
 
 @discussion This method must be executed before any other Chartboost SDK methods can be used.
 Once executed this call will also controll session tracking and background tasks
 used by Chartboost.
 */
+ (void)startWithAppId:(NSString*)appId appSignature:(NSString*)appSignature completion:(void (^)(BOOL))completion;

/*!
 @abstract
 Returns the version of the Chartboost SDK.
 */
+ (NSString*)getSDKVersion;

/*!
 @abstract
 Set the logging level
 
 @param loggingLevel The minimum level that's going to be logged
 
 @discussion Logging by default is off.
 */

+ (void)setLoggingLevel:(CBLoggingLevel)loggingLevel;

/*!
 @abstract
 Set a custom identifier to send in the POST body for all Chartboost API server requests.
 
 @param customId The identifier to send with all Chartboost API server requests.
 
 @discussion Use this method to set a custom identifier that can be used later in the Chartboost
 dashboard to group information by.
 */
+ (void)setCustomId:(NSString *)customId;

/*!
 @abstract
 Get the current custom identifier being sent in the POST body for all Chartboost API server requests.
 
 @return The identifier being sent with all Chartboost API server requests.
 
 @discussion Use this method to get the custom identifier that can be used later in the Chartboost
 dashboard to group information by.
 */
+ (NSString *)getCustomId;

/*!
 @abstract
 Set a custom version to append to the POST body of every request. This is useful for analytics and provides chartboost with important information.
 example: [Chartboost setChartboostWrapperVersion:@"6.4.6"];
 
 @param chartboostWrapperVersion The version sent as a string.
 
 @discussion This is an internal method used via Chartboost's Unity and Corona SDKs
 to track their usage.
 */
+ (void)setChartboostWrapperVersion:(NSString*)chartboostWrapperVersion;

/*!
 @abstract
 Set a custom framework suffix to append to the POST headers field.
 example setFramework:Unity withVersion:4.6, setFrameworkVersion:5.2.1
 
 @param framework The suffix to send with all Chartbooost API server requets.
 @param version The platform version used for analytics. Example Unity should set Application.unityVersion
 
 @discussion This is an internal method used via Chartboost's Unity and Corona SDKs
 to track their usage.
 */
+ (void)setFramework:(CBFramework)framework withVersion:(NSString *)version;

/*!
 @abstract
 Decide if Chartboost SDKK will attempt to fetch videos from the Chartboost API servers.
 
 @param shouldPrefetch YES if Chartboost should prefetch video content, NO otherwise.
 
 @discussion Set to control if Chartboost SDK control if videos should be prefetched.
 
 Default is YES.
 */
+ (void)setShouldPrefetchVideoContent:(BOOL)shouldPrefetch;

/*!
 @abstract
 returns YES if auto IAP tracking is enabled, NO if it isn't.
 
 @discussion Call to check if automatic tracking of in-app purchases is enabled.
 The setting is controlled by the server.
 */
+ (BOOL)getAutoIAPTracking;

/*!
 @abstract
 Mute/unmute chartboost ads.
 @param mute YES all sounds, NO activates them. Default is NO
 @discussion default value is NO
 */
+ (void)setMuted:(BOOL)mute;

/*!
 @abstract
 Set to restrict Chartboost's ability to collect personal data from the device. See CBPIDataUseConsent declaration for details
 Note: This method should be called before starting the Chartboost SDK with startWithAppId:appSignature:delegate.
 @param consent set the consent level
 @discussion Default value is Unknown
 */
+ (void)setPIDataUseConsent:(CBPIDataUseConsent)consent;

/*!
 @abstract
 Get the current consent setting
 */
+ (CBPIDataUseConsent)getPIDataUseConsent;
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


// MARK: - Errors

/*!
 @typedef NS_ENUM (NSUInteger, CHBCacheErrorCode)
 @brief Error codes for failed cache operations.
 */
typedef NS_ENUM(NSUInteger, CHBCacheErrorCode) {
    CHBCacheErrorCodeInternal = 0,
    CHBCacheErrorCodeInternetUnavailable = 1,
    CHBCacheErrorCodeNetworkFailure = 5,
    CHBCacheErrorCodeNoAdFound = 6,
    CHBCacheErrorCodeSessionNotStarted = 7,
    CHBCacheErrorCodeAssetDownloadFailure = 16,
    CHBCacheErrorCodePublisherDisabled = 35
};

/*!
 @class CHBCacheError
 @brief An error object passed on cache-related delegate methods.
 */
@interface CHBCacheError : NSObject
/*! @brief Error code that indicates the failure reason. */
@property (nonatomic, readonly) CHBCacheErrorCode code;
@end


/*!
 @typedef NS_ENUM (NSUInteger, CHBShowErrorCode)
 @brief Error codes for failed show operations.
 */
typedef NS_ENUM(NSUInteger, CHBShowErrorCode) {
    CHBShowErrorCodeInternal = 0,
    CHBShowErrorCodeSessionNotStarted = 7,
    CHBShowErrorCodeAdAlreadyVisible = 8,
    CHBShowErrorCodeInternetUnavailable = 25,
    CHBShowErrorCodePresentationFailure = 33,
    CHBShowErrorCodeNoCachedAd = 34
};

/*!
 @class CHBShowError
 @brief An error object passed on show-related delegate methods.
 */
@interface CHBShowError : NSObject
/*! @brief Error code that indicates the failure reason. */
@property (nonatomic, readonly) CHBShowErrorCode code;
@end

/*!
 @typedef NS_ENUM (NSUInteger, CHBClickErrorCode)
 @brief Error codes for failed click operations.
 */
typedef NS_ENUM(NSUInteger, CHBClickErrorCode) {
    CHBClickErrorCodeUriInvalid = 0,
    CHBClickErrorCodeUriUnrecognized = 1,
    CHBClickErrorCodeConfirmationGateFailure = 2,
    CHBClickErrorCodeInternal = 3
};

/*!
 @class CHBClickError
 @brief An error object passed on click-related delegate methods.
 */
@interface CHBClickError : NSObject
/*! @brief Error code that indicates the failure reason. */
@property (nonatomic, readonly) CHBClickErrorCode code;
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
 @brief This method is deprecated in favor of willShowAd:, the error parameter will always be nil.
 If implemented, both willShowAd:error: and willShowAd: will be called when the corresponding event occurs.
 */
- (void)willShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error DEPRECATED_MSG_ATTRIBUTE("Please use willShowAd: instead. This method is deprecated and will be removed in a future version.");

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
 @brief Called when the link viewer presented as result of an ad click has been dismissed.
 @param event A click event with info related to the ad clicked.
 @param error An error specifying the failure reason, or nil if the operation was successful.
 @discussion Implement to be notified of when an ad click has been handled.
 This can mean an in-app web browser or App Store app sheet has been dismissed, or that the user came back to the app after the link was opened on an external application.
 
 A typical implementation would look like this:
 @code
 - (void)didFinishHandlingClick:(CHBClickEvent *)event error:(nullable CHBClickError *)error {
    // Resume processes previously paused on didClickAd:error: implementation.
 }
 @endcode
 */
- (void)didFinishHandlingClick:(CHBClickEvent *)event error:(nullable CHBClickError *)error;

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
