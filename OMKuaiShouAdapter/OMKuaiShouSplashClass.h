//
//  OMKsAdSplashClass.h
//  OpenMediation
//
//  Created by M on 2021/1/26.
//  Copyright © 2021 AdTiming. All rights reserved.
//

#ifndef OMKsAdSplashClass_h
#define OMKsAdSplashClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSAdShowDirection) {
    KSAdShowDirection_Vertical         =           0,
    KSAdShowDirection_Horizontal,
};

@class KSAdSplashViewController;
@class KSAdSDKError;

@protocol KSAdSplashInteractDelegate <NSObject>
@optional
/**
 * 闪屏广告展示
 */
- (void)ksad_splashAdDidShow;
/**
 * 闪屏广告点击转化
 */
- (void)ksad_splashAdClicked;
/**
 * 视频闪屏广告开始播放
 */
- (void)ksad_splashAdVideoDidStartPlay;
/**
 * 视频闪屏广告播放失败
 */
- (void)ksad_splashAdVideoFailedToPlay:(NSError *)error;
/**
 * 视频闪屏广告跳过
 */
- (void)ksad_splashAdVideoDidSkipped:(NSTimeInterval)playDuration;
/**
 * 闪屏广告关闭，需要在这个方法里关闭闪屏页面
 * @param converted      是否转化
 */
- (void)ksad_splashAdDismiss:(BOOL)converted;
/**
 * 转化控制器容器，如果未实现则默认闪屏页面的上级控制器
 */
- (UIViewController *)ksad_splashAdConversionRootVC;

@end

@interface KSAdSplashViewController : UIViewController

// 显示方向，需要在viewDidLoad前设置
@property (nonatomic, assign) KSAdShowDirection showDirection;

@end

@interface KSAdSplashManager : NSObject

/// 需要在didFinishLaunching中设置posId
@property (nonatomic, copy, class) NSString *posId;
/// 闪屏交互代理
@property (nonatomic, weak, class) id<KSAdSplashInteractDelegate> interactDelegate;
/// 是否有本地缓存广告
@property (nonatomic, assign, readonly, class) BOOL hasCachedSplash DEPRECATED_MSG_ATTRIBUTE("Deprecated, will always return YES");

/**
 * @brief 获取闪屏信息并缓存
 */
+ (void)loadSplash;
/**
 * @brief   校验本地缓存广告
 * @param   callback    校验回调，如果有可展示广告会返回splashViewController，否则为空
 */
+ (void)checkSplash:(void (^)(KSAdSplashViewController * _Nullable splashViewController))callback;
/**
 * @brief   校验本地缓存广告
 * @param   callback    校验回调，如果有可展示广告会返回splashViewController，否则为空,
 */
+ (void)checkSplashv2:(void (^)(KSAdSplashViewController * _Nullable splashViewController, NSError * _Nullable error))callback;
/**
 * @brief   校验本地缓存广告
 * @param   timeoutInterval 超时时间，单位s，建议不少于3，否则影响展示率
 * @param   callback        校验回调，如果有可展示广告会返回splashViewController，否则为空
 */
+ (void)checkSplashWithTimeout:(NSTimeInterval)timeoutInterval completion:(void (^)(KSAdSplashViewController * _Nullable splashViewController))callback;
/**
 * @brief   校验本地缓存广告
 * @param   timeoutInterval 超时时间，单位s，建议不少于3，否则影响展示率
 * @param   callback        校验回调，如果有可展示广告会返回splashViewController，否则为空
 */
+ (void)checkSplashWithTimeoutv2:(NSTimeInterval)timeoutInterval completion:(void (^)(KSAdSplashViewController * _Nullable splashViewController, NSError * _Nullable error))callback;

@end

NS_ASSUME_NONNULL_END

#endif /* OMKsAdSplashClass_h */
