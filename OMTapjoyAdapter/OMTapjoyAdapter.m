// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTapjoyAdapter.h"

static OMTapjoyAdapter * _instance = nil;

@implementation OMTapjoyAdapter

+ (NSString*)adapterVerison {
    return TapjoyAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    id tapjoySDK;
    Class tapjoyClass = NSClassFromString(@"TJPrivacyPolicy");
    if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(sharedInstance)]) {
        tapjoySDK = [tapjoyClass sharedInstance];
    }
    if (tapjoySDK && [tapjoySDK respondsToSelector:@selector(setSubjectToGDPR:)]) {
        [tapjoySDK setSubjectToGDPR:YES];
    }
    if (tapjoySDK && [tapjoySDK respondsToSelector:@selector(setUserConsent:)]) {
        [tapjoySDK setUserConsent:(consent?@"1":@"0")];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    id tapjoySDK;
    Class tapjoyClass = NSClassFromString(@"TJPrivacyPolicy");
    if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(sharedInstance)]) {
        tapjoySDK = [tapjoyClass sharedInstance];
    }
    if (tapjoySDK && [tapjoySDK respondsToSelector:@selector(setUSPrivacy:)]) {
        [tapjoySDK setUSPrivacy:(privacyLimit?@"1YNY":@"1YYY")];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    [OMTapjoyAdapter sharedInstance].initBlock = completionHandler;
    NSString *key = [configuration objectForKey:@"appKey"];
    Class tapjoyClass = NSClassFromString(@"Tapjoy");
    if (!tapjoyClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.tapjoyadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Tapjoy SDK not found"}];
        completionHandler(error);
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_LIMITED_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFailed:) name:TJC_CONNECT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFailed:) name:TJC_LIMITED_CONNECT_FAILED object:nil];
    
    if(tapjoyClass && [tapjoyClass respondsToSelector:@selector(limitedConnect:)] && [key length]>0) {
        [tapjoyClass limitedConnect:key];
    } else if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(connect:)] && [key length]>0) {
        [tapjoyClass connect:key];;
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.tapjoyadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+(void)tjcConnectSuccess:(NSNotification*)notifyObj{
    if([OMTapjoyAdapter sharedInstance].initBlock) {
        [OMTapjoyAdapter sharedInstance].initBlock(nil);
        [OMTapjoyAdapter sharedInstance].initBlock = nil;
    }
}

+(void)tjcConnectFailed:(NSNotification*)notifyObj{
    if([OMTapjoyAdapter sharedInstance].initBlock) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.tapjoyadapter"
                                                    code:101
                                                userInfo:@{NSLocalizedDescriptionKey:@"Init failed"}];
        [OMTapjoyAdapter sharedInstance].initBlock(error);
        [OMTapjoyAdapter sharedInstance].initBlock = nil;
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
    Class tapjoyClass = NSClassFromString(@"Tapjoy");
    if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(setDebugEnabled:)]) {
        [tapjoyClass setDebugEnabled:logEnable];
    }
}


@end
