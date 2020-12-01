// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionHTTPCacheControl.h"
#import "OMToolUmbrella.h"
@implementation OMCrossPromotionHTTPCacheControl

+ (NSDictionary*)urlCacheInfo:(NSString*)url {
    NSDictionary *info = [NSDictionary dictionary];
    if(!OM_STR_EMPTY(url) && [NSURL URLWithString:url]) {
        NSString *cacheInfoPath = [NSString omUrlCacheInfoPath:url];
        if(cacheInfoPath && [[NSFileManager defaultManager]fileExistsAtPath:cacheInfoPath]) {
            NSDictionary *cacheInfo = [NSDictionary dictionaryWithContentsOfFile:cacheInfoPath];
            if(cacheInfo && [cacheInfo isKindOfClass:[NSDictionary class]]) {
                info = cacheInfo;
            }
        }
    }
    return info;
}

+ (NSDictionary*)urlResponseHeader:(NSString*)url {
    NSDictionary *responseHeader = [NSDictionary dictionary];
    if(!OM_STR_EMPTY(url) && [NSURL URLWithString:url]) {
        NSString *cacheInfoPath = [NSString omUrlCacheInfoPath:url];
        if(cacheInfoPath && [[NSFileManager defaultManager]fileExistsAtPath:cacheInfoPath]) {
            NSDictionary *cacheInfo = [NSDictionary dictionaryWithContentsOfFile:cacheInfoPath];
            if(cacheInfo && [cacheInfo isKindOfClass:[NSDictionary class]] && [cacheInfo objectForKey:@"responseHeader"]) {
                responseHeader = [cacheInfo objectForKey:@"responseHeader"];
            }
        }
    }
    return responseHeader;
}

+ (OMCrossPromotionHTTPCacheControlType)cacheType:(NSString*)url {
    OMCrossPromotionHTTPCacheControlType cacheType = OMCrossPromotionHTTPCacheControlTypeMustRevalidate;
//    NSDictionary *cacheInfo = [self urlResponseHeader:url];
//    NSString *cacheControl = [cacheInfo objectForKey:@"Cache-Control"];
//    if(!OM_STR_EMPTY(cacheControl)) {
//        NSArray *directives = [cacheControl componentsSeparatedByString:@","];
//        for (NSString *directive in directives) {
//            if([directive isEqualToString:@"no-store"]) {
//                cacheType = OMCrossPromotionHTTPCacheControlTypeNoStore;
//            }else if([directive isEqualToString:@"no-cache"]) {
//                cacheType = OMCrossPromotionHTTPCacheControlTypeNoStore;
//            }else if([directive isEqualToString:@"must-revalidation"]) {
//                cacheType = OMCrossPromotionHTTPCacheControlTypeMustRevalidate;
//            }
//
//        }
//    }
    cacheType = OMCrossPromotionHTTPCacheControlTypeMustRevalidate;
    return cacheType;
}

