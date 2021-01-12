// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMSigMobClass_h
#define OMSigMobClass_h

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
@property (copy, nonatomic) NSString* appId;
@property (copy, nonatomic) NSString* apiKey;
+ (instancetype)options;
@end

@interface WindAds : NSObject
@property (nonatomic,strong) WindAdOptions *adOptions;
+ (instancetype)sharedAds;
+ (NSString *)sdkVersion;
+ (void)startWithOptions:(WindAdOptions *)options;
+ (WindConsentStatus)getUserGDPRConsentStatus;
+ (void)setUserGDPRConsentStatus:(WindConsentStatus)status;
+ (WindAgeRestrictedStatus)getAgeRestrictedStatus;
+ (void)setIsAgeRestrictedUser:(WindAgeRestrictedStatus)status;
+ (NSUInteger)getUserAge;
+ (void)setUserAge:(NSUInteger)age;
@end

@interface WindAdRequest : NSObject
+ (instancetype)request;
@end



#endif /* OMSigMobClass_h */
