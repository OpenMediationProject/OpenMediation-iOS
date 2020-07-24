// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTapjoyAdapter.h"

static OMTapjoyAdapter * _instance = nil;

@implementation OMTapjoyAdapter

+ (NSString*)adapterVerison {
    return TapjoyAdapterVersion;
}

+ (NSString*)adNetworkVersion {
    NSString *sdkVersion = @"";
    Class sdkClass = NSClassFromString(@"Tapjoy");
    if (sdkClass && [sdkClass respondsToSelector:@selector(getVersion)]) {
        sdkVersion = [sdkClass getVersion];
    }
    return sdkVersion;
}

+ (NSString*)minimumSupportVersion {
    return @"7.2.0";
}

+ (void)setConsent:(BOOL)consent {
    
    Class tapjoyClass = NSClassFromString(@"Tapjoy");
    if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(setUserConsent:)]) {
        [tapjoyClass setUserConsent:(consent?@"1":@"0")];
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
    
    if ([[self adNetworkVersion]compare:[self minimumSupportVersion]options:NSNumericSearch] == NSOrderedAscending) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.tapjoyadapter"
                                                    code:505
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The current ad network(%@) is below the minimum required version(%@)",[self adNetworkVersion],[self minimumSupportVersion]]}];
        completionHandler(error);
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_LIMITED_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFailed:) name:TJC_CONNECT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFailed:) name:TJC_LIMITED_CONNECT_FAILED object:nil];
    
    if(tapjoyClass && [tapjoyClass respondsToSelector:@selector(limitedConnect:)] && [key length]>0){
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
    if([OMTapjoyAdapter sharedInstance].initBlock){
        [OMTapjoyAdapter sharedInstance].initBlock(nil);
        [OMTapjoyAdapter sharedInstance].initBlock = nil;
    }
}

+(void)tjcConnectFailed:(NSNotification*)notifyObj{
    if([OMTapjoyAdapter sharedInstance].initBlock){
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

@end
