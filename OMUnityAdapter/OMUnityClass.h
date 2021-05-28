// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMUnityClass_h
#define OMUnityClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UADSMetaData : NSObject

- (BOOL)set:(NSString *)key value:(id)value;
- (void)commit;

@end

/**
 *  An enumeration for the various errors that can be emitted through the `UnityAdsDelegate` `unityAdsDidError:withMessage:` method.
 */
typedef NS_ENUM(NSInteger, UnityAdsError) {
    /**
     *  An error that indicates failure due to `UnityAds` currently being uninitialized.
     */
    kUnityAdsErrorNotInitialized = 0,
    /**
     *  An error that indicates failure due to a failure in the initialization process.
     */
    kUnityAdsErrorInitializedFailed,
    /**
     *  An error that indicates failure due to attempting to initialize `UnityAds` with invalid parameters.
     */
    kUnityAdsErrorInvalidArgument,
    /**
     *  An error that indicates failure of the video player.
     */
    kUnityAdsErrorVideoPlayerError,
    /**
     *  An error that indicates failure due to having attempted to initialize the `UnityAds` class in an invalid environment.
     */
    kUnityAdsErrorInitSanityCheckFail,
    /**
     *  An error that indicates failure due to the presence of an ad blocker.
     */
    kUnityAdsErrorAdBlockerDetected,
    /**
     *  An error that indicates failure due to inability to read or write a file.
     */
    kUnityAdsErrorFileIoError,
    /**
     *  An error that indicates failure due to a bad device identifier.
     */
    kUnityAdsErrorDeviceIdError,
    /**
     *  An error that indicates a failure when attempting to show an ad.
     */
    kUnityAdsErrorShowError,
    /**
     *  An error that indicates an internal failure in `UnityAds`.
     */
    kUnityAdsErrorInternalError,
};

typedef NS_ENUM(NSInteger, UnityAdsShowError)
    {
    /**
     * Error related to SDK not initialized
     */
    kUnityShowErrorNotInitialized,
    
    /**
     * Error related to placement not being ready
     */
    kUnityShowErrorNotReady,
    
    /**
     * Error related to video player
     */
    kUnityShowErrorVideoPlayerError,
    
    /**
     * Error related to invalid arguments
     */
    kUnityShowErrorInvalidArgument,
     
    /**
     * Error related to internet connection
     */
    kUnityShowErrorNoConnection,
       
    /**
     * Error related to ad is already being shown
     */
    kUnityShowErrorAlreadyShowing,
    
    /**
     * Error related to environment or internal services
     */
    kUnityShowErrorInternalError
  
};

/**
 *  An enumeration for the completion state of an ad.
 */
typedef NS_ENUM(NSInteger, UnityAdsFinishState) {
    /**
     *  A state that indicates that the ad did not successfully display.
     */
    kUnityAdsFinishStateError,
    /**
     *  A state that indicates that the user skipped the ad.
     */
    kUnityAdsFinishStateSkipped,
    /**
     *  A state that indicates that the ad was played entirely.
     */
    kUnityAdsFinishStateCompleted
};


typedef NS_ENUM(NSInteger, UnityAdsShowCompletionState) {
   /**
    *  A state that indicates that the user skipped the ad.
    */
   kUnityShowCompletionStateSkipped,
   /**
    *  A state that indicates that the ad was played entirely.
    */
   kUnityShowCompletionStateCompleted
};

/**
 *  An enumerate that describes the state of `UnityAds` placements.
 *  @note All placement states, other than `kUnityAdsPlacementStateReady`, indicate that the placement is not currently ready to show ads.
 */
typedef NS_ENUM(NSInteger, UnityAdsPlacementState) {
    /**
     *  A state that indicates that the placement is ready to show an ad. The `show:` selector can be called.
     */
    kUnityAdsPlacementStateReady,
    /**
     *  A state that indicates that no state is information is available.
     *  @warning This state can that UnityAds is not initialized or that the placement is not correctly configured in the Unity Ads admin tool.
     */
    kUnityAdsPlacementStateNotAvailable,
    /**
     *  A state that indicates that the placement is currently disabled. The placement can be enabled in the Unity Ads admin tools.
     */
    kUnityAdsPlacementStateDisabled,
    /**
     *  A state that indicates that the placement is not currently ready, but will be in the future.
     *  @note This state most likely indicates that the ad content is currently caching.
     */
    kUnityAdsPlacementStateWaiting,
    /**
     *  A state that indicates that the placement is properly configured, but there are currently no ads available for the placement.
     */
    kUnityAdsPlacementStateNoFill
};

