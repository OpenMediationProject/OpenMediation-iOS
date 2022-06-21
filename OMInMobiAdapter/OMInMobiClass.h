// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMInMobiClass_h
#define OMInMobiClass_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, IMSDKLogLevel) {
    kIMSDKLogLevelNone,
    kIMSDKLogLevelError,
    kIMSDKLogLevelDebug
};

/**
 * User Gender
 */
typedef NS_ENUM (NSInteger, IMSDKGender) {
    kIMSDKGenderMale = 1,
    kIMSDKGenderFemale
};

typedef NS_ENUM(NSInteger, IMStatusCode) {
    kIMStatusCodeNetworkUnReachable,
    kIMStatusCodeNoFill,
    kIMStatusCodeRequestInvalid,
    kIMStatusCodeRequestPending,
    kIMStatusCodeRequestTimedOut,
    kIMStatusCodeMultipleLoadsOnSameInstance,
    kIMStatusCodeInternalError,
    kIMStatusCodeServerError,
    kIMStatusCodeAdActive,
    kIMStatusCodeEarlyRefreshRequest,
    kIMStatusCodeDroppingNetworkRequest
};


@interface IMRequestStatus : NSError
/**
 * Create an InMobi specific error from NSError
 * @param domain The domain where the error occured. (Domain here is specific to iOS)
 * @param code The error code for this error. This can be read from NSError.code
 * @param dict A more detailed explanation of the error. This contains fields like detailed description and name. More detailed documentation is found in NSError.
 */
-(instancetype)initWithDomain:(NSString *)domain code:(IMStatusCode)code userInfo:(NSDictionary *)dict;

@end

@interface IMAdMetaInfo : NSObject

/**
 * CreativeID of the ad.
 */
@property (nonatomic, strong, readonly) NSString* creativeID;
/**
 * Bid info Dictionary of the ad.
 */
@property (nonatomic, strong, readonly) NSDictionary* bidInfo;
/**
 * Bidvalue of the ad.
 */
- (double)getBid;

@end

@interface IMSdk : NSObject

/**
 * Initialize the sdk. This must be called before any other API for the SDK is used.
 * @param accountID account id obtained from the InMobi portal.
 * @param completionBlock A block which is invoked once the SDK has been successfully initialised and is ready
 */
+(void)initWithAccountID:(NSString *)accountID andCompletionHandler:(void (^ _Nullable)( NSError * _Nullable )) completionBlock;
/**
 * Initialize the sdk. This must be called before any other API for the SDK is used.
 * @param accountID account id obtained from the InMobi portal.
 */
+(void)initWithAccountID:(NSString *)accountID __attribute((deprecated("Please use new API initWithAccountID:andCompletionHandler: as this API can be removed in future")));
/**
 * Initialize the sdk. This must be called before any other API for the SDK is used.
 * @param accountID account id obtained from the InMobi portal.
 * @param consentDictionary InMobi relies on the publishers to obtain explicit consent from users for continuing business activities in EU as per GDPR . Consent dictionary allows publishers to indicate consent status as obtained from the users for InMobi services to function appropriately.
 * It has Three optional keys:"gdpr", IM_GDPR_CONSENT_AVAILABLE, IM_GDPR_CONSENT_IAB
 * "gdpr"(String): Whether or not the request is subjected to GDPR regulations (0 = No, 1 = Yes), omission indicates Unknown.
 * IM_GDPR_CONSENT_AVAILABLE(string): "true" : User has provided consent to collect and use data.
 *                                    "false": User has not provided consent to collect and use data.
 * IM_GDPR_CONSENT_IAB(string): Key to send the IAB consent string.
 * @param completionBlock A block which is invoked once the SDK has been successfully initialised and is ready
 */
+(void)initWithAccountID:(NSString *)accountID consentDictionary:(nullable NSDictionary*) consentDictionary andCompletionHandler:(void (^ _Nullable)( NSError * _Nullable )) completionBlock;
/**
 * Initialize the sdk. This must be called before any other API for the SDK is used.
 * @param accountID account id obtained from the InMobi portal.
 * @param consentDictionary InMobi relies on the publishers to obtain explicit consent from users for continuing business activities in EU as per GDPR . Consent dictionary allows publishers to indicate consent status as obtained from the users for InMobi services to function appropriately.
 * It has Three optional keys:"gdpr", IM_GDPR_CONSENT_AVAILABLE, IM_GDPR_CONSENT_IAB
 * "gdpr"(String): Whether or not the request is subjected to GDPR regulations (0 = No, 1 = Yes), omission indicates Unknown.
 * IM_GDPR_CONSENT_AVAILABLE(string): "true" : User has provided consent to collect and use data.
 *                                    "false": User has not provided consent to collect and use data.
 * IM_GDPR_CONSENT_IAB(string): Key to send the IAB consent string.
 */
