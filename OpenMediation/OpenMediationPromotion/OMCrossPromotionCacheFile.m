// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionCacheFile.h"
#import "OMCrossPromotionHTTPCacheControl.h"
#import "OMToolUmbrella.h"

@implementation OMCrossPromotionCacheFile

+ (BOOL)cacheFresh:(NSString*)url {
    BOOL cacheReady = [NSString omUrlCacheReady:url];
    BOOL expires = [OMCrossPromotionHTTPCacheControl cacheExpire:url];
    return (cacheReady && !expires);
}

+ (NSDictionary*)cacheHeader:(NSString*)url {
    if(!OM_STR_EMPTY(url) && [NSString omUrlCacheReady:url]) {
        NSDictionary *headers =[OMCrossPromotionHTTPCacheControl cacheHeaders:url];
        return headers;
    }else{
        return [NSDictionary dictionary];
    }
}

+ (NSString*)localHtmlStr:(NSString*)url {
    NSString *htmlContent = @"";

    if (!OM_STR_EMPTY(url)) {
        if([NSString omUrlCacheReady:url]) {
            NSString *urlCachePath = [NSString omUrlCachePath:url];
            NSData *fileData = [NSData dataWithContentsOfFile:urlCachePath];
            if(!OM_DATA_EMPTY(fileData)) {
                NSString *fileContent = [[NSString alloc]initWithData:fileData encoding:NSUTF8StringEncoding];
                if(!OM_STR_EMPTY(fileContent)) {
                    htmlContent = fileContent;
                }
            }
        }

    }
    return htmlContent;
}

@end
