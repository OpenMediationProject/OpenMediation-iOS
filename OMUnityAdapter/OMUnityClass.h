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
 *  An enumeration for the error category of load errors
 */
typedef NS_ENUM (NSInteger, UnityAdsLoadError) {
    /**
     * Error related to SDK not initialized
     */
    kUnityAdsLoadErrorInitializeFailed,

    /**
     * Error related to environment or internal services
     */
    kUnityAdsLoadErrorInternal,

    /**
     * Error related to invalid arguments
     */
    kUnityAdsLoadErrorInvalidArgument,

    /**
     * Error related to there being no ads available
     */
    kUnityAdsLoadErrorNoFill,

    /**
     * Error related to there being no ads available
     */
    kUnityAdsLoadErrorTimeout,
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
- (void)unityAdsAdLoaded: (NSString *)placementId;

/**
 * Called when load request has failed to load an ad for a requested placement.
 * @param placementId The ID of the placement as defined in Unity Ads admin tools.
 * @param error UnityAdsLoadError
 * @param message A human readable error message
 */
- (void)unityAdsAdFailedToLoad: (NSString *)placementId
                     withError: (UnityAdsLoadError)error
                   withMessage: (NSString *)message;
@end

//
//typedef NS_ENUM(NSInteger, UnityServicesError) {
//    kUnityServicesErrorInvalidArgument,
//    kUnityServicesErrorInitSanityCheckFail
//};
//
//@protocol UnityServicesDelegate <NSObject>
//- (void)unityServicesDidError:(UnityServicesError)error withMessage:(NSString *)message;
//@end


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

- (void)unityAdsShowComplete: (NSString *)placementId withFinishState: (UnityAdsShowCompletionState)state;

- (void)unityAdsShowFailed: (NSString *)placementId withError: (UnityAdsShowError)error withMessage: (NSString *)message;

- (void)unityAdsShowStart: (NSString *)placementId;

- (void)unityAdsShowClick: (NSString *)placementId;

@end

@interface UnityAds : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)initialize NS_UNAVAILABLE;


/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId   Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 */
+ (void)initialize: (NSString *)gameId;

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId   Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param initializationDelegate delegate for UnityAdsInitialization
 */
+ (void)        initialize: (NSString *)gameId
    initializationDelegate: (nullable id<UnityAdsInitializationDelegate>)initializationDelegate;

/**
 *  Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId        Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param testMode      Set this flag to `YES` to indicate test mode and show only test ads.
 */
+ (void)initialize: (NSString *)gameId
          testMode: (BOOL)testMode;

/**
 * Initializes UnityAds. UnityAds should be initialized when app starts.
 *
 *  @param gameId        Unique identifier for a game, given by Unity Ads admin tools or Unity editor.
 *  @param testMode      Set this flag to `YES` to indicate test mode and show only test ads.
 *  @param initializationDelegate delegate for UnityAdsInitialization
 */
+ (void)        initialize: (NSString *)gameId
                  testMode: (BOOL)testMode
    initializationDelegate: (nullable id<UnityAdsInitializationDelegate>)initializationDelegate;
/**
 *  Load a placement to make it available to show. Ads generally take a few seconds to finish loading before they can be shown.
 *  Note: The `load` API is in closed beta and available upon invite only. If you would like to be considered for the beta, please contact Unity Ads Support.
 *
 *  @param placementId The placement ID, as defined in Unity Ads admin tools.
 */
+ (void)load: (NSString *)placementId;

/**
 *  Load a placement to make it available to show. Ads generally take a few seconds to finish loading before they can be shown.
 *
 *  @param placementId The placement ID, as defined in Unity Ads admin tools.
 *  @param loadDelegate The load delegate.
 */
+ (void)    load: (NSString *)placementId
    loadDelegate: (nullable id<UnityAdsLoadDelegate>)loadDelegate;

/**
 *  Load a placement to make it available to show. Ads generally take a few seconds to finish loading before they can be shown.
 *
 *  @param placementId The placement ID, as defined in Unity Ads admin tools.
 *  @param options The load options.
 *  @param loadDelegate The load delegate.
 */
+ (void)    load: (NSString *)placementId
         options: (UADSLoadOptions *)options
    loadDelegate: (nullable id<UnityAdsLoadDelegate>)loadDelegate;

/**
 *  Show an ad using the provided placement ID.
 *
 *  @param viewController The `UIViewController` that is to present the ad view controller.
 *  @param placementId    The placement ID, as defined in Unity Ads admin tools.
 *  @param showDelegate The show delegate.
 */
+ (void)    show: (UIViewController *)viewController
     placementId: (NSString *)placementId
    showDelegate: (nullable id<UnityAdsShowDelegate>)showDelegate;

/**
 *  Show an ad using the provided placement ID.
 *
 *  @param viewController The `UIViewController` that is to present the ad view controller.
 *  @param placementId    The placement ID, as defined in Unity Ads admin tools.
 *  @param options    Additional options
 *  @param showDelegate The show delegate.
 */
+ (void)    show: (UIViewController *)viewController
     placementId: (NSString *)placementId
         options: (UADSShowOptions *)options
    showDelegate: (nullable id<UnityAdsShowDelegate>)showDelegate;


+ (BOOL)                getDebugMode;
/**
 *  Set the logging verbosity of `UnityAds`. Debug mode indicates verbose logging.
 *  @warning Does not relate to test mode for ad content.
 *  @param enableDebugMode `YES` for verbose logging.
 */
+ (void)setDebugMode: (BOOL)enableDebugMode;
/**
 *  Check to see if the current device supports using Unity Ads.
 *
 *  @return If `NO`, the current device cannot initialize `UnityAds` or show ads.
 */
+ (BOOL)                isSupported;
/**
 *  Check the version of this `UnityAds` SDK
 *
 *  @return String representing the current version name.
 */
+ (NSString *)          getVersion;
/**
 *  Check that `UnityAds` has been initialized. This might be useful for debugging initialization problems.
 *
 *  @return If `YES`, Unity Ads has been successfully initialized.
 */
+ (BOOL)                isInitialized;
/**
 * Get request token.
 *
 * @return Active token or null if no active token is available.
 */
+ (NSString *__nullable)getToken;

@end

//@interface UnityServicesListener : NSObject <UnityServicesDelegate>
//@end

NS_ASSUME_NONNULL_END

#endif /* OMUnityClass_h */
