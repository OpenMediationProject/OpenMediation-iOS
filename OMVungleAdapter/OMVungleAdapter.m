// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleAdapter.h"

@implementation OMVungleAdapter

+ (NSString*)adapterVerison {
    return VungleAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class vungleSettingsClass = NSClassFromString(@"_TtC12VungleAdsSDK21VunglePrivacySettings");
    if (vungleSettingsClass && [vungleSettingsClass respondsToSelector:@selector(setGDPRStatus:)]) {
        id settings = [[vungleSettingsClass alloc] init];
        [settings setGDPRStatus:consent?ConsentStatusAccepted:ConsentStatusDenied];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class vungleSettingsClass = NSClassFromString(@"_TtC12VungleAdsSDK21VunglePrivacySettings");
    if (vungleSettingsClass && [vungleSettingsClass respondsToSelector:@selector(setCCPAStatus:)]) {
        id settings = [[vungleSettingsClass alloc] init];
        [settings setCCPAStatus:privacyLimit?YES:NO];
    }
}

+ (void)setUserAgeRestricted:(BOOL)restricted {
    Class vungleSettingsClass = NSClassFromString(@"_TtC12VungleAdsSDK21VunglePrivacySettings");
    if (vungleSettingsClass && [vungleSettingsClass respondsToSelector:@selector(setCOPPAStatus:)]) {
        id settings = [[vungleSettingsClass alloc] init];
        [settings setCOPPAStatus:restricted?YES:NO];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    
    Class vungleClass = NSClassFromString(@"_TtC12VungleAdsSDK9VungleAds");
    if (!vungleClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.vungleadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Vungle SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(vungleClass && [vungleClass respondsToSelector:@selector(initWithAppId:completion:)]) {
        [vungleClass initWithAppId:key completion:^(NSError * _Nullable error) {
            if(!error) {
                completionHandler(nil);
            }else{
                completionHandler(error);
            }
        }];
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.vungleadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key."}];
        completionHandler(error);
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    
}

@end
