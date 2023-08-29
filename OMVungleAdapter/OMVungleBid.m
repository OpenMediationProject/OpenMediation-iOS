// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleBid.h"
#import "OMVungleClass.h"

@implementation OMVungleBid

+ (NSString*)bidderToken {
    NSString *token = @"";
    Class vungleClass = NSClassFromString(@"_TtC12VungleAdsSDK9VungleAds");
    if (vungleClass &&  [vungleClass respondsToSelector:@selector(getBiddingToken)]) {
        token = [vungleClass getBiddingToken];
    }
    return token;
}

@end