/**
 *  The `UnityAdsLoadDelegate` protocol defines the required methods for receiving messages from UnityAds.load() method.
 */
@protocol UnityAdsLoadDelegate <NSObject>
/**
 *  Callback triggered when a load request has successfully filled the specified placementId with an ad that is ready to show.
 *
 *  @param placementId The ID of the placement as defined in Unity Ads admin tools.
 */
- (void)unityAdsAdLoaded:(NSString *)placementId;
/**
*  Callback triggered when load request has failed to load an ad for a requested placement.
*
*  @param placementId The ID of the placement as defined in Unity Ads admin tools.
*/
- (void)unityAdsAdFailedToLoad:(NSString *)placementId;
@end



/**
 *  The `UnityAdsDelegate` protocol defines the required methods for receiving messages from UnityAds.
 *  Must be implemented by the hosting app.
 *  The unityAdsReady: method is called when it's possible to show an ad.
 *  All other methods are used to provide notifications of events of the ad lifecycle.
 *  @note On initialization, there are ready (or error) callbacks for each placement attached to the game identifier.
 */
@protocol UnityAdsDelegate <NSObject>
/**
 *  Called when `UnityAds` is ready to show an ad. After this callback you can call the `UnityAds` `show:` method for this placement.
 *  Note that sometimes placement might no longer be ready due to exceptional reasons. These situations will give no new callbacks.
 *
 *  @warning To avoid error situations, it is always best to check `isReady` method status before calling show.
 *  @param placementId The ID of the placement that is ready to show, as defined in Unity Ads admin tools.
 */
- (void)unityAdsReady:(NSString *)placementId;
/**
 *  Called when `UnityAds` encounters an error. All errors will be logged but this method can be used as an additional debugging aid. This callback can also be used for collecting statistics from different error scenarios.
 *
 *  @param error   A `UnityAdsError` error enum value indicating the type of error encountered.
 *  @param message A human readable string indicating the type of error encountered.
 */
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message;
/**
 *  Called on a successful start of advertisement after calling the `UnityAds` `show:` method.
 *
 * @warning If there are errors in starting the advertisement, this method may never be called. Unity Ads will directly call `unityAdsDidFinish:withFinishState:` with error status.
 *
 *  @param placementId The ID of the placement that has started, as defined in Unity Ads admin tools.
 */
- (void)unityAdsDidStart:(NSString *)placementId;
/**
 *  Called after the ad has closed.
 *
 *  @param placementId The ID of the placement that has finished, as defined in Unity Ads admin tools.
 *  @param state       An enum value indicating the finish state of the ad. Possible values are `Completed`, `Skipped`, and `Error`.
 */
- (void)unityAdsDidFinish:(NSString *)placementId
          withFinishState:(UnityAdsFinishState)state;
@end

@protocol UnityAdsExtendedDelegate <UnityAdsDelegate>
/**
 *  Called when a click event happens.
 *
 *  @param placementId The ID of the placement that was clicked.
 */
- (void)unityAdsDidClick:(NSString *)placementId;

/**
 *  Called when a placement changes state.
 *
 *  @param placementId The ID of the placement that changed state.
 *  @param oldState The state before the change.
 *  @param newState The state after the change.
 */
- (void)unityAdsPlacementStateChanged:(NSString *)placementId oldState:(UnityAdsPlacementState)oldState newState:(UnityAdsPlacementState)newState;
@end


typedef NS_ENUM(NSInteger, UnityServicesError) {
    kUnityServicesErrorInvalidArgument,
    kUnityServicesErrorInitSanityCheckFail
};

@protocol UnityServicesDelegate <NSObject>
- (void)unityServicesDidError:(UnityServicesError)error withMessage:(NSString *)message;
@end


/**
 *  An enumeration for the error category of initialization errors
 */
