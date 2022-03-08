// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubAdapter.h"
#import "OMMopubClass.h"

static BOOL logEnabled = NO;

@implementation OMMopubAdapter

+ (NSString*)adapterVerison {
    return MopubAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    
    Class MoPubClass = NSClassFromString(@"MoPub");
    if (consent && MoPubClass && [MoPubClass instancesRespondToSelector:@selector(grantConsent)]) {
        [[MoPubClass sharedInstance] grantConsent];
    } else if(MoPubClass && [MoPubClass instancesRespondToSelector:@selector(grantConsent)]) {
        [[MoPubClass sharedInstance] revokeConsent];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class MoPubClass = NSClassFromString(@"MoPub");
    if (privacyLimit && MoPubClass && [MoPubClass instancesRespondToSelector:@selector(canCollectPersonalInfo)]) {
        [[MoPubClass sharedInstance] canCollectPersonalInfo];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    NSArray *pids = [configuration objectForKey:@"pids"];
    Class MPConfigClass = NSClassFromString(@"MPMoPubConfiguration");
    Class MoPubClass = NSClassFromString(@"MoPub");
    
    
    if (!MoPubClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.mopubadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"MoPub SDK not found"}];
        completionHandler(error);
        return;
    }

    if ([pids count]>0 && MPConfigClass && [MPConfigClass instancesRespondToSelector:@selector(initWithAdUnitIdForAppInitialization:)] && MoPubClass && [MoPubClass instancesRespondToSelector:@selector(initializeSdkWithConfiguration:completion:)] ) {
        
        NSString *pid = pids[0];
        MPMoPubConfiguration *sdkConfig = [[MPConfigClass alloc] initWithAdUnitIdForAppInitialization:pid];
        sdkConfig.loggingLevel = (logEnabled?MPBLogLevelDebug:MPBLogLevelNone);
        [[MoPubClass sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
            completionHandler(nil);
        }];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
    
}

+ (void)setLogEnable:(BOOL)logEnable {
    logEnabled = logEnable;
}
@end
