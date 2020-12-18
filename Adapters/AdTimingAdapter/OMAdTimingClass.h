// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingClass_h
#define OMAdTimingClass_h

typedef NS_ENUM(NSInteger, AdTimingBidAdType) {
    AdTimingBidAdTypeBanner = (1 << 0),
    AdTimingBidAdTypeNative = (1 << 1),
    AdTimingBidAdTypeRewardedVideo = (1 << 2),
    AdTimingBidAdTypeInterstitial = (1 << 4),
};


@interface AdTimingBid : NSObject
+ (NSString *)SDKVersion;
+ (void)initWithAppKey:(NSString*)appKey;
+ (NSString*)bidderToken;
+ (void)setGDPRConsent:(BOOL)consent;
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;
+ (void)setUserAge:(NSInteger)userAge;
+ (void)setUserGender:(NSInteger)userGender;
@end

#endif /* OMAdTimingClass_h */
