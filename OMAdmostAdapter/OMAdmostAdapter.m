// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdmostAdapter.h"

@implementation OMAdmostAdapter

+ (NSString *)adapterVerison{
    return AdmostAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class admostClass = NSClassFromString(@"AMRSDK");
    if (admostClass && [admostClass respondsToSelector:@selector(subjectToGDPR:)]) {
        [admostClass subjectToGDPR:YES];
    }
    if (admostClass && [admostClass respondsToSelector:@selector(setUserConsent:)]) {
        [admostClass setUserConsent:consent];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class admostClass = NSClassFromString(@"AMRSDK");
    if (admostClass && [admostClass respondsToSelector:@selector(subjectToCCPA:)]) {
        [admostClass subjectToCCPA:YES];
    }
    if (admostClass && [admostClass respondsToSelector:@selector(setUserConsent:)]) {
        [admostClass setUserConsent:!privacyLimit];
    }
}

+ (void)setUserAgeRestricted:(BOOL)restricted {
    Class admostClass = NSClassFromString(@"AMRSDK");
    if (admostClass && [admostClass respondsToSelector:@selector(setUserChild:)]) {
        [admostClass setUserChild:restricted];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler{
    NSString *key = [configuration objectForKey:@"appKey"];
    Class admostClass = NSClassFromString(@"AMRSDK");
    if (!admostClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.admobadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Admost SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if (admostClass && [admostClass respondsToSelector:@selector(startWithAppId: completion:)]) {
        [admostClass startWithAppId:key completion:^(AMRError *_Nullable error) {
            if (!error) {
                completionHandler(nil);
            } else {
                NSError *initError = [[NSError alloc] initWithDomain:@"com.mediation.admostadapter"
                                                            code:error.errorCode
                                                        userInfo:@{NSLocalizedDescriptionKey:error.errorDescription?error.errorDescription:@""}];
                completionHandler(initError);
            }
        }];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.admostadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class admostClass = NSClassFromString(@"AMRSDK");
    if (admostClass && [admostClass respondsToSelector:@selector(setLogLevel:)]) {
        [admostClass setLogLevel:(logEnable?AMRLogLevelAll:AMRLogLevelSilent)];
    }
}

@end