typedef NS_ENUM(NSInteger, UnityAdsInitializationError)
    {
    /**
     *  Error related to environment or internal services.
     */
    kUnityInitializationErrorInternalError,
    
    /**
     * Error related to invalid arguments
     */
    kUnityInitializationErrorInvalidArgument,
    
    /**
     * Error related to url being blocked
     */
    kUnityInitializationErrorAdBlockerDetected
  
};

/**
 * The `UnityAdsInitializationDelegate` defines the methods which will notify UnityAds
 * has either successfully initialized or failed with error category and error message
 */

@protocol UnityAdsInitializationDelegate <NSObject>
/**
 * Called when `UnityAds` is successfully initialized
 */
- (void)initializationComplete;
/**
 * Called when `UnityAds` is failed in initialization.
 * @param error
 *           if `kUnityInitializationErrorInternalError`, initialization failed due to environment or internal services
 *           if `kUnityInitializationErrorInvalidArgument`, initialization failed due to invalid argument(e.g. game ID)
 *           if `kUnityInitializationErrorAdBlockerDetected`, initialization failed due to url being blocked
 * @param message A human readable error message
 */
- (void)initializationFailed:(UnityAdsInitializationError)error withMessage:(NSString *)message;

@end

@class UADSLoadOptions;

@class UADSShowOptions;

@protocol UnityAdsShowDelegate <NSObject>

- (void)unityAdsShowComplete:(NSString *)placementId withFinishState:(UnityAdsShowCompletionState)state;

- (void)unityAdsShowFailed:(NSString *)placementId withError:(UnityAdsShowError)error withMessage:(NSString *)message;

- (void)unityAdsShowStart:(NSString *)placementId;

- (void)unityAdsShowClick:(NSString *)placementId;

@end

@interface UnityAds : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)initialize NS_UNAVAILABLE;

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId   Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param delegate delegate for UnityAdsDelegate callbacks
 */
+ (void)initialize:(NSString *)gameId
          delegate:(nullable id<UnityAdsDelegate>)delegate __attribute__((deprecated("Please migrate to using initialize without a delegate and add the delegate with the addDelegate method")));

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId   Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 */
+ (void)initialize:(NSString *)gameId;

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId   Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param initializationDelegate delegate for UnityAdsInitialization
 */
+ (void)initialize:(NSString *)gameId
        initializationDelegate:(nullable id<UnityAdsInitializationDelegate>)initializationDelegate;

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId        Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param delegate      delegate for UnityAdsDelegate callbacks
 *  @param testMode      Set this flag to `YES` to indicate test mode and show only test ads.
 */
+ (void)initialize:(NSString *)gameId
          delegate:(nullable id<UnityAdsDelegate>)delegate
          testMode:(BOOL)testMode __attribute__((deprecated("Please migrate to using initialize without a delegate and add the delegate with the addDelegate method")));

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId        Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param testMode      Set this flag to `YES` to indicate test mode and show only test ads.
 */
+ (void)initialize:(NSString *)gameId
          testMode:(BOOL)testMode;

/**
 * Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId        Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param testMode      Set this flag to `YES` to indicate test mode and show only test ads.
 *  @param initializationDelegate delegate for UnityAdsInitialization
 */
+ (void)initialize:(NSString *)gameId
          testMode:(BOOL)testMode
          initializationDelegate:(nullable id<UnityAdsInitializationDelegate>)initializationDelegate;

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *  Note: The `load` API is in closed beta and available upon invite only. If you would like to be considered for the beta, please contact Unity Ads Support.
 *
 *  @param gameId        Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param delegate      delegate for UnityAdsDelegate callbacks
 *  @param testMode      Set this flag to `YES` to indicate test mode and show only test ads.
 *  @param enablePerPlacementLoad Set this flag to `YES` to disable automatic placement caching. When this is enabled, developer must call `load` on placements before calling show
 */
+ (void)initialize:(NSString *)gameId
                  delegate:(nullable id<UnityAdsDelegate>)delegate
                  testMode:(BOOL)testMode
    enablePerPlacementLoad:(BOOL)enablePerPlacementLoad __attribute__((deprecated("Please migrate to using initialize without a delegate and add the delegate with the addDelegate method")));

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *  Note: The `load` API is in closed beta and available upon invite only. If you would like to be considered for the beta, please contact Unity Ads Support.
 *
 *  @param gameId        Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param testMode      Set this flag to `YES` to indicate test mode and show only test ads.
 *  @param enablePerPlacementLoad Set this flag to `YES` to disable automatic placement caching. When this is enabled, developer must call `load` on placements before calling show
 */
