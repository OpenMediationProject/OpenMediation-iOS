// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdmostClass_h
#define OMAdmostClass_h

typedef NS_ENUM(NSInteger, AMRLogLevel){
    /// No logs
    AMRLogLevelSilent = 0,

    /// All errors logged
    AMRLogLevelError = 1,

    /// All errors and warnings logged
    AMRLogLevelWarning = 2,

    /// All errors, warnings and infos logged
    AMRLogLevelInfo = 3,

    /// ALL errors, warnings, 3rd party logs and infos logged
    AMRLogLevel3rdParty = 4,

    /// All logged, default
    AMRLogLevelAll = 99
};

typedef NS_ENUM(NSInteger, AMRNetworkType){
    /// NO NETWORK
    AMRNetworkTypeNoNetwork = 0,

    /// ADCOLONY
    AMRNetworkTypeAdColony,

    /// ADFALCON
    AMRNetworkTypeAdFalcon,

    /// ADMOB
    AMRNetworkTypeAdMob,

    /// ADMOST
    AMRNetworkTypeAdMost,

    /// ADTIMING
    AMRNetworkTypeAdtiming,
    
    /// ADX
    AMRNetworkTypeAdX,
    
    /// AFA
    AMRNetworkTypeAFA,

    /// AMAZON
    AMRNetworkTypeAmazon,

    /// APPLOVIN
    AMRNetworkTypeApplovin,

    /// APPNEXT
    AMRNetworkTypeAppnext,
    
    /// AVOCARROT
    AMRNetworkTypeAvocarrot,

    /// CHARTBOOST
    AMRNetworkTypeChartboost,

    /// CONVERSANT
    AMRNetworkTypeConversant,

    /// CROSS PROMOTION
    AMRNetworkTypeCrossPromotion,

    /// FACEBOOK
    AMRNetworkTypeFacebook,

    /// FLURRY
    AMRNetworkTypeFlurry,

    /// FLYMOB
    AMRNetworkTypeFlymob,

    /// FYBER
    AMRNetworkTypeFyber,
    
    /// GLISPA
    AMRNetworkTypeGlispa,

    /// HYPERADS
    AMRNetworkTypeHyper,

    /// INLOCO
    AMRNetworkTypeInloco,

    /// INMOBI
    AMRNetworkTypeInMobi,
    
    /// INNERACTIVE
    AMRNetworkTypeInneractive,
    
    /// IRONSOURCE
    AMRNetworkTypeIronsource,
    
    /// LEADBOLT
    AMRNetworkTypeLeadbolt,
    
    /// LIFTOFF
    AMRNetworkTypeLiftoff,

    /// LOOPME
    AMRNetworkTypeLoopme,

    /// MILLENIAL
    AMRNetworkTypeMillenial,

    /// MOBFOX
    AMRNetworkTypeMobfox,

    /// MOBUSI
    AMRNetworkTypeMobusi,

    /// MOPUB
    AMRNetworkTypeMopub,

    /// NATIVEX
    AMRNetworkTypeNativeX,
    
    /// NEXTAGE
    AMRNetworkTypeNexAge,
    
    /// OGURY
    AMRNetworkTypeOgury,
    
    /// POLLFISH
    AMRNetworkTypePollfish,

    /// PREMIUM
    AMRNetworkTypePremium,
    
    /// PUBNATIVE
    AMRNetworkTypePubNative,

    /// REVMOB
    AMRNetworkTypeRevMob,

    /// SMAATO
    AMRNetworkTypeSmaato,

    /// STARTAPP
    AMRNetworkTypeStartApp,

    /// SUPERSONIC
    AMRNetworkTypeSupersonic,

    /// TAPJOY
    AMRNetworkTypeTapjoy,
    
    /// TAPPX
    AMRNetworkTypeTappx,

    /// UNITY
    AMRNetworkTypeUnityAds,

    /// VUNGLE
    AMRNetworkTypeVungle,
    
    /// SMART AD SERVER
    AMRNetworkTypeSmartAdServer,
    
    /// YOUAPPI
    AMRNetworkTypeYouappi,

    /// APPSAMURAI
    AMRNetworkTypeAppsamurai,

    /// MINTEGRAL
    AMRNetworkTypeMintegral,

    /// MY TARGET
    AMRNetworkTypeMyTarget,

    /// YANDEX
    AMRNetworkTypeYandex,

    /// TAPRESEARCH
    AMRNetworkTypeTapResearch,
    
    /// QUMPARA
    AMRNetworkTypeQumpara,
    
    /// TIKTOK
    AMRNetworkTypeTikTok,
    
    /// CRITEO
    AMRNetworkTypeCriteo,
    
    /// HYPRMX
    AMRNetworkTypeHyprMX,
    
    /// A4G
    AMRNetworkTypeA4G,
    
    /// ADVIEW
    AMRNetworkTypeAdView,
    
    /// REKLAMUP
    AMRNetworkTypeReklamUP,
    
    /// ADREACT
    AMRNetworkTypeAdreact,
    
    /// VERIZON
    AMRNetworkTypeVerizon,
    
    /// NOKTA
    AMRNetworkTypeNokta
};

