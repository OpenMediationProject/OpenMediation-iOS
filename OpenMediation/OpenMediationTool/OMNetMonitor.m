// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMNetMonitor.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@interface OpenMediation:NSObject

+ (void)checkSDKInit;

@end

static OMNetMonitor * _instance = nil;

@implementation OMNetMonitor

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)startMonitor {
    if (!self.reachability) {
        self.reachability =[OMReachability reachabilityForInternetConnection];
        [self.reachability startNotifier];
        [self updateInterfaceWithReachability:self.reachability];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kOMReachabilityChangedNotification object:nil];
    }
}

- (void)updateInterfaceWithReachability:(OMReachability *)reachability {
    _netStatus = [reachability currentReachabilityStatus];
    [OpenMediation checkSDKInit];
}

- (void) reachabilityChanged:(NSNotification *)note {
    OMReachability* curReach = [note object];
    if ([curReach isKindOfClass:[OMReachability class]]) {
        [self updateInterfaceWithReachability:curReach];
    }

}

- (NSString *)getNetWorkType {
    
    NSString * type = nil;
    switch (self.netStatus) {
        case OMNotReachable:// 没有网络
        {
            type = @"NoNetwork";
            break;
        }
        case OMReachableViaWiFi:// Wifi
        {
            type = @"WiFi";
            break;
        }
        case OMReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentStatus = @"";//
            SEL radioTechSelector = NSSelectorFromString(@"currentRadioAccessTechnology");
            if ([networkInfo respondsToSelector:radioTechSelector]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                 currentStatus = [networkInfo performSelector:radioTechSelector];
                #pragma clang diagnostic pop
            }

            if (!currentStatus || currentStatus.length <= 0) {
                type = @"UnKown";
            } else {
                type = [self networkStatus:currentStatus];
            }
            break;
        }
        default:{
            type = @"UnKown";
            break;
        }
    }
    return type;
}


- (NSString *)networkStatus:(NSString *)accessString {
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    if ([typeStrings4G containsObject:accessString]) {
        return @"4G";
    } else if ([typeStrings3G containsObject:accessString]) {
        return @"3G";
    } else if ([typeStrings2G containsObject:accessString]) {
        return @"2G";
    } else {
        return accessString;
    }
}

- (NSNumber*)omNetworkType {
    NSInteger networkType = [[self getNetWorkType]isEqualToString:@"WiFi"]? 2 : 6;
    return [NSNumber numberWithInteger:networkType];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kOMReachabilityChangedNotification object:self];
}

@end
