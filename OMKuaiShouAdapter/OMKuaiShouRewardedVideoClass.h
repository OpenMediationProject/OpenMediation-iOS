// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMKuaiShouRewardedVideoClass_h
#define OMKuaiShouRewardedVideoClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

@class KSRewardedVideoModel;
@protocol KSRewardedVideoAdDelegate;

@interface KSRewardedVideoAd : KSVideoAd
@property (nonatomic, strong) KSRewardedVideoModel *rewardedVideoModel;
@property (nonatomic, weak, nullable) id<KSRewardedVideoAdDelegate> delegate;

- (instancetype)initWithPosId:(NSString *)posId rewardedVideoModel:(KSRewardedVideoModel *)rewardedVideoModel;

@end

@protocol KSRewardedVideoAdDelegate <NSObject>
@optional
/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardedVideoAdDidLoad:(KSRewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error;
/**
 This method is called when cached successfully.
 */
- (void)rewardedVideoAdVideoDidLoad:(KSRewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when video ad slot will be showing.
 */
- (void)rewardedVideoAdWillVisible:(KSRewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when video ad slot has been shown.
 */
- (void)rewardedVideoAdDidVisible:(KSRewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when video ad is about to close.
 */
- (void)rewardedVideoAdWillClose:(KSRewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when video ad is closed.
 */
- (void)rewardedVideoAdDidClose:(KSRewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad is clicked.
 */
- (void)rewardedVideoAdDidClick:(KSRewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)rewardedVideoAdDidPlayFinish:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error;
/**
 This method is called when the user clicked skip button.
 */
- (void)rewardedVideoAdDidClickSkip:(KSRewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when the video begin to play.
 */
- (void)rewardedVideoAdStartPlay:(KSRewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when the user close video ad.
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd hasReward:(BOOL)hasReward;
@end

NS_ASSUME_NONNULL_END

#endif /* OMKuaiShouRewardedVideoClass_h */
