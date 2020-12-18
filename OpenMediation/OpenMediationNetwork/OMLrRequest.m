// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMLrRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"

@implementation OMLrRequest

+ (void)postWithType:(OMLRType)type
                     pid:(NSString *)pid
                   adnID:(OMAdNetwork)adnID
              instanceID:(NSString *)instanceID
                  action:(NSInteger)action
                   scene:(NSString *)sceneID
                 abt:(NSInteger)abTest
                 bid:(BOOL)bid {
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:pid];
    if ((type == OMLRTypeSDKInit || type == OMLRTypeWaterfallLoad || (unit.adFormat == OpenMediationAdFormatCrossPromotion && type == OMLRTypeWaterfallReady))) {
        return;
    }
    NSDictionary *parameters = [self lrParametersWithType:type pid:pid adnID:adnID instanceID:instanceID action:action scene:sceneID abt:abTest bid:bid];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (!jsonError && jsonData && [[OMConfig sharedInstance].lrUrl length]>0) {
        [OMRequest postWithUrl:[self lrUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (error) {
                OMLogD(@"lr error");
            } else {
                OMLogD(@"lr type %zd,pid %@ iid:%@",type,pid,instanceID);
            }
        }];
    }
}

+ (NSString *)lrUrl {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@",[OMConfig sharedInstance].lrUrl,OPENMEDIATION_SDK_VERSION];
}


+ (NSDictionary *)lrParametersWithType:(OMLRType)type
                                   pid:(NSString *)pid
                                 adnID:(OMAdNetwork)adnID
                            instanceID:(NSString *)instanceID
                                action:(NSInteger)action
                                 scene:(NSString *)sceneID
                                   abt:(NSInteger)abTest
                                   bid:(BOOL)bid
{
    NSMutableDictionary *lrParameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    if (type<OMLRTypeSDKInit || type>OMLRTypeVideoComplete) {
        NSLog(@"invalid lr type = %zd",type);
    }
    
    lrParameters[@"type"] = @(type);
    lrParameters[@"mid"] = [NSNumber numberWithInteger:adnID];
    lrParameters[@"pid"] = @([pid integerValue]);;
    lrParameters[@"iid"] = @([instanceID integerValue]);
    if (type == OMLRTypeWaterfallLoad) {
        lrParameters[@"act"] = @(action);
    }
    if (type >= OMLRTypeInstanceImpression && [sceneID length] > 0) {
        lrParameters[@"scene"] = @([sceneID integerValue]);
    }
    if (abTest>0) {
        lrParameters[@"abt"] = @(abTest);
    }
    if (bid) {
        lrParameters[@"bid"] = @(1);
    }
    
    return [lrParameters copy];
}

@end