+ (void)initialize:(NSString *)gameId
                  testMode:(BOOL)testMode
    enablePerPlacementLoad:(BOOL)enablePerPlacementLoad;

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *  Note: The `load` API is in closed beta and available upon invite only. If you would like to be considered for the beta, please contact Unity Ads Support.
 *
 *  @param gameId        Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param testMode      Set this flag to `YES` to indicate test mode and show only test ads.
 *  @param enablePerPlacementLoad Set this flag to `YES` to disable automatic placement caching. When this is enabled, developer must call `load` on placements before calling show
 *  @param initializationDelegate delegate for UnityAdsInitialization
 */
+ (void)initialize:(NSString *)gameId
                  testMode:(BOOL)testMode
    enablePerPlacementLoad:(BOOL)enablePerPlacementLoad
    initializationDelegate:(nullable id<UnityAdsInitializationDelegate>)initializationDelegate;

/**
 *  Load a placement to make it available to show. Ads generally take a few seconds to finish loading before they can be shown.
 *  Note: The `load` API is in closed beta and available upon invite only. If you would like to be considered for the beta, please contact Unity Ads Support.
 *
 *  @param placementId The placement ID, as defined in Unity Ads admin tools.
 */
+ (void)load:(NSString *)placementId;

/**
 *  Load a placement to make it available to show. Ads generally take a few seconds to finish loading before they can be shown.
 *  Note: The `load` API is in closed beta and available upon invite only. If you would like to be considered for the beta, please contact Unity Ads Support.
 *
 *  @param placementId The placement ID, as defined in Unity Ads admin tools.
 *  @param loadDelegate The load delegate.
 */
+ (void) load:(NSString *)placementId
 loadDelegate:(nullable id<UnityAdsLoadDelegate>)loadDelegate;

/**
 *  Load a placement to make it available to show. Ads generally take a few seconds to finish loading before they can be shown.
 *  Note: The `load` API is in closed beta and available upon invite only. If you would like to be considered for the beta, please contact Unity Ads Support.
 *
 *  @param placementId The placement ID, as defined in Unity Ads admin tools.
 *  @param options The load options.
 *  @param loadDelegate The load delegate.
 */
+ (void) load:(NSString *)placementId
      options:(UADSLoadOptions *)options
 loadDelegate:(nullable id<UnityAdsLoadDelegate>)loadDelegate;


/**
 *  Show an ad using the defaul placement.
 *
 *  @param viewController The `UIViewController` that is to present the ad view controller.
 */
+ (void)show:(UIViewController *)viewController __attribute__((deprecated("Please migrate to using show call with placementId and showDelegate instead")));
/**
 *  Show an ad using the provided placement ID.
 *
 *  @param viewController The `UIViewController` that is to present the ad view controller.
 *  @param placementId    The placement ID, as defined in Unity Ads admin tools.
 */
+ (void)show:(UIViewController *)viewController placementId:(NSString *)placementId __attribute__((deprecated("Please migrate to using show call with showDelegate instead")));;
/**
 *  Show an ad using the provided placement ID.
 *
 *  @param viewController The `UIViewController` that is to present the ad view controller.
 *  @param placementId    The placement ID, as defined in Unity Ads admin tools.
 *  @param showDelegate The show delegate.
 */
+ (void)show:(UIViewController *)viewController placementId:(NSString *)placementId showDelegate:(nullable id<UnityAdsShowDelegate>)showDelegate;
/**
 *  Show an ad using the provided placement ID.
 *
 *  @param viewController The `UIViewController` that is to present the ad view controller.
 *  @param placementId    The placement ID, as defined in Unity Ads admin tools.
 *  @param options    Additional options
 */
+ (void)show:(UIViewController *)viewController placementId:(NSString *)placementId options:(UADSShowOptions *)options __attribute__((deprecated("Please migrate to using show call with showDelegate instead")));;
/**
 *  Show an ad using the provided placement ID.
 *
 *  @param viewController The `UIViewController` that is to present the ad view controller.
 *  @param placementId    The placement ID, as defined in Unity Ads admin tools.
 *  @param options    Additional options
 *  @param showDelegate The show delegate.
 */
