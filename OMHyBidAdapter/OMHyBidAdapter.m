// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHyBidAdapter.h"

@implementation OMHyBidAdapter

+ (NSString *)adapterVerison{
    return HyBidAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler{
    NSString *key = [configuration objectForKey:@"appKey"];
    Class hyBidClass = NSClassFromString(@"HyBid");
    if (!hyBidClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.hyBidadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"HyBid SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if (hyBidClass && [hyBidClass respondsToSelector:@selector(initWithAppToken:completion:)]) {
        [hyBidClass initWithAppToken:key completion:^(BOOL success) {
            if (success) {
                completionHandler(nil);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.hyBidadapter"
                                                            code:-1
                                                        userInfo:@{NSLocalizedDescriptionKey:@"HyBid init failed"}];
                completionHandler(error);
            }
        }];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.hyBidadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
