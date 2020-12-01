// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMToolUmbrella.h"
#import "OMCrossPromotionHTTPCacheControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionCacheFile : NSObject
+ (BOOL)cacheFresh:(NSString*)url;
+ (NSDictionary*)cacheHeader:(NSString*)url;
+ (NSString*)localHtmlStr:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
