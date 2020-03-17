// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (OMExtension)
+ (NSString *)omComponentsJoinedChar:(NSArray *)array;
+ (NSString*)omDataPath;
+ (NSString*)omCachePath;
+ (NSString*)omUrlCachePath:(NSString*)urlStr;
+ (NSString*)omUrlCacheInfoPath:(NSString*)urlStr;
+ (BOOL)omUrlCacheReady:(NSString*)urlStr;
+ (NSString*)omEscapeStr:(NSString*)str;
+ (NSString*)omObj2JsonStr:(NSObject*)object;
@end

NS_ASSUME_NONNULL_END
