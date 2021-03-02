// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMKuaiShouAdapterClass_h
#define OMKuaiShouAdapterClass_h

typedef NS_ENUM(NSInteger, KSAdSDKLogLevel) {
    KSAdSDKLogLevelAll      =       0,
    KSAdSDKLogLevelVerbose,  // 此类别的日记不会记录到日志文件中
    KSAdSDKLogLevelDebug,
    KSAdSDKLogLevelVerify,
    KSAdSDKLogLevelInfo,
    KSAdSDKLogLevelWarn,
    KSAdSDKLogLevelError,
    KSAdSDKLogLevelOff,
};

@interface KSAdSDKManager : NSObject
@property (nonatomic, readonly, class) NSString *SDKVersion;
+ (void)setAppId:(NSString *)appId;
@end

#endif /* OMKuaiShouAdapterClass_h */
