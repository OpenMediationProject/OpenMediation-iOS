// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingClass_h
#define OMAdTimingClass_h

typedef NS_ENUM(NSInteger, AdTimingAdType) {
    AdTimingAdTypeBanner = (1 << 0),
    AdTimingAdTypeNative = (1 << 1),
    AdTimingAdTypeRewardedVideo = (1 << 2),
    AdTimingAdTypeInteractive = (1 << 3),
    AdTimingAdTypeInterstitial = (1 << 4),
};

@interface AdTiming : NSObject
+ (NSString *)SDKVersion;
+ (void)initWithAppKey:(NSString *)appKey adType:(AdTimingAdType)initAdTypes;
+ (NSString*)bidderToken;
+ (void)setGDPRConsent:(BOOL)consent;
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;
+ (void)setUserAge:(NSInteger)userAge;
+ (void)setUserGender:(NSInteger)userGender;
@end

#endif /* OMAdTimingClass_h */
