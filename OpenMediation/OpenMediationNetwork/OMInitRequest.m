// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMInitRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"
#import "OMMediations.h"


@implementation OMInitRequest

+(void)configureWithAppKey:(NSString *)appKey baseHost:(NSString*)host completionHandler:(configureCompletionHandler)completionHandler {
    if (!appKey) {
        OMLogD(@"appkey nil");
        return;
    }
    
    [OMConfig sharedInstance].initState = ([[OMConfig sharedInstance]initSuccess]?OMInitStateReinitialize:OMInitStateInitializing);
    OMLogD(@"init key %@" ,appKey);
    [OMConfig sharedInstance].baseHost = host;
    [OMConfig sharedInstance].appKey = appKey;
    [UIDevice omStoreSessionID];
    
    NSDictionary *configCacheData = [[OMConfig sharedInstance]configCacheData:appKey version:@"v1"];
    if (configCacheData) {
        [[OMConfig sharedInstance] loadCongifData:configCacheData];
        completionHandler(nil);
    }
    
    NSDictionary *parameters = [self initParameters];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (!jsonError && jsonData) {
        [OMRequest postWithUrl:[self initUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (!error) {
                NSDictionary *configDic = (NSDictionary *)object;
                [[OMConfig sharedInstance]saveConfigData:configDic appKey:appKey version:@"v1"];
                [[OMConfig sharedInstance] loadCongifData:configDic];
                completionHandler(nil);
                OMLogI(@"OpenMediation SDK init success");
            } else {
                OMLogD(@"init failed:%@", error.localizedDescription);
                if (![[OMConfig sharedInstance]initSuccess]) {
                    [OMConfig sharedInstance].initState = OMInitStateDefault;
                }
                NSError * omError = [OMError omRequestError:OMErrorModuleInit error:error];
                NSError * developerError = [OMSDKError errorWithAdtError:omError];
                [OMSDKError throwDeveloperError:developerError];
                completionHandler(developerError);
            }
        }];
    }
}

+ (NSString*)initUrl {
    return [NSString stringWithFormat:@"%@/init?v=1&plat=0&sdkv=%@&k=%@",[OMConfig sharedInstance].baseHost,OPENMEDIATION_SDK_VERSION,[OMConfig sharedInstance].appKey];
}


+ (NSDictionary *)initParameters {
    NSMutableDictionary *initParameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    [initParameters setObject:[OMRequest iosInfo] forKey:@"ios"];
    [initParameters setObject:[[[OMMediations sharedInstance]adNetworkInfo]allValues] forKey:@"adns"];
    return [initParameters copy];
}

@end