+(void)initWithAccountID:(NSString *)accountID consentDictionary:(nullable NSDictionary*) consentDictionary __attribute((deprecated("Please use new API initWithAccountID:consentDictionary:andCompletionHandler: as this API can be removed in future")));
/**
 * updates the user consent for a session of the app
 *
 * @param consentDictionary consent dicionary allows publishers to provide its consent to collect user data and use it.
 * It has Three optional keys:"gdpr", IM_GDPR_CONSENT_AVAILABLE, IM_GDPR_CONSENT_IAB
 * "gdpr"(String): Whether or not the request is subjected to GDPR regulations (0 = No, 1 = Yes), omission indicates Unknown.
 * IM_GDPR_CONSENT_AVAILABLE(string): "true" : User has provided consent to collect and use data.
 *                                    "false": User has not provided consent to collect and use data.
 * IM_GDPR_CONSENT_IAB(string): Key to send the IAB consent string.
 */
+(void)updateGDPRConsent:(nullable NSDictionary *)consentDictionary;
/**
 * Use this to get the version of the SDK.
 * @return The version of the SDK.
 */
+(NSString *)getVersion;
/**
 * Set the log level for SDK's logs
 * @param desiredLogLevel The desired level of logs.
 */
+(void)setLogLevel:(IMSDKLogLevel)desiredLogLevel;
/**
 * Use this to set the global state of the SDK to mute.
 * @param shouldMute Boolean depicting the mute state of the SDK
 */
+(void)setMute:(BOOL)shouldMute;

#pragma mark Audience Bidding
/**
 * Use this API to get token for Audience Bidding.
 * @return The token string.
 */
+(NSString *)getToken;
/**
 * Use this API to get token for Audience Bidding.
 * @param extras  Any additional information to be passed to InMobi.
 * @param keywords  A free form set of keywords, separated by ',' to be sent with the ad request.
 * @return The token string.
 */
+(NSString *)getTokenWithExtras:(nullable NSDictionary*)extras andKeywords:(nullable NSString*)keywords;

#pragma mark Demog APIs
/**
 * Provide the user's age to the SDK for targetting purposes.
 * @param age The user's age.
 */
+(void)setAge:(unsigned short)age;
/**
 * Provide the user's area code to the SDK for targetting purposes.
 * @param areaCode The user's area code.
 */
+(void)setAreaCode:(NSString*)areaCode;

/**
 * Provide a user's date of birth to the SDK for targetting purposes.
 * @param yearOfBirth The user's date of birth.
 */
+(void)setYearOfBirth:(NSInteger)yearOfBirth;

/**
 * Provide the user's gender to the SDK for targetting purposes.
 * @param gender The user's gender.
 */
+(void)setGender:(IMSDKGender)gender;
/**
 * Provide the user's interests to the SDK for targetting purposes.
 * @param interests The user's interests.
 */
+(void)setInterests:(NSString*)interests;
/**
 * Provide the user's preferred language to the SDK for targetting purposes.
 * @param language The user's language.
 */
+(void)setLanguage:(NSString*)language;
/**
 * Provide the user's location to the SDK for targetting purposes.
 * @param city The user's city.
 * @param state The user's state.
 * @param country The user's country.
 */
+(void)setLocationWithCity:(NSString*)city state:(NSString*)state country:(NSString*)country;
/**
 * Provide the user's postal code to the SDK for targetting purposes.
 * @param postalcode The user's postalcode.
 */
+(void)setPostalCode:(NSString*)postalcode;

/**
 * Indicates whether the application wants to manage audio session. If set as NO, the InMobi SDK will stop managing AVAudioSession during the HTML video playback lifecycle. If set as YES,
 * the InMobi SDK will manage AVAudioSession. That might set AVAudioSession's category to AVAudioSessionCategoryAmbient and categoryOption to AVAudioSessionCategoryOptionMixWithOthers,
 * when HTML video is rendering. This setting will not stop the app audio from playing in an app. It will mix with ad audio and if any sound playing in another app, it will stop that sound and play the ads'
 * sound and once the ad is dismissed it notifies another app.
 * @param value Boolean depicting enable or disable the AVAudioSession management by SDK
 */
+(void)shouldAutoManageAVAudioSession:(BOOL)value;
/**
 * Set Unified Id procured from vendors directly.
 * The ids are to be submitted in the following format.
 * key would be the vendor and value would be the identifier.
 * {
 * "id5" :  "jkfid3ufolkb89hgvhb@$dj!@?#",
 * "live Ramp":  "$fvjk@kjfsk%$nfkvd9008jkf"
 * }
 *
 * @param ids Represents the unified ids in dictionary format.
 */
+(void)setPublisherProvidedUnifiedId:(NSDictionary*)ids;

+(void)setIsAgeRestricted:(BOOL)isRestricted;

NS_ASSUME_NONNULL_END

@end

#endif /* OMInMobiClass_h */
