// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMReachability+OMExtentsion.h"


@implementation OMReachability (OMExtentsion)

+ (BOOL)omIsHttpAgentOpen {
    BOOL openHttpAgent = NO;
    CFDictionaryRef proxySettings = CFNetworkCopySystemProxySettings();
    NSDictionary *dictProxy = (__bridge_transfer id)proxySettings;
    

    if ([[dictProxy objectForKey:@"HTTPEnable"] boolValue]) {
        NSString *proxyAddress = [dictProxy objectForKey:@"HTTPProxy"]; 
        NSInteger proxyPort = [[dictProxy objectForKey:@"HTTPPort"] integerValue]; 
        if (proxyAddress.length > 0 && proxyPort > 0) {
            openHttpAgent = YES;
        }
    }
    return openHttpAgent;
}

+ (BOOL)omIsVPNConnected {
    NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    NSArray *keys = [dict[@"__SCOPED__"]allKeys];
    for (NSString *key in keys) {
        if ([key rangeOfString:@"tap"].location != NSNotFound ||
            [key rangeOfString:@"tun"].location != NSNotFound ||
            [key rangeOfString:@"ppp"].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}


@end
