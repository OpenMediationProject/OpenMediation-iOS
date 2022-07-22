// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleAdapter.h"
#import "OMVungleRouter.h"

@implementation OMVungleAdapter

+ (NSString*)adapterVerison {
    return VungleAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)]) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        if (vungle && [vungle respondsToSelector:@selector(updateConsentStatus:consentMessageVersion:)]) {
            [vungle updateConsentStatus:(consent?VungleConsentAccepted:VungleConsentDenied) consentMessageVersion:@"6.7.0"];
        }
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)]) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        if (vungle && [vungle respondsToSelector:@selector(updateCCPAStatus:)]) {
            [vungle updateCCPAStatus:(privacyLimit?VungleCCPAAccepted:VungleCCPADenied)];
        }
    }
}

+ (void)setUserAgeRestricted:(BOOL)restricted {
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)]) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        if (vungle && [vungle respondsToSelector:@selector(updateCOPPAStatus:)]) {
            [vungle updateCOPPAStatus:(restricted?YES:NO)];
        }
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (!vungleClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.vungleadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Vungle SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)] && [key length]>0) {
        VungleSDK *vungle = [vungleClass sharedSDK];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL setPluginNameSelecotr = @selector(setPluginName:version:);
        if ([vungle respondsToSelector:setPluginNameSelecotr]) {
            [vungle performSelector: setPluginNameSelecotr
                                                    withObject: @"vunglehbs"
                                                    withObject: @"1.0.0"];

        }
#pragma clang diagnostic pop
        if(vungle && [vungle respondsToSelector:@selector(startWithAppId:error:)]) {
            NSError *error = nil;
            BOOL start = [vungle startWithAppId:key error:&error];
            vungle.delegate = [OMVungleRouter sharedInstance];
            if(start) {
                completionHandler(nil);
            }else{
                completionHandler(error);
            }
        }
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.vungleadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key."}];
        completionHandler(error);
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)] && [vungleClass instancesRespondToSelector:@selector(setLoggingEnabled:)]) {
        [[vungleClass sharedSDK] setLoggingEnabled:logEnable];
    }
}

@end
