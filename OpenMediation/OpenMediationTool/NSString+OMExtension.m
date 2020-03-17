// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "NSString+OMExtension.h"
#import "NSString+OMEncrypt.h"
#import "OMMacros.h"

#define OM_MODEL_DIR  @"OpenMediation"
#define OM_CACHE_DIR  @"OpenMediation"

@implementation NSString (OMExtension)

+ (NSString *)omComponentsJoinedChar:(NSArray *)array {
    const unichar a = (const unichar)1;
    return [array componentsJoinedByString:[NSString stringWithCharacters:&a length:1]];
}

+ (NSString*)omDataPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataDir = [documentPath stringByAppendingPathComponent:OM_MODEL_DIR];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataDir]) {

        [[NSFileManager defaultManager] createDirectoryAtPath:dataDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return dataDir;

}

+ (NSString*)omCachePath {
    NSString *cachePath = NSTemporaryDirectory();
    NSString *cacheDir = [cachePath stringByAppendingPathComponent:OM_CACHE_DIR];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return cacheDir;
}


+ (NSString*)omUrlCachePath:(NSString*)urlStr {
    if (OM_STR_EMPTY(urlStr) || ![NSURL URLWithString:urlStr]) {
        return @"";
    } else {
        NSString *cachePath = [self omCachePath];
        NSURL *url = [NSURL URLWithString:urlStr];

        if ([url host]) {
            cachePath = [cachePath stringByAppendingPathComponent:[[url host] omMd5]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
               [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
            }
        }
        NSMutableArray *paths = [NSMutableArray array];
        [paths addObjectsFromArray:[url pathComponents]];
        if ([urlStr hasSuffix:@"/"]) {
            [paths addObject:@"/"];
        }
        
        for (int i=0; i<[paths count]; i++) {
            NSString *path = paths[i];
            if ([path isEqualToString:@"/"]) {
                cachePath = [cachePath stringByAppendingString:@"/"];
            } else {
                cachePath = [cachePath stringByAppendingPathComponent:path];
                if (i < ([paths count]-1)) {
                    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
                        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
                    }
                }
            }

        }
        return cachePath;
    }

}

+ (NSString*)omUrlCacheInfoPath:(NSString*)urlStr {
    if (OM_STR_EMPTY(urlStr) || ![NSURL URLWithString:urlStr]) {
        return @"";
    } else {
        return [[NSString omUrlCachePath:urlStr] stringByAppendingPathExtension:@"i"];
    }
    
}

+ (BOOL)omUrlHeaderRedirection:(NSString*)urlStr {
    BOOL headerRedirection = NO;
    NSString *cacheInfoPath = [NSString omUrlCacheInfoPath:urlStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cacheInfoPath]) {
        NSDictionary *cacheInfo = [NSDictionary dictionaryWithContentsOfFile:cacheInfoPath];
        NSDictionary *responseHeader = [cacheInfo objectForKey:@"responseHeader"];
        if ([responseHeader objectForKey:@"Location"] ||[responseHeader objectForKey:@"Refresh"]) {
            headerRedirection = YES;
        }
    }
    return headerRedirection;
}

+ (BOOL)omUrlCacheReady:(NSString*)urlStr {
    if (OM_STR_EMPTY(urlStr) || ![NSURL URLWithString:urlStr] || (![urlStr hasPrefix:@"http"] && ![urlStr hasPrefix:@"https"])) {
        return YES;
    } else {
        BOOL isReady = NO;
        NSString *cachePath = [NSString omUrlCachePath:urlStr];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([self omUrlHeaderRedirection:urlStr]) {
            isReady = YES;
        } else if ([fileManager fileExistsAtPath:cachePath]) {
            NSError *error = nil;
            NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:cachePath error:&error];
            if (!error) {
                NSInteger fileCurrentSize = [[fileAttr objectForKey:@"NSFileSize"]integerValue];
                NSInteger expectedSize = [[[NSUserDefaults standardUserDefaults]objectForKey:[urlStr omMd5]]integerValue];
                if (expectedSize >0 && fileCurrentSize == expectedSize) {
                    isReady = YES;
                }
            }
        }
        return isReady;
    }
}

+ (NSString*)omEscapeStr:(NSString*)str {
    if (OM_STR_EMPTY(str)) {
        return @"";
    }
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    str = [str stringByReplacingOccurrencesOfString:@"false" withString:@"0"];
    return str;
}


+ (NSString*)omObj2JsonStr:(NSObject*)object {
    NSString *jsonStr = @"{}";
    if (object && ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]])) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
        if (!error && jsonData) {
            jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return jsonStr;
}

@end
