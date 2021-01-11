// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleBid.h"
#import "OMVungleBidClass.h"

@implementation OMVungleBid

+ (NSString*)bidderToken {
    NSString *token = @"";
    Class vungleSDK = NSClassFromString(@"VungleSDK");
    if (vungleSDK &&  [vungleSDK respondsToSelector:@selector(sharedSDK)] && [vungleSDK instancesRespondToSelector:@selector(currentSuperToken)]) {
        token = [[vungleSDK sharedSDK] currentSuperToken];
    }
    return token;
}

@end
