// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSigMobAdapter.h"

@implementation OMSigMobAdapter

+ (NSString*)adapterVerison {
    return SigMobAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class sigmobClass = NSClassFromString(@"WindAds");
    if (sigmobClass && [[sigmobClass sharedAds] respondsToSelector:@selector(setUserGDPRConsentStatus:)]) {
        [[sigmobClass sharedAds] setUserGDPRConsentStatus:consent?WindConsentAccepted:WindConsentDenied];
    }
}

+ (void)setUserAge:(NSInteger)userAge {
    Class sigmobClass = NSClassFromString(@"WindAds");
    if (sigmobClass && [[sigmobClass sharedAds] respondsToSelector:@selector(setUserAge:)]) {
        [[sigmobClass sharedAds] setUserAge:userAge];
    }
}


+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    NSString *key = [configuration objectForKey:@"appKey"];
    Class windClass = NSClassFromString(@"WindAds");
    Class optionsClass = NSClassFromString(@"WindAdOptions");
    if (!windClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.sigmobadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"SigMob SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(optionsClass && [optionsClass respondsToSelector:@selector(options)] && windClass && [windClass respondsToSelector:@selector(startWithOptions:)]) {
        id options = [optionsClass options];
        WindAdOptions *option = options;
        option.appId = key;
        [windClass startWithOptions:option];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.sigmobadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
