//
//  OMChartboostBidAdapter.m
//  AdTimingHeliumAdapter
//
//  Created by ylm on 2020/6/17.
//  Copyright © 2020 AdTiming. All rights reserved.
//

#import "OMChartboostBidAdapter.h"


static OMChartboostBidAdapter * _instance = nil;

@implementation OMChartboostBidAdapter

+ (NSString*)adapterVerison {
    return HeliumAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class heliumClass = NSClassFromString(@"HeliumSdk");
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(setSubjectToGDPR:)]) {
        [[heliumClass sharedHelium]setSubjectToGDPR:YES];
    }
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(setUserHasGivenConsent:)]) {
        [[heliumClass sharedHelium]setUserHasGivenConsent:consent];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class heliumClass = NSClassFromString(@"HeliumSdk");
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(setCCPAConsent:)]) {
        [[heliumClass sharedHelium]setCCPAConsent:!privacyLimit];
    }
}


+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    NSString *key = [configuration objectForKey:@"appKey"];
    Class heliumClass = NSClassFromString(@"HeliumSdk");
    NSArray *keys = [key componentsSeparatedByString:@"#"];
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(startWithAppId:andAppSignature:delegate:)] && keys.count > 1) {
        [OMChartboostBidAdapter sharedInstance].initBlock = completionHandler;
        [[heliumClass sharedHelium] startWithAppId:keys[0]
                                      andAppSignature:keys[1] delegate:[OMChartboostBidAdapter sharedInstance]];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.heliumadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}


- (void)heliumDidStartWithError:(HeliumError *)error {
    if (self.initBlock) {
        self.initBlock(error?[NSError errorWithDomain:@"om.mediation.heliumadapter" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}]:nil);
        self.initBlock = nil;
    }
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


@end
