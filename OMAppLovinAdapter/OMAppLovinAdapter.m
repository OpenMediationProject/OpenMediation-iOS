// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAppLovinAdapter.h"
static ALSdk *alShareSDK = nil;

@implementation OMAppLovinAdapter

+ (NSString*)adapterVerison {
    return AppLovinAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    
    
    Class applovinClass = NSClassFromString(@"ALSdk");
    if (applovinClass && [applovinClass respondsToSelector:@selector(sharedWithKey:)]) {
        alShareSDK = [applovinClass sharedWithKey:key];
        completionHandler(nil);
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (ALSdk*)alShareSdk {
    return alShareSDK;
}

+ (UIWindow *)currentWindow {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}
@end
