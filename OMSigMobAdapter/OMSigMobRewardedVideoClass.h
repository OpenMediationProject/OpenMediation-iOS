// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMSigMobRewardedVideoClass_h
#define OMSigMobRewardedVideoClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WindAdRequest;
@class WindRewardInfo;


@protocol WindRewardedVideoAdDelegate<NSObject>

@required

/**
 激励视频广告物料加载成功（此时isReady=YES）
 广告是否ready请以当前回调为准
 
 @param placementId 广告位Id
 */
- (void)onVideoAdLoadSuccess:(NSString *)placementId;


/**
 激励视频广告加载时发生错误
 
 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
- (void)onVideoError:(NSError *)error placementId:(NSString *)placementId;


/**
 激励视频广告关闭
 
 @param info WindRewardInfo里面包含一次广告关闭中的是否完整观看等参数
 @param placementId 广告位Id
 */
- (void)onVideoAdClosedWithInfo:(WindRewardInfo *)info placementId:(NSString *)placementId;

@optional




/**
 激励视频广告开始播放

 @param placementId 广告位Id
 */
- (void)onVideoAdPlayStart:(NSString *)placementId;



/**
 激励视频广告发生点击

 @param placementId 广告位Id
 */
- (void)onVideoAdClicked:(NSString *)placementId;



/**
 激励视频广告调用播放时发生错误
 
 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
- (void)onVideoAdPlayError:(NSError *)error placementId:(NSString *)placementId;

/**
 激励视频广告视频播关闭
 
 @param placementId 广告位Id
 */
- (void)onVideoAdPlayEnd:(NSString *)placementId;


/**
 激励视频广告AdServer返回广告(表示渠道有广告填充)

 @param placementId 广告位Id
 */
- (void)onVideoAdServerDidSuccess:(NSString *)placementId;


/**
 激励视频广告AdServer无广告返回(表示渠道无广告填充)
 
 @param placementId 广告位Id
 */
- (void)onVideoAdServerDidFail:(NSString *)placementId;


@end



@interface WindRewardedVideoAd : NSObject

@property (nonatomic,weak) id<WindRewardedVideoAdDelegate> delegate;

+ (instancetype)sharedInstance;

- (BOOL)isReady:(NSString *)placementId;

- (void)loadRequest:(WindAdRequest *)request withPlacementId:(NSString *)placementId;

- (BOOL)playAd:(UIViewController *)controller withPlacementId:(NSString *)placementId options:(NSDictionary *)options error:( NSError *__autoreleasing *)error;


@end

#endif /* OMSigMobRewardedVideoClass_h */
