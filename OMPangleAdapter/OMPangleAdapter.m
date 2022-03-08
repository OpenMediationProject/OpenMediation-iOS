// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleAdapter.h"

static BOOL _internalAPI = NO;

@implementation OMPangleAdapter

+ (NSString*)adapterVerison {
    return PangleAdapterVersion;
}

+ (BOOL)internalAPI {
    return _internalAPI;
}

+ (void)setInternalAPI:(BOOL)internalAPI {
    _internalAPI = internalAPI;
}

+ (void)setConsent:(BOOL)consent {
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (buadClass && [buadClass respondsToSelector:@selector(setGDPR:)]) {
        [buadClass setGDPR:(consent?1:0)];
    }
}

+(void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (buadClass && [buadClass respondsToSelector:@selector(setCCPA:)]) {
        [buadClass setCCPA:(privacyLimit?1:0)];
    }
}

+(void)setUserAgeRestricted:(BOOL)restricted {
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (buadClass && [buadClass respondsToSelector:@selector(setCoppa:)]) {
        [buadClass setCoppa:(restricted?1:0)];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    NSString *key = [configuration objectForKey:@"appKey"];
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (!buadClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pangleadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Pangle SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(buadClass && [buadClass respondsToSelector:@selector(setAppID:)] && [buadClass respondsToSelector:@selector(setTerritory:)]) {
        if ([OMPangleAdapter internalAPI]) {
            [buadClass setTerritory:BUAdSDKTerritory_CN];
        }else{
            [buadClass setTerritory:BUAdSDKTerritory_NO_CN];
        }
        [buadClass setAppID:key];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pangleadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (buadClass && [buadClass respondsToSelector:@selector(setLoglevel:)]) {
        [buadClass setLoglevel:(logEnable?BUAdSDKLogLevelVerbose:BUAdSDKLogLevelNone)];
    }
}


@end
