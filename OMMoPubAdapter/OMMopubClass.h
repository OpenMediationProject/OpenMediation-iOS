// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3
#ifndef OMMopubClass_h
#define OMMopubClass_h

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    MPNativeAdOrientationAny,
    MPNativeAdOrientationPortrait,
    MPNativeAdOrientationLandscape
} MPNativeAdOrientation;


@protocol MPMoPubAdDelegate;

/**
 This protocol defines functionality that is shared between all MoPub ads.
 */
@protocol MPMoPubAd <NSObject>

@required
/**
 All MoPub ads have a delegate to call back when certain events occur.
 */
@property (nonatomic, weak, nullable) id<MPMoPubAdDelegate> delegate;

@end

@class MPImpressionData;

@protocol MPMoPubAdDelegate <NSObject>

@optional
/**
 Called when an impression is fired on the @c MPMoPubAd instance. Includes information about the impression if applicable.

 @param ad The @c MPMoPubAd instance that fired the impression
 @param impressionData Information about the impression, or @c nil if the server didn't return any information.
 */
- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData * _Nullable)impressionData;

@end


typedef NS_ENUM(NSUInteger, MPBLogLevel) {
    MPBLogLevelDebug = 20,
    MPBLogLevelInfo  = 30,
    MPBLogLevelNone  = 70
};

@interface MPMoPubConfiguration : NSObject

@property (nonatomic, assign) MPBLogLevel loggingLevel;
/**
 Initializes the @c MPMoPubConfiguration object with the required fields.
 @param adUnitId Any valid ad unit ID used within the app used for app initialization.
 @return A configuration instance.
 */
- (instancetype)initWithAdUnitIdForAppInitialization:(NSString *)adUnitId NS_DESIGNATED_INITIALIZER;

@end

@interface MoPub : NSObject

/**
 * Returns the MoPub singleton object.
 *
 * @return The MoPub singleton object.
 */
+ (MoPub * _Nonnull)sharedInstance;


/**
 * Initializes the MoPub SDK asynchronously on a background thread.
 * @remark This should be called from the app's `application:didFinishLaunchingWithOptions:` method.
 * @param configuration Required SDK configuration options.
 * @param completionBlock Optional completion block that will be called when initialization has completed.
 */
- (void)initializeSdkWithConfiguration:(MPMoPubConfiguration * _Nonnull)configuration
                            completion:(void(^_Nullable)(void))completionBlock;

/**
 * A boolean value indicating if the SDK has been initialized. This property's value is @c YES if
 * @c initializeSdkWithConfiguration:completion: has been called and completed; the value is @c NO otherwise.
 */
@property (nonatomic, readonly) BOOL isSdkInitialized;

- (NSString * _Nonnull)version;
- (NSString * _Nonnull)bundleIdentifier;

/**
 * Grants consent on behalf of the current user. If you do not have permission from MoPub to use a custom consent
 * interface, this method will always fail to grant consent.
 */
- (void)grantConsent;

/**
 * Revokes consent on behalf of the current user.
 */
- (void)revokeConsent;

@property (nonatomic, readonly) BOOL canCollectPersonalInfo;

@end

NS_ASSUME_NONNULL_END

#endif /* OMMopubClass_h */
