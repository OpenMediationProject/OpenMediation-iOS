// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHeliumAdapter.h"


static OMHeliumAdapter * _instance = nil;

@implementation OMHeliumAdapter

+ (NSString*)adapterVerison {
    return HeliumAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class heliumClass = NSClassFromString(@"Helium");
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(setSubjectToGDPR:)]) {
        [[heliumClass sharedHelium]setSubjectToGDPR:YES];
    }
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(setUserHasGivenConsent:)]) {
        [[heliumClass sharedHelium]setUserHasGivenConsent:consent];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class heliumClass = NSClassFromString(@"Helium");
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(setCCPAConsent:)]) {
        [[heliumClass sharedHelium]setCCPAConsent:!privacyLimit];
    }
}

+(void)setUserAgeRestricted:(BOOL)restricted {
    Class heliumClass = NSClassFromString(@"Helium");
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(setSubjectToCoppa:)]) {
        [[heliumClass sharedHelium] setSubjectToCoppa:restricted];
    }
}


+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    NSString *key = [configuration objectForKey:@"appKey"];
    Class heliumClass = NSClassFromString(@"Helium");
    NSArray *keys = [key componentsSeparatedByString:@"#"];
    if (heliumClass && [heliumClass instancesRespondToSelector:@selector(startWithAppId:andAppSignature:options:delegate:)] && keys.count > 1) {
        [OMHeliumAdapter sharedInstance].initBlock = completionHandler;
        [[heliumClass sharedHelium] startWithAppId:keys[0]
                                      andAppSignature:keys[1]
                                           options:nil
                                          delegate:[OMHeliumAdapter sharedInstance]];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.heliumadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}


- (void)heliumDidStartWithError:(ChartboostMediationError *)error {
    if (self.initBlock) {
        self.initBlock(error?[NSError errorWithDomain:@"om.mediation.heliumadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:@"The helium sdk init failed"}]:nil);
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
