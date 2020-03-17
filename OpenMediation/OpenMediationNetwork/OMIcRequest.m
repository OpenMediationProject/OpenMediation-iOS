// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIcRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"

@implementation OMIcRequest

+ (void)postWithPid:(NSString *)pid
              instanceID:(NSString *)instanceID
                adnID:(OMAdNetwork)adnID
                 sceneID:(NSString *)sceneID
             extraParams:(NSString*)extraParams {
    NSDictionary *parameters = [self icParametersWithpid:pid instanceID:instanceID adnID:adnID sceneID:sceneID extraParams:extraParams];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (jsonData && !jsonError && [[OMConfig sharedInstance].icUrl length]>0) {
        [OMRequest postWithUrl:[self icUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (error) {
                OMLogD(@"ic report error");
            }
        }];
    }
}

+ (NSString *)icUrl {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@",[OMConfig sharedInstance].icUrl,OPENMEDIATION_SDK_VERSION];
}

+ (NSDictionary *)icParametersWithpid:(NSString *)pid
                           instanceID:(NSString *)instanceID
                                adnID:(OMAdNetwork)adnID
                              sceneID:(NSString *)sceneID
                          extraParams:(NSString*)extraParams {
    NSMutableDictionary *icParameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    icParameters[@"pid"] = @([pid integerValue]);;
    icParameters[@"mid"] = [NSNumber numberWithInteger:adnID];
    icParameters[@"iid"] = @([instanceID integerValue]);
    icParameters[@"scene"] = sceneID;
    icParameters[@"content"] = OM_SAFE_STRING(extraParams);
    return [icParameters copy];
}

@end