typedef NS_ENUM(NSInteger, AMRPrivacyConsentStatus) {
    /// Consent not required.
    AMRPrivacyConsentStatusNone = 0,
    
    /// GDPR consent required.
    AMRPrivacyConsentStatusGDPR = 1,
    
    /// CCPA consent required.
    AMRPrivacyConsentStatusCCPA = 2
};

typedef NS_ENUM(NSInteger, AMRAdState) {
    /// Ad state is unknown.
    AMRAdStateUnknown = 0,
    
    /// Frequency cap is finished.
    AMRAdStateFrequencyCapFinished = 1
};

typedef NS_ENUM(NSInteger, AMRNetworkExtras){
    /// Unknown parameter
    AMRNetworkExtrasUnknown = 0,
    
    /// AdMob - tagForChildDirectedTreatment
    AMRNetworkExtrasAdMobTagForChildDirectedTreatment = 1,
    
    /// AdMob - tagForUnderAgeOfConsent
    AMRNetworkExtrasAdMobTagForUnderAgeOfConsent = 2
};

typedef NS_ENUM(NSInteger, AMRErrorCode) {
    AMRErrorCodeUnknownError = 0,
    
    /** No server response. */
    AMRErrorCodeServerError = 500,
    
    /** All placements returned no fill or timeouted! */
    AMRErrorCodeAdRequestFailed = -1,
    
    /** No placements found for zone. */
    AMRErrorCodeNoPlacementFound = 1077,
    
    /** Frequency capping is filled for zone. */
    AMRErrorCodeFrequencyCappingFilled = 1078,
    
    /** No Internet Connection. */
    AMRErrorCodeNoInternetConnection = 1079,
    
    /** Tag disabled for zone. */
    AMRErrorCodeTagDisabled = 1081,
    
    /** NoAd Ad policy found for zone. */
    AMRErrorCodeNoAdPolicyFoundForZone = 1082,
    
    /** NoAd Ad policy found for tag. */
    AMRErrorCodeNoAdPolicyFoundForTag = 1083,
    
    /** Frequency capping is filled for tag. */
    AMRErrorCodeFrequencyCappingFilledForTag = 1084,
    
    /** Ad is not ready to show. */
    AMRErrorCodeAdNotReady = 1085,
    
    /** Invalid zoneId. */
    AMRErrorCodeInvalidZoneId = 1086,
    
    /** Invalid appId. */
    AMRErrorCodeInvalidAppId = 1087,
    
    /** AppId and zoneId does not match. */
    AMRErrorCodeMismatchZoneId = 1088,
    
};

@interface AMRError : NSObject
/**
 * Error code.
 * @see https://admost.github.io/amrios for more information.
 */
@property AMRErrorCode errorCode;
/**
 * Description of error.
 */
@property (readonly) NSString *errorDescription;

+ (instancetype)errorWithError:(NSError *)error;
+ (instancetype)errorWithCode:(AMRErrorCode)code detail:(NSString *)detail;
@end


@interface AMRUserExperiment : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *group;
@end

@interface AMRAd : NSObject
@property NSDictionary* networkData;
@property NSString* zoneId;
@property AMRNetworkType networkType;
@property NSString* networkName;
@property NSNumber* ecpm;
@end

typedef void(^AMRInitCompletionHandler)(AMRError *_Nullable error);

@interface AMRSDK : NSObject

/**
 * Start AMRSDK with your application ID displayed on AMR Dashboard.
 * Example usage:
 * @code
 * [AMRSDK startWithAppId:@"<appId>"];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param appId Your application ID.
 */
+ (void)startWithAppId:(NSString *)appId;

