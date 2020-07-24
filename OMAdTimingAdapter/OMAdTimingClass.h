// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingClass_h
#define OMAdTimingClass_h

@interface AdTiming : NSObject
+ (NSString *)SDKVersion;
+ (void)initWithAppKey:(NSString*)appKey;
+ (NSString*)bidderToken;
@end

#endif /* OMAdTimingClass_h */
