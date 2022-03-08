// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookAdapter.h"
#import "OMFacebookClass.h"
#import <AppTrackingTransparency/ATTrackingManager.h>

@implementation OMFacebookAdapter
+ (NSString*)adapterVerison {
    return FacebookAdapterVersion;
}

// doc :https://developers.facebook.com/docs/audience-network/support/faq/ccpa
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class facebookClass = NSClassFromString(@"FBAdSettings");
    if (facebookClass && [facebookClass respondsToSelector:@selector(setDataProcessingOptions:country:state:)] && [facebookClass respondsToSelector:@selector(setDataProcessingOptions:)]) {
        if (privacyLimit) {
            [facebookClass setDataProcessingOptions:@[@"LDU"] country:1 state:1000];
        }else{
            [facebookClass setDataProcessingOptions:@[]];
        }
    }
}

+(void)setUserAgeRestricted:(BOOL)restricted {
    Class facebookClass = NSClassFromString(@"FBAdSettings");
    if(facebookClass && [facebookClass respondsToSelector:@selector(setMixedAudience:)]) {
        [facebookClass setMixedAudience:restricted];
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class fbSetting = NSClassFromString(@"FBAdSettings");
    if (fbSetting && [fbSetting respondsToSelector:@selector(setLogLevel:)]) {
        [fbSetting setLogLevel:(logEnable?FBAdLogLevelVerbose:FBAdLogLevelNone)];
    }
}


+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    Class initSetting = NSClassFromString(@"FBAdInitSettings");
    NSArray *pids = configuration[@"pids"];
    if (initSetting && [initSetting instancesRespondToSelector:@selector(initWithPlacementIDs:mediationService:)]) {
        FBAdInitSettings *fbSettings = [[initSetting alloc]
                                        initWithPlacementIDs:pids
                                        mediationService:@"OpenMediation"];
        Class fbAds = NSClassFromString(@"FBAudienceNetworkAds");
        
        [fbAds
         initializeWithSettings:fbSettings
         completionHandler:^(FBAdInitResults *results) {
             if (results.success) {
                 completionHandler(nil);
             } else {
                 NSError *error =
                 [NSError errorWithDomain:@"com.om.fbadapter"
                                     code:0
                                 userInfo:@{NSLocalizedDescriptionKey : results.message}];
                 completionHandler(error);
             }
         }];
    } else {
        
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.fbadapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }    
}

@end
