// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceAdapter.h"

static NSString * const IronSourceAdapterVersion = @"2.0.3";
static BOOL _mediationAPI = NO;

@implementation OMIronSourceAdapter

+ (NSString *)adapterVerison{
    return IronSourceAdapterVersion;
}

+ (BOOL)mediationAPI {
    return _mediationAPI;
}

+ (void)setMediationAPI:(BOOL)mediationAPI {
    _mediationAPI = mediationAPI;
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
        }else if (userGender == 1) {
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
                                                userInfo:@{NSLocalizedDescriptionKey:@"IronSource SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(ironsourceClass && [ironsourceClass respondsToSelector:@selector(initISDemandOnly:adUnits:)]) {
        if ([OMIronSourceAdapter mediationAPI]) {
            [ironsourceClass initWithAppKey:key adUnits:@[IS_BANNER,IS_REWARDED_VIDEO,IS_INTERSTITIAL]];
        } else {
            [ironsourceClass initISDemandOnly:key adUnits:@[IS_REWARDED_VIDEO,IS_INTERSTITIAL]];
        }
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.ironsourceadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