/**
 * Start AMRSDK with your application ID displayed on AMR Dashboard.
 * @see https://admost.github.io/amrios for more information.
 * @param appId Your application ID.
 * @param completion Completion block for init response.
 */
+ (void)startWithAppId:(NSString *)appId completion:(_Nullable AMRInitCompletionHandler)completion;

/**
 * Start AMRSDK with your application ID displayed on AMR Dashboard and use initNetworks bool value to control network initialization.
 * Example usage:
 * @code
 * [AMRSDK startWithAppId:@"<appId>"];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param appId Your application ID.
 * @param initNetworks Bool value to control network initialization
 * @note Please use @code startWithAppId: @endcode instead.
 */

+ (void)startWithAppId:(NSString *)appId shouldInitNetworks:(BOOL)initNetworks __attribute__((deprecated));

/**
 * Init networks to start cacheing banners.
 * Example usage:
 * @code
 * [AMRSDK initNetworks];
 * @endcode
 */

+ (void)initNetworks;

/**
 * Set logging level of AMRSDK.
 * Default value is AMRLogLevelAll which logs everything.
 * Example usage:
 * @code
 * [AMRSDK setLogLevel:AMRLogLevelInfo];
 * @endcode
 * @see AMRTypes.h for more information.
 * @param logLevel Level of log.
 */
+ (void)setLogLevel:(AMRLogLevel)logLevel;

/**
 * Set this value to YES to clear cache on application termination.
 * Default value is NO.
 * Following file types will be deleted from application's cache folder.
 * [@"mp4", @"m4v", @"jpg", @"jpeg", @"png", @"gif", @"svg", @"ttf", @"js", @"css", @"html", @"htm"].
 * @code
 * [AMRSDK setClearCacheOnTerminate:YES];
 * @endcode
 * @param shouldClear boolean value to clear cache on application termination.
 */

+ (void)setClearCacheOnTerminate:(BOOL)shouldClear;

/// Get current SDK version
+ (NSString *)SDKVersion;

/**
 * You can optionally provide a unique user id for reporting purposes.
 * This provided user id will be associated with the AMR User in AMR Dashboard.
 * Example usage:
 * @code
 * [AMRSDK setUserId:@"myUniqueUserId"];
 * @endcode
 * @param userId unique id.
 */
+ (void)setUserId:(NSString *)userId;

/**
* @deprecated This method is deprecated starting in version 1.3.35
* @note AMRSDK gets AdjustUserId automatically.
*/
+ (void)setAdjustUserId:(NSString *)adjustUserId __attribute__((deprecated));

/**
 * You can optionally provide a campaign id.
 * @param campaignId campaign id.
 */
+ (void)setClientCampaignId:(NSString *)campaignId;

/**
 * You can optionally pass data to Ad networks.
 * @param value object you want to pass.
 * @param key key for value.
 */
+ (void)setNetworkExtras:(id)value forKey:(AMRNetworkExtras)key;

/**
 * You can optionally pass userChild parameter to Ad networks.
 * @param userChild object you want to pass.
 */
+ (void)setUserChild:(BOOL)userChild;

/**
 * useHttps is in closed beta and available invite only.
 * @param useHttps object to force sdk to make https requests.
 */
+ (void)setUseHttps:(BOOL)useHttps;

/**
 * Get user data in JSON format after AMRSDK initialization.
 */
+ (NSString *)userData;

/**
 * Get user experiment data after AMRSDK initialization.
 */
+ (AMRUserExperiment *)userExperiment;

/**
 * Start spending virtual currencies.
 * Virtual currency delegate must be set before starting to spend virtual currencies.
 */
+ (void)spendVirtualCurrency;

/**
 * @deprecated This method is deprecated starting in version 1.3.10
 * @note Please use @code trackPurchase:idientifier:currencyCode:amount @endcode instead.
 */
+ (void)trackPurchase:(NSString *)identifier
         currencyCode:(NSString *)currencyCode
               amount:(double)amount
              receipt:(NSData *)receipt __attribute__((deprecated));

/**
 * Track purchase.
 * @param identifier Transaction identifier of SKPaymentTransaction
 * @param currencyCode Currency code of transaction
 * @param amount Amount of transaction
 */
+ (void)trackPurchase:(NSString *)identifier
         currencyCode:(NSString *)currencyCode
               amount:(double)amount;

/**
 * Track in-app purchase is in closed beta and available invite only.
 * @param identifier Transaction identifier of SKPaymentTransaction
 * @param currencyCode Currency code of transaction
 * @param amount Amount of transaction
 * @param tags Distinction value for in-app purchase that used in multiple purposes.
 */
