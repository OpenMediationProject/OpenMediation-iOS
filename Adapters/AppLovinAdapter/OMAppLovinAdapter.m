// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAppLovinAdapter.h"
static ALSdk *alShareSDK = nil;

@implementation OMAppLovinAdapter

+ (NSString*)adapterVerison {
    return AppLovinAdapterVersion;
}

+ (NSString*)adNetworkVersion {
    NSString *sdkVersion = @"";
    Class sdkClass = NSClassFromString(@"ALSdk");
    if (sdkClass && [sdkClass respondsToSelector:@selector(versionCode)]) {
        sdkVersion = [NSString stringWithFormat:@"%zd",[sdkClass versionCode]];
    }
    return sdkVersion;
}

+ (NSString*)minimumSupportVersion {
    return @"6.1.1";
}


+ (void)setConsent:(BOOL)consent {
    
    Class privacySettings = NSClassFromString(@"ALPrivacySettings");
    if (privacySettings && [privacySettings respondsToSelector:@selector(setHasUserConsent:)]) {
        [privacySettings setHasUserConsent:consent];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class privacySettings = NSClassFromString(@"ALPrivacySettings");
    if (privacySettings && [privacySettings respondsToSelector:@selector(setDoNotSell:)]) {
        [privacySettings setDoNotSell:privacyLimit];
    }
}


+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    
    
    Class applovinClass = NSClassFromString(@"ALSdk");
    if (!applovinClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.applovinadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"AppLovin SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if ([[self adNetworkVersion]compare:[self minimumSupportVersion]options:NSNumericSearch] == NSOrderedAscending) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.applovinadapter"
                                                    code:505
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The current ad network(%@) is below the minimum required version(%@)",[self adNetworkVersion],[self minimumSupportVersion]]}];
        completionHandler(error);
        return;
    }
    
    if(applovinClass && [applovinClass respondsToSelector:@selector(sharedWithKey:)]){
        alShareSDK = [applovinClass sharedWithKey:key];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.applovinadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (ALSdk*)alShareSdk{
    return alShareSDK;
}

+ (UIWindow *)currentWindow{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}
@end
