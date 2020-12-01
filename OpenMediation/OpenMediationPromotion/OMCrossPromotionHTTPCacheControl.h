// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

#define CROSSPROMOTION_MIN_CACHE_MAXAGE   (60*60)
#define CROSSPROMOTION_MAX_CACHE_MAXAGE   (60*60*24)

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OMCrossPromotionHTTPCacheControlType) {
    OMCrossPromotionHTTPCacheControlTypeMustRevalidate = 0,
    OMCrossPromotionHTTPCacheControlTypeNoCache = 1,
    OMCrossPromotionHTTPCacheControlTypeNoStore = 2,
};

@interface OMCrossPromotionHTTPCacheControl : NSObject
+ (NSDictionary*)urlCacheInfo:(NSString*)url;
+ (NSDictionary*)urlResponseHeader:(NSString*)url;
+ (OMCrossPromotionHTTPCacheControlType)cacheType:(NSString*)url;
+ (NSTimeInterval)cacheExpireTime:(NSString*)url;
+ (BOOL)cacheExpire:(NSString*)url;
+ (NSString*)eTag:(NSString*)url;
+ (NSString*)lastModified:(NSString*)url;
+ (NSDictionary*)cacheHeaders:(NSString*)url;
+ (NSInteger)responseCode:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