+ (void)trackIAP:(NSString *)identifier
    currencyCode:(NSString *)currencyCode
          amount:(double)amount
            tags:(NSArray *)tags;


/**
 * @deprecated This method is deprecated please use startTesterInfoWithAppId method instead.
 */
+ (void)startTestSuiteWithAppId:(NSString *)appId __attribute__((deprecated));

/**
 * @deprecated This method is deprecated please use startTesterInfoWithAppId method instead.
 */
+ (void)startTestSuiteWithZones:(NSArray *)zones __attribute__((deprecated));

/**
 * Start Tester Info
 * You must be a Tester to show Tester Info on devices.
 * @param appId Your application ID.
 */
+ (void)startTesterInfoWithAppId:(NSString *)appId;

/**
 * @deprecated This method is deprecated please use isPrivacyConsentRequired method instead.
 * You can optionally use isGDPRApplicable method to obtain the user is in a GDPR required country.
 */

+ (void)isGDPRApplicable:(void (^)(BOOL isGDPRApplicable))completion __attribute__((deprecated));

/**
 * You can optionally use isPrivacyConsentRequired method to obtain the user is in a GDPR or CCPA required country.
 */

+ (void)isPrivacyConsentRequired:(void (^)(AMRPrivacyConsentStatus consentStatus))completion;

/**
 * We specified your responsibilities for obtaining consent from end-users of your apps in our updated Privacy Policy.
 * By updating GDPR or CCPA compatible SDK you agree that you’re responsible for inform the end users and take their consent.
 * Please note that the GDPR consent collection applies only to users located in the European Economic Area, the United Kingdom, and Switzerland.
 * Please note that the CCPA consent collection applies only to users located in the California..
 * The setUserConsent method takes either NO (user does not consent) or YES (user does consent).
 * @param consent of the user.
 */
+ (void)setUserConsent:(BOOL)consent;

/**
 * We specified your responsibilities for obtaining consent from end-users of your apps in our updated Privacy Policy.
 * By updating GDPR or CCPA compatible SDK you agree that you’re responsible for inform the end users and take their consent.
 * Please note that the GDPR consent collection applies only to users located in the European Economic Area, the United Kingdom, and Switzerland.
 * Please note that the CCPA consent collection applies only to users located in the California..
 * The setTCFConsent method takes either NO (user does not consent) or YES (user does consent).
 * @param vendors consent of the user for vendors.
 */
+ (void)setTCFVendors:(NSDictionary *)vendors;

/**
 * You can optionally use subjectToGDPR method to set GDPR applicable to the user or not.
 * If you do not provide this information AMRSDK will use its own methods.
 * @param subject for GDPR.
 */
+ (void)subjectToGDPR:(BOOL)subject;

/**
 * You can optionally use subjectToCCPA method to set CCPA applicable to the user or not.
 * If you do not provide this information AMRSDK will use its own methods.
 * @param subject for GDPR.
 */
+ (void)subjectToCCPA:(BOOL)subject;


+ (BOOL)isStatusBarHidden __attribute__((deprecated));
+ (BOOL)isInitNetworks __attribute__((deprecated));
+ (void)preloadBannersWithZoneIds:(NSArray *)zoneIds __attribute__((deprecated));
+ (void)setStatusBarHidden:(BOOL)isHidden __attribute__((deprecated));
@end

/**
 * @protocol AMRVirtualCurrencyDelegate
 * @brief The AMRVirtualCurrencyDelegate protocol.
 * This protocol is used as a delegate for virtual currency events.
 */
@protocol AMRVirtualCurrencyDelegate <NSObject>

/**
 * Successfully spent virtual currency.
 * @param amount Amount of virtual currency.
 * @param currency Currency of virtual currency.
 * @param networkName Network name of cirtual currency ad network.
 */
- (void)didSpendVirtualCurrency:(NSString *)currency
                         amount:(NSNumber *)amount
                    networkName:(NSString *)networkName;

@optional
/**
 * @deprecated This method is deprecated starting in version 1.3.64
 * @note Please use @code didSpendVirtualCurrency:currency:amount:networkName @endcode instead.
 */
- (void)didSpendVirtualCurrency:(NSString *)currency
                          amout:(NSNumber *)amount
                        network:(AMRNetworkType)network __attribute__((deprecated));

@end

#endif /* OMAdmostClass_h */
