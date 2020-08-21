// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingClass_h
#define OMAdTimingClass_h

@interface AdTiming : NSObject
+ (NSString *)SDKVersion;
+ (void)initWithAppKey:(NSString*)appKey;
+ (NSString*)bidderToken;
+ (void)setGDPRConsent:(BOOL)consent;
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;
+ (void)setUserAge:(NSInteger)userAge;
+ (void)setUserGender:(NSInteger)userGender;
@end

#endif /* OMAdTimingClass_h */
