// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionBid.h"
#import "OpenMediationConstant.h"
#import "OMToolUmbrella.h"
#import "OMUserData.h"

@implementation OMCrossPromotionBid

+ (NSString*)bidderToken {
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    [body setValue:OPENMEDIATION_SDK_VERSION forKey:@"sdkv"];
    [body setValue:[UIDevice omInstallTime] forKey:@"fit"];
    [body setValue:[UIDevice omFirstLaunchTime] forKey:@"flt"];
    [body setValue:[UIDevice omSessionID] forKey:@"session"];
    [body setValue:[UIDevice omUserID] forKey:@"uid"];
    [body setValue:[UIDevice omIdfa] forKey:@"did"];
    [body setValue:[UIDevice omDeviveIDType] forKey:@"dtype"];
    [body setValue:[UIDevice omMinutesFromGMT] forKey:@"zo"];
    [body setValue:[NSNumber numberWithInteger:[UIDevice omFreeRamSize]] forKey:@"fm"];
    [body setValue:[NSNumber numberWithInteger:[UIDevice omBatteryLevel]] forKey:@"battery"];
    [body setValue:[UIDevice omCountryCode] forKey:@"lcy"];
    
    if([OMUserData sharedInstance].purchaseAmount > 0) {
        [body setValue:[NSNumber numberWithFloat:[OMUserData sharedInstance].purchaseAmount] forKey:@"iap"];
    }
    

    if([[UIDevice omAFUid]length]>0) {
        [body setValue:[UIDevice omAFUid] forKey:@"afid"];
    }
    
    if([UIDevice omJailbreak]) {
        [body setValue:[NSNumber numberWithInt:(int)[UIDevice omJailbreak]] forKey:@"jb"];
    }

    if([UIDevice omLowPowerMode]) {
        [body setValue:[NSNumber numberWithInt:(int)[UIDevice omLowPowerMode]] forKey:@"lowp"];
    }

    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];
    
    NSString *token = @"";
    if(!jsonError && jsonData) {
        jsonData = [jsonData omZlibDeflate];
        if(jsonData && [jsonData length]) {
            token = [jsonData base64EncodedStringWithOptions:0];
        }
    }

    return token;

}

@end
