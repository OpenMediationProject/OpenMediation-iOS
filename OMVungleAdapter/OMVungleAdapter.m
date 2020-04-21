// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleAdapter.h"
#import "OMVungleRouter.h"

@implementation OMVungleAdapter

+ (NSString*)adapterVerison {
    return VungleAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)] && [key length]>0) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        if (vungle && [vungle respondsToSelector:@selector(startWithAppId:error:)]) {
            NSError *error = nil;
            BOOL start = [vungle startWithAppId:key error:&error];
            vungle.delegate = [OMVungleRouter sharedInstance];
            vungle.nativeAdsDelegate = [OMVungleRouter sharedInstance];
            if (start) {
                completionHandler(nil);
            } else {
                completionHandler(error);
            }
        }
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:14
                                                userInfo:@{NSLocalizedDescriptionKey:@"Vungle SDK Error SDK Not Initialized."}];
        completionHandler(error);
    }
}

@end