+ (NSTimeInterval)cacheExpireTime:(NSString*)url {
    NSInteger maxAge = 0;
    NSTimeInterval expire = 0;
    NSDictionary *cacheInfo = [self urlCacheInfo:url];
    if([cacheInfo objectForKey:@"FileExpireTime"]) {
        expire = [[cacheInfo objectForKey:@"FileExpireTime"]doubleValue];
    }else{
        NSDictionary *responseHeader = [self urlResponseHeader:url];
        NSString *cacheControl = [responseHeader objectForKey:@"Cache-Control"];
        if(!OM_STR_EMPTY(cacheControl) && [cacheControl containsString:@"max-age"] ) {
            NSArray *directives = [cacheControl componentsSeparatedByString:@","];
            for (NSString *directive in directives) {
                if([directive containsString:@"max-age"]) {
                    NSArray *maxAgeGroup = [directive componentsSeparatedByString:@"="];
                    if(maxAgeGroup.count == 2) {
                        maxAge = [[maxAgeGroup lastObject]integerValue];
                    }
                }
                
            }
        }
        
        NSString *dateStr = [responseHeader objectForKey:@"Date"];
        if(!OM_STR_EMPTY(dateStr) && maxAge > 0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
            dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            NSDate *date = [dateFormatter dateFromString:dateStr];
            expire = [date timeIntervalSince1970] + maxAge;
        }else{
            NSString *dateStr = [responseHeader objectForKey:@"Expires"];
            if(!OM_STR_EMPTY(dateStr)) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
                dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                NSDate *date = [dateFormatter dateFromString:dateStr];
                expire = [date timeIntervalSince1970];
            }
        }
        
        NSTimeInterval responseTime = [[cacheInfo objectForKey:@"responseDate"]doubleValue];
        NSTimeInterval minExpire = responseTime + CROSSPROMOTION_MIN_CACHE_MAXAGE;
        NSTimeInterval maxExpire = responseTime + CROSSPROMOTION_MAX_CACHE_MAXAGE;
        if(expire < minExpire) {
            expire = minExpire;
        }
        if(expire > maxExpire) {
            expire = maxExpire;
        }
        NSMutableDictionary *cacheInfoContainExpire = [NSMutableDictionary dictionaryWithDictionary:cacheInfo];
        [cacheInfoContainExpire setObject:[NSString stringWithFormat:@"%lf",expire] forKey:@"FileExpireTime"];
        [cacheInfoContainExpire writeToFile:[NSString omUrlCacheInfoPath:url] atomically:YES];
    }

    
    
    return expire;
}

+ (BOOL)cacheExpire:(NSString*)url {
    if(OM_STR_EMPTY(url) || ![NSURL URLWithString:url] || (![url hasPrefix:@"http"] && ![url hasPrefix:@"https"])) {
        return NO;
    }
    OMCrossPromotionHTTPCacheControlType cacheType = [self cacheType:url];
    NSTimeInterval expireTime = [self cacheExpireTime:url];
    switch (cacheType) {
        case OMCrossPromotionHTTPCacheControlTypeMustRevalidate:
            return ([[NSDate date]timeIntervalSince1970] >= expireTime);
            break;
        case OMCrossPromotionHTTPCacheControlTypeNoCache:
            return YES;
            break;
        case OMCrossPromotionHTTPCacheControlTypeNoStore:
            return YES;
            break;
        default:
            break;
    }
    
}

+ (NSString*)eTag:(NSString*)url {
    NSDictionary *responseHeader = [self urlResponseHeader:url];
    return OM_SAFE_STRING([responseHeader objectForKey:@"Etag"]);
}

+ (NSString*)lastModified:(NSString*)url {
    NSDictionary *responseHeader = [self urlResponseHeader:url];
    return OM_SAFE_STRING([responseHeader objectForKey:@"Last-Modified"]);
}

+ (NSDictionary*)cacheHeaders:(NSString*)url {
    NSMutableDictionary *cacheHeader = [NSMutableDictionary dictionary];
    OMCrossPromotionHTTPCacheControlType cacheType = [self cacheType:url];
    if ((cacheType == OMCrossPromotionHTTPCacheControlTypeMustRevalidate && [self cacheExpire:url]) || cacheType == OMCrossPromotionHTTPCacheControlTypeNoCache) {
        NSString *etag = [self eTag:url];
        NSString *lastModified = [self lastModified:url];
        if(!OM_STR_EMPTY(etag)) {
            [cacheHeader setObject:etag forKey:@"If-None-Match"];
        }
        if (!OM_STR_EMPTY(lastModified)) {
            [cacheHeader setObject:lastModified forKey:@"If-Modified-Since"];
        }
    }

    return [cacheHeader copy];
}

+ (NSInteger)responseCode:(NSString*)url {
    NSInteger statusCode = 0;
    NSDictionary *cacheInfo = [self urlCacheInfo:url];
    NSInteger code = [[cacheInfo objectForKey:@"code"]integerValue];
    if(code > 0) {
        statusCode  = code;
    }
    return statusCode;
}
@end
