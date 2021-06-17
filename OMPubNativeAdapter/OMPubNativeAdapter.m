// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPubNativeAdapter.h"

@implementation OMPubNativeAdapter

+ (NSString *)adapterVerison{
    return PubNativeAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler{
    NSString *key = [configuration objectForKey:@"appKey"];
    Class hyBidClass = NSClassFromString(@"HyBid");
    if (!hyBidClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pubnativeadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"PubNative SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if (hyBidClass && [hyBidClass respondsToSelector:@selector(initWithAppToken:completion:)]) {
        [hyBidClass initWithAppToken:key completion:^(BOOL success) {
            if (success) {
                completionHandler(nil);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pubnativeadapter"
                                                            code:-1
                                                        userInfo:@{NSLocalizedDescriptionKey:@"HyBid init failed"}];
                completionHandler(error);
            }
        }];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pubnativeadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
