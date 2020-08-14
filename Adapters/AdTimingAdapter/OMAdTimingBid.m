// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingBid.h"
#import "OMAdTimingClass.h"

@implementation OMAdTimingBid

+ (NSString*)bidderToken {
    NSString *token = @"";
    Class adtimingClass = NSClassFromString(@"AdTiming");
    if (adtimingClass && [adtimingClass respondsToSelector:@selector(bidderToken)]) {
        token = [adtimingClass bidderToken];
    }
    return token;
}

@end
