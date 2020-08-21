// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingAdapter.h"
#import "OMAdTimingClass.h"

@implementation OMAdTimingAdapter

+ (NSString *)adapterVerison {
    return AdTimingAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    Class adtimingClass = NSClassFromString(@"AdTiming");
    if (adtimingClass && [adtimingClass respondsToSelector:@selector(initWithAppKey:)]) {
        [adtimingClass initWithAppKey:key];
        completionHandler(nil);
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation" code:400 userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (void)setConsent:(BOOL)consent {
    Class adtimingClass = NSClassFromString(@"AdTiming");
    if (adtimingClass && [adtimingClass respondsToSelector:@selector(setGDPRConsent:)]) {
        [adtimingClass setGDPRConsent:consent];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class adtimingClass = NSClassFromString(@"AdTiming");
    if (adtimingClass && [adtimingClass respondsToSelector:@selector(setUSPrivacyLimit:)]) {
        [adtimingClass setUSPrivacyLimit:privacyLimit];
    }
}

+ (void)setUserAge:(NSInteger)userAge {
    Class adtimingClass = NSClassFromString(@"AdTiming");
    if (adtimingClass && [adtimingClass respondsToSelector:@selector(setUserAge:)]) {
        [adtimingClass setUserAge:userAge];
    }
}

+ (void)setUserGender:(NSInteger)userGender {
    Class adtimingClass = NSClassFromString(@"AdTiming");
    if (adtimingClass && [adtimingClass respondsToSelector:@selector(setUserGender:)]) {
        [adtimingClass setUserGender:userGender];
    }
}

@end
