// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "NSDate+OMExtension.h"


@implementation NSDate (OMExtension)

+ (NSString*)omBeijingDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    return dateStr;
}

+ (NSString*)omBeijingTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    return timeStr;
}

+ (NSString*)omGMTTimeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
