// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3
#ifndef OMMopubClass_h
#define OMMopubClass_h

NS_ASSUME_NONNULL_BEGIN

@interface MPMoPubConfiguration : NSObject


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

@end

NS_ASSUME_NONNULL_END

#endif /* OMMopubClass_h */
