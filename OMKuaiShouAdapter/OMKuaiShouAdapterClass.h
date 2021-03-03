// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMKuaiShouAdapterClass_h
#define OMKuaiShouAdapterClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

typedef NS_ENUM(NSInteger, KSAdShowDirection) {
    KSAdShowDirection_Vertical         =           0,
    KSAdShowDirection_Horizontal,
};


typedef NS_ENUM(NSInteger, KSAdInteractionType) {
    KSAdInteractionType_Unknown,
    KSAdInteractionType_App,
    KSAdInteractionType_Web,
    KSAdInteractionType_DeepLink,
};


@interface KSAd : NSObject

// 单位:分，只有视频资源下载成功后，这个才可能有值
@property (nonatomic, readonly) NSInteger ecpm;
/// 媒体二次议价, 单位分
- (void)setBidEcpm:(NSInteger)ecpm;

@end

@interface KSVideoAd : KSAd

@property (nonatomic, readonly) BOOL isValid;
@property (nonatomic, assign) BOOL shouldMuted;

- (void)loadAdData;
// direction 默认是 Vertical
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController direction:(KSAdShowDirection)direction;
// direction 默认是 Vertical
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController showScene:(nullable NSString *)showScene;
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController showScene:(nullable NSString *)showScene direction:(KSAdShowDirection)direction;



/*
 这个是播放异常的时候,此方法不会自动调用，可以在
 - (void)rewardedVideoAdDidPlayFinish:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error使用此方法
 */
- (void)closeVideoAdWhenPlayError;

// 是否是同一个有效广告
- (BOOL)isSameValidVideoAd:(nullable KSVideoAd *)ad;

@end

#endif /* OMKuaiShouAdapterClass_h */
