// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMobAdapter.h"
#import "OMAdMobClass.h"

static NSString * const AdmobAdapterVersion = @"3.1.1";
static BOOL admobNpaAd = NO;

@implementation OMAdMobAdapter

+ (NSString*)adapterVerison {
    return AdmobAdapterVersion;
}

+ (NSString*)adNetworkVersion {
    NSString *sdkVersion = @"";
    Class admobClass = NSClassFromString(@"GADMobileAds");
    if (admobClass && [admobClass respondsToSelector:@selector(sharedInstance)]) {
        GADMobileAds *admob = [admobClass sharedInstance];
        if(admob && [admob respondsToSelector:@selector(sdkVersion)]){
            sdkVersion = [admob sdkVersion];
        }
    }
    return sdkVersion;
}

+ (NSString*)minimumSupportVersion {
    return @"afma-sdk-i-v7.42.0";
}


+ (void)setConsent:(BOOL)consent {
    admobNpaAd = !consent;
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    admobNpaAd = privacyLimit;
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
    
    if ([[self adNetworkVersion]compare:[self minimumSupportVersion]options:NSNumericSearch] == NSOrderedAscending) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.admobadapter"
                                                    code:505
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The current ad network(%@) is below the minimum required version(%@)",[self adNetworkVersion],[self minimumSupportVersion]]}];
        completionHandler(error);
        return;
    }
    
    NSString *key = [configuration objectForKey:@"appKey"];
    if([key length] == [@"ca-app-pub-8080140584266451~7053247990" length]){//admob key 长度有限制，格式错误崩溃
        [[NSBundle mainBundle].infoDictionary setValue:key forKey:@"GADApplicationIdentifier"];
    }
    Class admobClass = NSClassFromString(@"GADMobileAds");
    if(admobClass && [admobClass respondsToSelector:@selector(sharedInstance)]){
        GADMobileAds *ac = [admobClass sharedInstance];
        if (ac && [ac respondsToSelector:@selector(startWithCompletionHandler:)]) {
            [ac startWithCompletionHandler:nil];
            completionHandler(nil);
        }
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.admobadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
