// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleBid.h"
#import "OMVungleClass.h"

@implementation OMVungleBid

+ (NSString*)bidderToken {
    NSString *token = @"";
    Class vungleSDK = NSClassFromString(@"_TtC12VungleAdsSDK9VungleAds");
    if (vungleSDK &&  [vungleSDK respondsToSelector:@selector(getBiddingToken)]) {
        token = [vungleSDK getBiddingToken];
    }
    return token;
}

@end
