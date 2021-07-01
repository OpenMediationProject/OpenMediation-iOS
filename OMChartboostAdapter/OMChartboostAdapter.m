// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostAdapter.h"

@interface OMChartboostAdapter()

@property (nonatomic, copy) OMMediationAdapterInitCompletionBlock initBlock;

@end

static OMChartboostAdapter * _instance = nil;


@implementation OMChartboostAdapter

+ (NSString*)adapterVerison {
    return ChartboostAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class chartboostClass = NSClassFromString(@"Chartboost");
    Class CHBGDPRDataUseConsentClass = NSClassFromString(@"CHBGDPRDataUseConsent");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(addDataUseConsent:)] && CHBGDPRDataUseConsentClass && [CHBGDPRDataUseConsentClass respondsToSelector:@selector(gdprConsent:)]) {
        [chartboostClass addDataUseConsent:(consent?[CHBGDPRDataUseConsentClass gdprConsent:CHBGDPRConsentBehavioral]:[CHBGDPRDataUseConsentClass gdprConsent:CHBGDPRConsentNonBehavioral])];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class chartboostClass = NSClassFromString(@"Chartboost");
    Class CHBCCPADataUseConsentClass = NSClassFromString(@"CHBCCPADataUseConsent");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(addDataUseConsent:)] && CHBCCPADataUseConsentClass && [CHBCCPADataUseConsentClass respondsToSelector:@selector(ccpaConsent:)]) {
        [chartboostClass addDataUseConsent:(privacyLimit?[CHBCCPADataUseConsentClass ccpaConsent:CHBCCPAConsentOptOutSale]:[CHBCCPADataUseConsentClass ccpaConsent:CHBCCPAConsentOptInSale])];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    Class chartboostClass = NSClassFromString(@"Chartboost");
    NSArray *keys = [key componentsSeparatedByString:@"#"];
    
    if (!chartboostClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.chartboostadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Chartboost SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(chartboostClass && [chartboostClass respondsToSelector:@selector(startWithAppId:appSignature:completion:)] && keys.count > 1) {
        [chartboostClass startWithAppId:keys[0]
                           appSignature:keys[1]
                             completion:^(BOOL success) {
            if (success) {
                completionHandler(nil);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.chartboostadapter"
                                                            code:401
                                                        userInfo:@{NSLocalizedDescriptionKey:@"Init failed"}];
                completionHandler(error);
            }
        }];
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.chartboostadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


+ (void)setLogEnable:(BOOL)logEnable {
    Class chartboostClass = NSClassFromString(@"Chartboost");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(setLoggingLevel:)]) {
        [chartboostClass setLoggingLevel:(logEnable?CBLoggingLevelVerbose:CBLoggingLevelOff)];
    }
}
@end