+ (void)show:(UIViewController *)viewController placementId:(NSString *)placementId options:(UADSShowOptions *)options showDelegate:(nullable id<UnityAdsShowDelegate>)showDelegate;
/**
 *  Provides the currently assigned `UnityAdsDelegate`. Meant to support use of single delegate
 *
 *  @return The current `UnityAdsDelegate`.
 *  @deprecated this method is deprecated in favor of addDelegate
 */
+ (id<UnityAdsDelegate>)getDelegate __attribute__((deprecated("Please migrate to using addDelegate and removeDelegate")));
/**
 *  Allows the delegate to be reassigned after UnityAds has already been initialized. Meant to support use of a single delegate.
 *  Use `addDelegate` if you wish to have multiple `UnityAdsDelegate`
 *  Replaces any delegate set through `setDelegate` and through initialize
 *
 *  @param delegate The new `UnityAdsDelegate' for UnityAds to send callbacks to.
 *  @deprecated this method is deprecated in favor of addDelegate
 */
+ (void)setDelegate:(id<UnityAdsDelegate>)delegate __attribute__((deprecated("Please migrate to using addDelegate and removeDelegate")));

/**
 *  Allows a delegate to be registered after UnityAds has already been initialized.
 *
 *  @param delegate The new `UnityAdsDelegate' for UnityAds to send callbacks to.
 */
+ (void)addDelegate:(__nullable id<UnityAdsDelegate>)delegate;
/**
 *  Allows a delegate to be removed after UnityAds has already been initialized.
 *  This only removes delegates that have been added through `addDelegate`
 *
 *  @param delegate The already added `UnityAdsDelegate' for UnityAds to send callbacks to.
 */
+ (void)removeDelegate:(id<UnityAdsDelegate>)delegate;

/**
 *  Get the current debug status of `UnityAds`.
 *
 *  @return If `YES`, `UnityAds` will provide verbose logs.
 */
+ (BOOL)getDebugMode;
/**
 *  Set the logging verbosity of `UnityAds`. Debug mode indicates verbose logging.
 *  @warning Does not relate to test mode for ad content.
 *  @param enableDebugMode `YES` for verbose logging.
 */
+ (void)setDebugMode:(BOOL)enableDebugMode;
/**
 *  Check to see if the current device supports using Unity Ads.
 *
 *  @return If `NO`, the current device cannot initialize `UnityAds` or show ads.
 */
+ (BOOL)isSupported;
/**
 *  Check if the default placement is ready to show an ad.
 *
 *  @return If `YES`, the default placement is ready to show an ad.
 */
+ (BOOL)isReady;
/**
 *  Check if a particular placement is ready to show an ad.
 *
 *  @param placementId The placement ID being checked.
 *
 *  @return If `YES`, the placement is ready to show an ad.
 */
+ (BOOL)isReady:(NSString *)placementId;
/**
 *  Check the current state of the default placement.
 *
 *  @return If this is `kUnityAdsPlacementStateReady`, the placement is ready to show ads. Other states represent errors.
 */
+ (UnityAdsPlacementState)getPlacementState;
/**
 *  Check the current state of a placement.
 *
 *  @param placementId The placement ID, as defined in Unity Ads admin tools.
 *
 *  @return If this is `kUnityAdsPlacementStateReady`, the placement is ready to show ads. Other states represent errors.
 */
+ (UnityAdsPlacementState)getPlacementState:(NSString *)placementId;
/**
 *  Check the version of this `UnityAds` SDK
 *
 *  @return String representing the current version name.
 */
+ (NSString *)getVersion;
/**
 *  Check that `UnityAds` has been initialized. This might be useful for debugging initialization problems.
 *
 *  @return If `YES`, Unity Ads has been successfully initialized.
 */
+ (BOOL)isInitialized;
/**
 * Get request token.
 *
 * @return Active token or null if no active token is available.
 */
+ (NSString* __nullable)getToken;

@end

@interface UnityServicesListener : NSObject <UnityServicesDelegate>
@end

NS_ASSUME_NONNULL_END

#endif /* OMUnityClass_h */
