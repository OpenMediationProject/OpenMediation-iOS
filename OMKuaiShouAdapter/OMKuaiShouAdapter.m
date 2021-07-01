// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMKuaiShouAdapter.h"

@implementation OMKuaiShouAdapter

+ (NSString*)adapterVerison {
    return KSAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    Class ksClass = NSClassFromString(@"KSAdSDKManager");
    if (!ksClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.ksadadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"KsAd SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(ksClass && [ksClass respondsToSelector:@selector(setAppId:)]) {
        [ksClass setAppId:key];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.ksadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class ksClass = NSClassFromString(@"KSAdSDKManager");
    if (ksClass && [ksClass respondsToSelector:@selector(setLoglevel:)]) {
        [ksClass setLoglevel:(logEnable?KSAdSDKLogLevelAll:KSAdSDKLogLevelOff)];
    }
}
@end
