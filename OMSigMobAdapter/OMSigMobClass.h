// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMSigMobClass_h
#define OMSigMobClass_h

typedef NS_ENUM (NSInteger, WindCCPAStatus) {
    WindCCPAUnknown = 0,
    WindCCPAAccepted,
    WindCCPADenied,
};

typedef NS_ENUM (NSInteger, WindConsentStatus) {
    WindConsentUnknown = 0,
    WindConsentAccepted,
    WindConsentDenied,
};

typedef NS_ENUM (NSInteger, WindAgeRestrictedStatus) {
    WindAgeRestrictedStatusUnknow = 0,
    WindAgeRestrictedStatusYES,
    WindAgeRestrictedStatusNO,
};

@interface WindAdOptions : NSObject
/// Sigmob平台申请的appId
@property (copy, nonatomic, readonly) NSString* appId;
/// Sigmob平台申请的appKey
@property (copy, nonatomic, readonly) NSString* appKey;
- (instancetype)initWithAppId:(NSString *)appId appKey:(NSString *)appKey;
@end

typedef void(^WindAdDebugCallBack)(NSString *msg, int level);
@interface WindAds : NSObject
+ (NSString *)sdkVersion;
+ (void)startWithOptions:(WindAdOptions *)options;
+ (WindConsentStatus)getUserGDPRConsentStatus;
+ (void)setUserGDPRConsentStatus:(WindConsentStatus)status;
+ (WindAgeRestrictedStatus)getAgeRestrictedStatus;
+ (void)setIsAgeRestrictedUser:(WindAgeRestrictedStatus)status;
+ (NSUInteger)getUserAge;
+ (void)setUserAge:(NSUInteger)age;
+ (void)setDebugEnable:(BOOL)enable;

#pragma mark - CCPA SUPPORT
+ (void)updateCCPAStatus:(WindCCPAStatus)status;
+ (WindCCPAStatus)getCCPAStatus;

@end



@interface WindAdRequest : NSObject
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *placementId;
//做为扩展参数使用
@property (nonatomic,strong) NSDictionary<NSString *, NSString *> *options;
+ (instancetype)request;

@end



#endif /* OMSigMobClass_h */
