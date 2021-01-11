// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralBid.h"
#import "OMMintegralBidClass.h"

@implementation OMMintegralBid

+ (NSString*)bidderToken {
    NSString *token = @"";
    Class mtgSDK = NSClassFromString(@"MTGBiddingSDK");
    if (mtgSDK && [mtgSDK respondsToSelector:@selector(buyerUID)]) {
        token = [mtgSDK buyerUID];
    }
    return token;;
}

@end

