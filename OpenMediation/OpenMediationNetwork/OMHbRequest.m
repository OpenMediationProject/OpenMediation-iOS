// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHbRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"
#import "OMAudience.h"
#import "OMLoadFrequencryControl.h"
@implementation OMHbRequest

+ (void)requestDataWithPid:(NSString *)pid
                actionType:(NSInteger)actionType
         completionHandler:(hbCompletionHandler)completionHandler {
    NSDictionary *parameters = [self hbParametersWithPid:pid actionType:actionType];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (jsonData && !jsonError && [[OMConfig sharedInstance].hbUrl length]>0) {
        [OMRequest postWithUrl:[self hbUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (!error) {
                if (([object isKindOfClass:[NSDictionary class]])) {
                    completionHandler((NSDictionary *)object, nil);
                } else {
                    completionHandler(nil,[NSError omNetworkError:OMRequestErrorInvalidResponseData]);
                }
            } else {
                completionHandler([NSDictionary dictionary],error);
            }
        }];
    }
}

+ (NSString*)hbUrl {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@",[OMConfig sharedInstance].hbUrl,OPENMEDIATION_SDK_VERSION];
}

+ (NSDictionary*)hbParametersWithPid:(NSString*)pid
                          actionType:(NSInteger)actionType {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    parameters[@"pid"] = @([pid integerValue]);
    parameters[@"iap"] = [NSNumber numberWithFloat:[OMAudience sharedInstance].purchaseAmount];
    parameters[@"imprTimes"] = [NSNumber numberWithInteger:[[OMLoadFrequencryControl sharedInstance]todayimprCountOnPlacment:pid]];
    parameters[@"act"] = [NSNumber numberWithInteger:actionType];
    return [parameters copy];
}

@end
