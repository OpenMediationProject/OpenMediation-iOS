// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMGoogleAdAdapter.h"

static NSString * const AdManagerAdapterVersion = @"2.1.3";
static BOOL admobNpaAd = NO;

@implementation OMGoogleAdAdapter

+ (NSString*)adapterVerison {
    return AdManagerAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    admobNpaAd = !consent;
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    [NSUserDefaults.standardUserDefaults setBool:privacyLimit forKey:@"gad_rdp"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)setUserAgeRestricted:(BOOL)restricted {
    Class admobClass = NSClassFromString(@"GADMobileAds");
    if(admobClass && [admobClass respondsToSelector:@selector(sharedInstance)]) {
        GADMobileAds *admob = [admobClass sharedInstance];
        GADRequestConfiguration *config = [admob requestConfiguration];
        if (config && [config respondsToSelector:@selector(tagForChildDirectedTreatment:)]){
            [config tagForChildDirectedTreatment:restricted];
        }
    }
}

+ (BOOL)npaAd {
    return admobNpaAd;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    Class sdkClass = NSClassFromString(@"GADRequest");
    if (!sdkClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.admobadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"AdMob SDK not found"}];
        completionHandler(error);
        return;
    }
    
    NSString *key = [configuration objectForKey:@"appKey"];
    if([key length] == [@"ca-app-pub-8080140584266451~7053247990" length]) {//admob key 长度有限制，格式错误崩溃
        [[NSBundle mainBundle].infoDictionary setValue:key forKey:@"GADApplicationIdentifier"];
    }
    Class admobClass = NSClassFromString(@"GADMobileAds");
    if(admobClass && [admobClass respondsToSelector:@selector(sharedInstance)]) {
        GADMobileAds *ac = [admobClass sharedInstance];
        if (ac && [ac respondsToSelector:@selector(startWithCompletionHandler:)]) {
            [ac startWithCompletionHandler:^(GADInitializationStatus *status){
                completionHandler(nil);
              }];
        }
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.admobadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
