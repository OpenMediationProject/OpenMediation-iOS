// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTikTokAdapter.h"

@implementation OMTikTokAdapter
+ (NSString*)adapterVerison {
    return TikTokAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {

    NSString *key = [configuration objectForKey:@"appKey"];
    Class TikTokClass = NSClassFromString(@"BUAdSDKManager");
    if (TikTokClass && [TikTokClass respondsToSelector:@selector(setAppID:)]) {
        [TikTokClass setAppID:key];
        completionHandler(nil);
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}
@end
