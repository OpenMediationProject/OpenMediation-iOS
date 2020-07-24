// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMRequest.h"
#import "OpenMediationConstant.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"

@implementation OMRequest

+ (NSDictionary*)iosInfo {
    NSMutableDictionary *iosInfo = [NSMutableDictionary dictionary];
    [iosInfo setValue:[UIDevice omIdfv] forKey:@"idfv"];
    [iosInfo setValue:[UIDevice omCpuType] forKey:@"cpu_type"];
    [iosInfo setValue:[NSNumber numberWithInt:(int)[UIDevice omIs64bit]] forKey:@"cpu_64bits"];
    [iosInfo setValue:[UIDevice omCountofCores] forKey:@"cpu_count"];
    [iosInfo setValue:[UIDevice omScreenWidth] forKey:@"ui_width"];
    [iosInfo setValue:[UIDevice omScreenHeight] forKey:@"ui_height"];
    [iosInfo setValue:[UIDevice omScreenScale] forKey:@"ui_scale"];
    [iosInfo setValue:[UIDevice omHardwareName] forKey:@"hardware_name"];
    [iosInfo setValue:[UIDevice currentDevice].name forKey:@"device_name"];
    [iosInfo setValue:[UIDevice omNetWorkVersion] forKey:@"cf_network"];
    [iosInfo setValue:[UIDevice omNetworkRelease] forKey:@"darwin"];
    [iosInfo setValue:[UIDevice omCurrentRadioAccessTechnology] forKey:@"ra"];
    [iosInfo setValue:[UIDevice omLocaleIdentifier] forKey:@"local_id"];
    [iosInfo setValue:[UIDevice omTimeZoneAbbreviation] forKey:@"tz_ab"];
    [iosInfo setValue:[NSString stringWithFormat:@"%.2f",(([UIDevice omRamSize]>>20)/1024.0)] forKey:@"tdsg"];
    [iosInfo setValue:[NSString stringWithFormat:@"%.2f",([UIDevice omFreeRamSize]/1024.0)] forKey:@"rdsg"];
    return [iosInfo copy];
    
}

+ (NSDictionary*)commonDeviceInfo {
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    [deviceInfo setValue:[UIDevice omTimeStamp] forKey:@"ts"];
    [deviceInfo setValue:[UIDevice omInstallTime] forKey:@"fit"];
    [deviceInfo setValue:[UIDevice omFirstLaunchTime] forKey:@"flt"];
    [deviceInfo setValue:[UIDevice omMinutesFromGMT] forKey:@"zo"];
    [deviceInfo setValue:[UIDevice omTimeZoneName] forKey:@"tz"];
    [deviceInfo setValue:[UIDevice omSessionID] forKey:@"session"];
    [deviceInfo setValue:[UIDevice omUserID] forKey:@"uid"];
    [deviceInfo setValue:[UIDevice omIdfa] forKey:@"did"];
    [deviceInfo setValue:[UIDevice omDeviveIDType] forKey:@"dtype"];
    [deviceInfo setValue:[UIDevice omLanguageCode] forKey:@"lang"];
    [deviceInfo setValue:[UIDevice omLanguageName] forKey:@"langname"];
    [deviceInfo setValue:[NSNumber numberWithInt:(int)[UIDevice omJailbreak]] forKey:@"jb"];
    [deviceInfo setValue:[UIDevice omBundleID] forKey:@"bundle"];
    [deviceInfo setValue:[UIDevice omModel] forKey:@"model"];
    [deviceInfo setValue:[UIDevice omOSVersion] forKey:@"osv"];
    [deviceInfo setValue:[UIDevice omOSBuildVersion] forKey:@"build"];
    [deviceInfo setValue:[UIDevice omLocalAppVersion] forKey:@"appv"];
    [deviceInfo setValue:[UIDevice omWidthPixels] forKey:@"width"];
    [deviceInfo setValue:[UIDevice omHeightPixels] forKey:@"height"];
    [deviceInfo setValue:[UIDevice omCountryCode] forKey:@"lcountry"];
    [deviceInfo setValue:[[OMNetMonitor sharedInstance]omNetworkType] forKey:@"contype"];
    [deviceInfo setValue:[UIDevice omCarrierInfo] forKey:@"carrier"];
    [deviceInfo setValue:[NSNumber numberWithInteger:[UIDevice omFreeRamSize]] forKey:@"fm"];
    [deviceInfo setValue:[NSNumber numberWithInteger:[UIDevice omBatteryLevel]] forKey:@"battery"];
    [deviceInfo setValue:[NSNumber numberWithInt:(int)[UIDevice omLowPowerMode]] forKey:@"lowp"];
    [deviceInfo setValue:[NSNumber numberWithLongLong:[UIDevice omRamSize]] forKey:@"ram"];
    [deviceInfo setValue:[NSNumber numberWithLongLong:[UIDevice omBootTime]] forKey:@"btime"];
    
    if ([self regs]) {
        [deviceInfo setValue:[self regs] forKey:@"regs"];
    }
    
    if([OMConfig sharedInstance].userAge) {
         [deviceInfo setValue:[NSNumber numberWithInteger:[OMConfig sharedInstance].userAge] forKey:@"age"];
    }

    if([OMConfig sharedInstance].userGender) {
        [deviceInfo setValue:[NSNumber numberWithInteger:[OMConfig sharedInstance].userGender] forKey:@"gender"];
    }

    
    return [deviceInfo copy];
}


+ (NSDictionary*)regs {
    NSMutableDictionary *regs = [NSMutableDictionary dictionary];
    OMConfig *config = [OMConfig sharedInstance];
    if (!config.consent) {
        regs[@"gdpr"] =  [NSNumber numberWithInt:1];
    }
    
    if (config.childrenApp) {
        regs[@"coppa"] =  [NSNumber numberWithInt:1];
    }
    
    if (config.USPrivacy) {
        regs[@"ccpa"] =  [NSNumber numberWithInt:1];
    }
    
    if (regs.count > 0) {
        return [regs copy];
    } else {
        return nil;
    }
}


+ (NSData*)encryptBody:(NSData*)body type:(OMRequestType)type {
    if (type == OMRequestTypeJsonGzipToJson) {
        body = [body omGzipData];
    }
    return  body;
}

+ (void)postWithUrl:(NSString*)url data:(NSData*)data completionHandler:(requestCompletionHandler)completionHandler {
    NSData *bodyData = [self encryptBody:data type:OMRequestTypeJsonGzipToJson];
    [OMBaseRequest postWithUrl:url type:OMRequestTypeJsonGzipToJson body:bodyData completionHandler:^(NSObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            completionHandler(object,nil);
        } else {
            completionHandler(nil,error);
        }
    }];
}

@end
