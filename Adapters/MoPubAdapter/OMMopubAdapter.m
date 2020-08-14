// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubAdapter.h"
#import "OMMopubClass.h"

@implementation OMMopubAdapter

+ (NSString*)adapterVerison {
    return MopubAdapterVersion;
}


+ (NSString*)adNetworkVersion {
    NSString *sdkVersion = @"";
    Class sdkClass = NSClassFromString(@"MoPub");
    if (sdkClass && [sdkClass respondsToSelector:@selector(sharedInstance)]) {
        MoPub *mopub = [sdkClass sharedInstance];
        if ([mopub respondsToSelector:@selector(version)]) {
            sdkVersion = [mopub version];
        }
    }
    return sdkVersion;
}

+ (NSString*)minimumSupportVersion {
    return @"5.5.0";
}

+ (void)setConsent:(BOOL)consent {
    
    Class MoPubClass = NSClassFromString(@"MoPub");
    if (consent && MoPubClass && [MoPubClass instancesRespondToSelector:@selector(grantConsent)]) {
        [[MoPubClass sharedInstance] grantConsent];
    } else if(MoPubClass && [MoPubClass instancesRespondToSelector:@selector(grantConsent)]) {
        [[MoPubClass sharedInstance] revokeConsent];
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
    
    if ([[self adNetworkVersion]compare:[self minimumSupportVersion]options:NSNumericSearch] == NSOrderedAscending) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.mopubadapter"
                                                    code:505
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The current ad network(%@) is below the minimum required version(%@)",[self adNetworkVersion],[self minimumSupportVersion]]}];
        completionHandler(error);
        return;
    }
    
    
    if ([pids count]>0 && MPConfigClass && [MPConfigClass instancesRespondToSelector:@selector(initWithAdUnitIdForAppInitialization:)] && MoPubClass && [MoPubClass instancesRespondToSelector:@selector(initializeSdkWithConfiguration:completion:)] ) {
        
        NSString *pid = pids[0];
        MPMoPubConfiguration *sdkConfig = [[MPConfigClass alloc] initWithAdUnitIdForAppInitialization:pid];
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

@end
