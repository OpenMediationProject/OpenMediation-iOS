// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceAdapter.h"

@implementation OMIronSourceAdapter

+ (NSString *)adapterVerison{
    return IronSourceAdapterVersion;
}

+ (NSString*)adNetworkVersion {
    NSString *sdkVersion = @"";
    Class sdkClass = NSClassFromString(@"IronSource");
    if (sdkClass && [sdkClass respondsToSelector:@selector(sdkVersion)]) {
        sdkVersion = [sdkClass sdkVersion];
    }
    return sdkVersion;
}

+ (NSString*)minimumSupportVersion {
    return @"6.15.0";
}


+ (void)setConsent:(BOOL)consent {
    Class ironsourceClass = NSClassFromString(@"IronSource");
    if (ironsourceClass && [ironsourceClass respondsToSelector:@selector(setConsent:)]) {
        [ironsourceClass setConsent:consent];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class ironsourceClass = NSClassFromString(@"IronSource");
    if (ironsourceClass && [ironsourceClass respondsToSelector:@selector(setMetaDataWithKey:value:)]) {
        [ironsourceClass setMetaDataWithKey:@"do_not_sell" value:(privacyLimit?@"YES":@"NO")];
    }
}

+ (void)setUserAge:(NSInteger)userAge {
    Class ironsourceClass = NSClassFromString(@"IronSource");
    if (ironsourceClass && [ironsourceClass respondsToSelector:@selector(setAge:)]) {
        [ironsourceClass setAge:userAge];
    }
}

+ (void)setUserGender:(NSInteger)userGender {
    Class ironsourceClass = NSClassFromString(@"IronSource");
    if (ironsourceClass && [ironsourceClass respondsToSelector:@selector(setGender:)]) {
        if (userGender == 0) {
            [ironsourceClass setGender:IRONSOURCE_USER_UNKNOWN];
        }else if (userGender == 1){
            [ironsourceClass setGender:IRONSOURCE_USER_MALE];
        }else{
            [ironsourceClass setGender:IRONSOURCE_USER_FEMALE];
        }
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler{
    NSString *key = [configuration objectForKey:@"appKey"];
    Class ironsourceClass = NSClassFromString(@"IronSource");
    if (!ironsourceClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.ironsourceadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"AppLovin SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if ([[self adNetworkVersion]compare:[self minimumSupportVersion]options:NSNumericSearch] == NSOrderedAscending) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.ironsourceadapter"
                                                    code:505
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The current ad network(%@) is below the minimum required version(%@)",[self adNetworkVersion],[self minimumSupportVersion]]}];
        completionHandler(error);
        return;
    }
    
    if(ironsourceClass && [ironsourceClass respondsToSelector:@selector(initISDemandOnly:adUnits:)]){
        [ironsourceClass initISDemandOnly:key adUnits:@[IS_REWARDED_VIDEO,IS_INTERSTITIAL]];
        //[ironsourceClass initWithAppKey:key adUnits:@[IS_BANNER]]; // Banner
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.ironsourceadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
