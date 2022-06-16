// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSigMobAdapter.h"

@implementation OMSigMobAdapter

+ (NSString*)adapterVerison {
    return SigMobAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class sigmobClass = NSClassFromString(@"WindAds");
    if (sigmobClass && [sigmobClass respondsToSelector:@selector(setUserGDPRConsentStatus:)]) {
        [sigmobClass setUserGDPRConsentStatus:consent?WindConsentAccepted:WindConsentDenied];
    }
}

+(void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class sigmobClass = NSClassFromString(@"WindAds");
    if (sigmobClass && [sigmobClass respondsToSelector:@selector(updateCCPAStatus:)]) {
        [sigmobClass updateCCPAStatus:privacyLimit?WindCCPAAccepted:WindCCPADenied];
    }
}

+ (void)setUserAgeRestricted:(BOOL)restricted {
    Class sigmobClass = NSClassFromString(@"WindAds");
    if (sigmobClass && [sigmobClass respondsToSelector:@selector(setIsAgeRestrictedUser:)]) {
        [sigmobClass setIsAgeRestrictedUser:restricted?WindAgeRestrictedStatusYES:WindAgeRestrictedStatusNO];
    }
}

+ (void)setUserAge:(NSInteger)userAge {
    Class sigmobClass = NSClassFromString(@"WindAds");
    if (sigmobClass && [sigmobClass respondsToSelector:@selector(setUserAge:)]) {
        [sigmobClass setUserAge:userAge];
    }
}


+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    NSArray *keys = [key componentsSeparatedByString:@"#"];
    Class windClass = NSClassFromString(@"WindAds");
    Class optionsClass = NSClassFromString(@"WindAdOptions");
    if (!windClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.sigmobadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"SigMob SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(optionsClass && [optionsClass instancesRespondToSelector:@selector(initWithAppId:appKey:)] && windClass && [windClass respondsToSelector:@selector(startWithOptions:)]) {
        WindAdOptions *option = [[optionsClass alloc] initWithAppId:keys[0] appKey:keys[1]];
        [windClass startWithOptions:option];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.sigmobadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class windClass = NSClassFromString(@"WindAds");
    if (windClass && [windClass respondsToSelector:@selector(setDebugEnable:)]) {
        [windClass setDebugEnable:logEnable];
    }
}


@end
