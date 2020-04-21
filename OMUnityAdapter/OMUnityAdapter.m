// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUnityAdapter.h"
#import "OMUnityRouter.h"

@implementation OMUnityAdapter

+ (NSString*)adapterVerison {
    return UnityAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    Class unityClass = NSClassFromString(@"UnityAds");
    if (unityClass && [unityClass respondsToSelector:@selector(initialize:)] && [key length]>0) {
        [unityClass initialize:key];
        completionHandler(nil);
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:1
                                                userInfo:@{NSLocalizedDescriptionKey:@"An error that indicates failure due to a failure in the initialization process."}];
        completionHandler(error);
    }

}
@end
