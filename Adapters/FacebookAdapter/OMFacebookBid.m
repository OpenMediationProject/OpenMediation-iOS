// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookBid.h"
#import "OMFacebookClass.h"
#import "OMFacebookBidClass.h"

@implementation OMFacebookBid

+ (NSString*)bidderToken {
    NSString *token = @"";
    Class fbSetting = NSClassFromString(@"FBAdSettings");
    if (fbSetting && [fbSetting respondsToSelector:@selector(bidderToken)]) {
        token = [fbSetting bidderToken];
    }
    return token;
}

@end
