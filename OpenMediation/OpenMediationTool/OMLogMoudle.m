// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMLogMoudle.h"
#import "OMToolUmbrella.h"

static NSString *const OMLogNotification = @"OMLogNotification";
#ifdef DEBUG
static OMLogLevel LogLevel = OMLogLevelV;
#else
static OMLogLevel LogLevel = OMLogLevelI;
#endif

@implementation OMLogMoudle

+ (void)logIntial {
    NSString *logDirectory = [[NSString omDataPath] stringByAppendingPathComponent:@"OMLog"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logDirectory error:nil];
    
    for (NSString *file in logFiles)
    {
        NSString *todayLogFile = [NSString stringWithFormat:@"OM%@.log",[NSDate omBeijingDate]];
        if (![file isEqualToString:todayLogFile]) {
            [[NSFileManager defaultManager] removeItemAtPath:[logDirectory stringByAppendingPathComponent:file] error:nil];
        }

    }
}


+ (void)openLog:(BOOL)open {
    if (open) {
#ifdef DEBUG
        LogLevel = OMLogLevelV;
#else
        LogLevel = OMLogLevelI;
#endif
    } else {
        LogLevel = OMLogLevelN;
    }
}
+ (void)setDebugMode {
#ifdef DEBUG
        [self setLogLevel:OMLogLevelV];
#else
        [self setLogLevel:OMLogLevelD];
#endif
}
+ (void)setVerboseMode {
    [self setLogLevel:OMLogLevelV];
}

+ (void)setLogLevel:(OMLogLevel)level
{
    LogLevel = level;
}

+ (void)logV:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2) {
    va_list args;
    va_start(args, format);
    [self logLevel:OMLogLevelV format:format vaList:args];
    va_end(args);
}

+ (void)logD:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2) {
    va_list args;
    va_start(args, format);
    [self logLevel:OMLogLevelD format:format vaList:args];
    va_end(args);
}

+ (void)logI:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2) {
    va_list args;
    va_start(args, format);
    [self logLevel:OMLogLevelI format:format vaList:args];
    va_end(args);
}

+ (void)logW:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2) {
    va_list args;
    va_start(args, format);
    [self logLevel:OMLogLevelW format:format vaList:args];
    va_end(args);
}

+ (void)logE:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2) {
    va_list args;
    va_start(args, format);
    [self logLevel:OMLogLevelE format:format vaList:args];
    va_end(args);
}

+ (void)logLevel:(OMLogLevel)level format:(NSString *)format vaList:(va_list)args {
    if (level >= LogLevel) {
        NSString *log = [[NSString alloc]initWithFormat:format arguments:args];
        NSString *lineLog = [NSString stringWithFormat:@"OM%@:%@",[self stringFromLogLevel:level],log];
        NSLog(@"%@",lineLog);

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:OMLogNotification object:lineLog];
        });
    }
}

+ (NSString*)stringFromLogLevel:(OMLogLevel)logLevel {
    switch (logLevel) {
        case OMLogLevelV: return @"[V]";
        case OMLogLevelD: return @"[D]";
        case OMLogLevelI: return @"[I]";
        case OMLogLevelW: return @"[W]";
        case OMLogLevelE: return @"[E]";
        case OMLogLevelN: return @"[N]";
    }
    return @"";
}

@end
