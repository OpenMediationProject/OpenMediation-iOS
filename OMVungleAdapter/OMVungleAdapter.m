// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleAdapter.h"
#import "OMVungleRouter.h"

@implementation OMVungleAdapter

+ (NSString*)adapterVerison {
    return VungleAdapterVersion;
}

+ (NSString*)adNetworkVersion {
    NSString *sdkVersion = @"";
    Class sdkClass = NSClassFromString(@"VungleSDK");
    if (sdkClass && [sdkClass respondsToSelector:@selector(sharedSDK)]) {
        VungleSDK *vungle = [sdkClass sharedSDK];
        if (vungle && [vungle respondsToSelector:@selector(debugInfo)]) {
            NSDictionary *dic = [vungle debugInfo];
            if (dic[@"version"]) {
                sdkVersion = dic[@"version"];
            }
        }
    }
    return sdkVersion;
}

+ (NSString*)minimumSupportVersion {
    return @"6.3.2";
}

+ (void)setConsent:(BOOL)consent {
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)]) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        if (vungle && [vungle respondsToSelector:@selector(updateConsentStatus:)]) {
            [vungle updateConsentStatus:(consent?VungleConsentAccepted:VungleConsentDenied)];
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
    
    if ([[self adNetworkVersion]compare:[self minimumSupportVersion]options:NSNumericSearch] == NSOrderedAscending) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.vungleadapter"
                                                    code:505
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The current ad network(%@) is below the minimum required version(%@)",[self adNetworkVersion],[self minimumSupportVersion]]}];
        completionHandler(error);
        return;
    }
    
    if(vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)] && [key length]>0){
        VungleSDK *vungle = [vungleClass sharedSDK];
        if(vungle && [vungle respondsToSelector:@selector(startWithAppId:error:)]){
            NSError *error = nil;
            BOOL start = [vungle startWithAppId:key error:&error];
            vungle.delegate = [OMVungleRouter sharedInstance];
            if(start){
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
@end
