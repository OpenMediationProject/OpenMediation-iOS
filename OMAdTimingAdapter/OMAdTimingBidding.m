// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingBidding.h"
#import "OMAdTimingClass.h"

@implementation OMAdTimingBidding

+ (NSString*)bidderToken {
    NSString *token = @"";
    Class adtimingClass = NSClassFromString(@"AdTiming");
    if (adtimingClass && [adtimingClass respondsToSelector:@selector(bidderToken)]) {
        token = [adtimingClass bidderToken];
    }
    return token;
}

@end
