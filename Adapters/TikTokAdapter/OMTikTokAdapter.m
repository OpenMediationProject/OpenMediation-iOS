// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTikTokAdapter.h"

@implementation OMTikTokAdapter

+ (NSString*)adapterVerison {
    return TikTokAdapterVersion;
}

+ (NSString*)adNetworkVersion {
    NSString *sdkVersion = @"";
    Class sdkClass = NSClassFromString(@"BUAdSDKManager");
    if (sdkClass && [sdkClass respondsToSelector:@selector(SDKVersion)]) {
        sdkVersion = [sdkClass SDKVersion];
    }
    return sdkVersion;
}

+ (NSString*)minimumSupportVersion {
    return @"1.9.8";
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
    
    if ([[self adNetworkVersion]compare:[self minimumSupportVersion]options:NSNumericSearch] == NSOrderedAscending) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pangleadapter"
                                                    code:505
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The current ad network(%@) is below the minimum required version(%@)",[self adNetworkVersion],[self minimumSupportVersion]]}];
        completionHandler(error);
        return;
    }
    
    if(buadClass && [buadClass respondsToSelector:@selector(setAppID:)]){
        [buadClass setAppID:key];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pangleadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
