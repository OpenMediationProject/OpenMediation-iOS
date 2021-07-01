// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMFacebookClass_h
#define OMFacebookClass_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FBAdLogLevel) {
    /// No logging
    FBAdLogLevelNone,
    /// Notifications
    FBAdLogLevelNotification,
    /// Errors only
    FBAdLogLevelError,
    /// Warnings only
    FBAdLogLevelWarning,
    /// Standard log level
    FBAdLogLevelLog,
    /// Debug logging
    FBAdLogLevelDebug,
    /// Log everything (verbose)
    FBAdLogLevelVerbose
};

@interface FBAdInitSettings : NSObject

/**
 Designated initializer for FBAdInitSettings
 If an ad provided service is mediating Audience Network in their sdk, it is required to set the name of the mediation
 service

 @param placementIDs An array of placement identifiers.
 @param mediationService String to identify mediation provider.
 */
- (instancetype)initWithPlacementIDs:(NSArray<NSString *> *)placementIDs mediationService:(NSString *)mediationService;

/**
 An array of placement identifiers.
 */
@property (nonatomic, copy, readonly) NSArray<NSString *> *placementIDs;

/**
 String to identify mediation provider.
 */
@property (nonatomic, copy, readonly) NSString *mediationService;

@end

@interface FBAdInitResults : NSObject

/**
 Boolean which says whether initialization was successful
 */
@property (nonatomic, assign, readonly, getter=isSuccess) BOOL success;

/**
 Message which provides more details about initialization result
 */
@property (nonatomic, copy, readonly) NSString *message;

@end

@interface FBAudienceNetworkAds : NSObject

/**
 Initialize Audience Network SDK at any given point of time. It will be called automatically with default settigs when
 you first touch AN related code otherwise.

 @param settings The settings to initialize with
 @param completionHandler The block which will be called when initialization finished
 */
+ (void)initializeWithSettings:(nullable FBAdInitSettings *)settings
             completionHandler:(nullable void (^)(FBAdInitResults *results))completionHandler;

@end


@interface FBAdSettings : NSObject

@property (class, nonatomic, copy, readonly) NSString *bidderToken;

/// Data processing options.
/// Please read more details at https://developers.facebook.com/docs/marketing-apis/data-processing-options
///
/// @param options Processing options you would like to enable for a specific event. Current accepted value is LDU for
/// Limited Data Use.
/// @param country A country that you want to associate to this data processing option. Current accepted values are 1,
/// for the United States of America, or 0, to request that we geolocate that event.
/// @param state A state that you want to associate with this data processing option. Current accepted values are 1000,
/// for California, or 0, to request that we geolocate that event.
+ (void)setDataProcessingOptions:(NSArray<NSString *> *)options country:(NSInteger)country state:(NSInteger)state;

/// Data processing options.
/// Please read more details at https://developers.facebook.com/docs/marketing-apis/data-processing-options
///
/// @param options Processing options you would like to enable for a specific event. Current accepted value is LDU for
/// Limited Data Use.
+ (void)setDataProcessingOptions:(NSArray<NSString *> *)options;

+ (void)setLogLevel:(FBAdLogLevel)level;

@end

NS_ASSUME_NONNULL_END

#endif /* OMFacebookClass_h */
