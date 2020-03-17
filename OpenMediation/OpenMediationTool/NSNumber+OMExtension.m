// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "NSNumber+OMExtension.h"
#import "OMMacros.h"


@implementation NSNumber (OMExtension)

+ (NSNumber*)omStr2Number:(NSString*)str {
    NSInteger number = (OM_STR_EMPTY(str))?0:[str integerValue];
    return  [NSNumber numberWithInteger:number];
}

@end
