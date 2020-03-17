// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMWaterfallRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"
#import "OMAudience.h"
#import "OMLoadFrequencryControl.h"

@implementation OMWaterfallRequest

+ (void)requestDataWithPid:(NSString *)pid
                actionType:(NSInteger)actionType
              bidResponses:(NSArray*)bidResponses
         completionHandler:(wfCompletionHandler)completionHandler {
    NSDictionary *parameters = [self wfParametersWithPid:pid actionType:actionType bidResponses:bidResponses];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (jsonData && !jsonError && [[OMConfig sharedInstance].clUrl length]>0) {
        [OMRequest postWithUrl:[self waterfallUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (!error) {
                if ([object isKindOfClass:[NSDictionary class]]) {
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

+ (NSString*)waterfallUrl {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@",[OMConfig sharedInstance].clUrl,OPENMEDIATION_SDK_VERSION];
}

+ (NSDictionary*)wfParametersWithPid:(NSString*)pid
                          actionType:(NSInteger)actionType
                        bidResponses:(NSArray*)bidResponses {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    parameters[@"pid"] = @([pid integerValue]);
    parameters[@"iap"] = [NSNumber numberWithFloat:[OMAudience sharedInstance].purchaseAmount];
    parameters[@"imprTimes"] = [NSNumber numberWithInteger:[[OMLoadFrequencryControl sharedInstance]todayimprCountOnPlacment:pid]];
    parameters[@"act"] = [NSNumber numberWithInteger:actionType];
    if (bidResponses.count>0) {
        parameters[@"bid"] = bidResponses;
    }
    return [parameters copy];
}

@end
