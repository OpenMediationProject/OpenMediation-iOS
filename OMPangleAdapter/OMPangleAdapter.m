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

// GDPR: 0 close privacy protection, 1 open privacy protection
+ (void)setConsent:(BOOL)consent {
    if (![OMPangleAdapter internalAPI]) {
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (buadClass && [buadClass respondsToSelector:@selector(setGDPR:)]) {
        [buadClass setGDPR:(consent?1:0)];
    }
    }else{
        Class configClass = NSClassFromString(@"PAGConfig");
        if (configClass && [configClass respondsToSelector:@selector(shareConfig)]) {
            PAGConfig *config = [configClass shareConfig];
            if (config && [config respondsToSelector:@selector(setGDPRConsent:)]) {
                [config setGDPRConsent:(consent?1:0)];
            }
        }
    }
}

// pangle: 0 sale, 1 not sale
+(void)setUSPrivacyLimit:(BOOL)privacyLimit {
    if ([OMPangleAdapter internalAPI]) {
        Class buadClass = NSClassFromString(@"BUAdSDKManager");
        if (buadClass && [buadClass respondsToSelector:@selector(setCCPA:)]) {
            [buadClass setCCPA:(privacyLimit?1:0)];
        }
    }else{
        Class configClass = NSClassFromString(@"PAGConfig");
        if (configClass && [configClass respondsToSelector:@selector(shareConfig)]) {
            PAGConfig *config = [configClass shareConfig];
            if (config && [config respondsToSelector:@selector(setDoNotSell:)]) {
                [config setDoNotSell:(privacyLimit?1:0)];
            }
        }
    }
}

// Coppa: 0 adult, 1 child
+(void)setUserAgeRestricted:(BOOL)restricted {
    if ([OMPangleAdapter internalAPI]) {
        Class buadClass = NSClassFromString(@"BUAdSDKManager");
        if (buadClass && [buadClass respondsToSelector:@selector(setCoppa:)]) {
            [buadClass setCoppa:(restricted?1:0)];
        }
    }else{
        Class configClass = NSClassFromString(@"PAGConfig");
        if (configClass && [configClass respondsToSelector:@selector(shareConfig)]) {
            PAGConfig *config = [configClass shareConfig];
            if (config && [config respondsToSelector:@selector(setChildDirected:)]) {
                [config setChildDirected:(restricted?1:0)];
            }
            
        }
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
        
    }else{
        if ([OMPangleAdapter internalAPI]) {
            [buadClass setTerritory:BUAdSDKTerritory_CN];
            [buadClass setAppID:key];
            [buadClass startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
                if (error) {
                    NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pangleadapter"
                                                                code:400
                                                            userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
                    completionHandler(error);
                }else{
                    completionHandler(nil);
                }
            }];
            
        }else{
            [buadClass setTerritory:BUAdSDKTerritory_NO_CN];
            Class configClass = NSClassFromString(@"PAGConfig");
            Class sdkClass = NSClassFromString(@"PAGSdk");
            if (configClass && [configClass respondsToSelector:@selector(shareConfig)] && sdkClass && [sdkClass respondsToSelector:@selector(startWithConfig:completionHandler:)]) {
                PAGConfig *config = [configClass shareConfig];
                config.appID = key;
                [sdkClass startWithConfig:config completionHandler:^(BOOL success, NSError * _Nonnull error) {
                    if (success) {
                        completionHandler(nil);
                    }else{
                        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pangleadapter"
                                                                    code:400
                                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
                        completionHandler(error);
                    }
                }];
            }
        }
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (buadClass && [buadClass respondsToSelector:@selector(setLoglevel:)]) {
        [buadClass setLoglevel:(logEnable?BUAdSDKLogLevelVerbose:BUAdSDKLogLevelNone)];
    }
}


@end
