// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

//Verbose
#define OMLogV(format, ...) [OMLogMoudle logV:format,##__VA_ARGS__];

//Debug
#define OMLogD(format, ...) [OMLogMoudle logD:format,##__VA_ARGS__];

//Info
#define OMLogI(format, ...) [OMLogMoudle logI:format,##__VA_ARGS__];

//Warning
#define OMLogW(format, ...) [OMLogMoudle logW:format,##__VA_ARGS__];

//Error
#define OMLogE(format, ...) [OMLogMoudle logE:format,##__VA_ARGS__];

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OMLogLevel) {
    OMLogLevelV = 0,    //Verbose
    OMLogLevelD = 1,    //Debug
    OMLogLevelI = 2,    //Info
    OMLogLevelW = 3,    //Warning
    OMLogLevelE = 4,    //Error
    OMLogLevelN = 5,    //close
};

@interface OMLogMoudle : NSObject

+ (void)openLog:(BOOL)open;
+ (void)setDebugMode;
+ (void)setVerboseMode;
+ (void)logV:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);
+ (void)logD:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);
+ (void)logI:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);
+ (void)logW:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);
+ (void)logE:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);

@end

NS_ASSUME_NONNULL_END
