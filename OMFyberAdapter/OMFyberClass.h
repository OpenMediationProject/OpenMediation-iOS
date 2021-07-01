// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMFyberClass_h
#define OMFyberClass_h

@interface IASDKCore : NSObject

@property (atomic, strong, nullable, readonly) NSString *appID;
- (void)initWithAppID:(NSString * _Nonnull)appID;



@end

typedef NS_ENUM(NSUInteger, IALogLevel) {
    /**
     *  @brief Disabled.
     */
    IALogLevelOff = 0,
    /**
     *  @brief Includes error logging.
     */
    IALogLevelError = 1,
    /**
     *  @brief Includes warnings and error logging.
     */
    IALogLevelWarn = 2,
    /**
     *  @brief Includes general info., warnings and error logging.
     */
    IALogLevelInfo = 3,
    /**
     *  @brief Includes debug information, general info., warnings and error logging.
     */
    IALogLevelDebug = 4,
    /**
     *  @brief Includes all types of logging.
     */
    IALogLevelVerbose = 5,
};

@interface IALogger : NSObject

/**
 *  @brief Sets IASDK logging level for:
 *
 *  1. Xcode console
 *
 *  2. Apple System Logs
 *
 *  @param logLevel log level
 */
+ (void)setLogLevel:(IALogLevel)logLevel;
+ (IALogLevel)logLevel:(IALogLevel)logLevel;

@end

#endif /* OMFyberClass_h */
