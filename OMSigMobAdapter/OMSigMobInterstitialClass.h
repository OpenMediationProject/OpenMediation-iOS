// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMSigMobInterstitialClass_h
#define OMSigMobInterstitialClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WindAdRequest;

@protocol WindInterstitialAdDelegate <NSObject>

@required

/**
 全屏视频广告物料加载成功（此时isReady=YES）
 广告是否ready请以当前回调为准
 
 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdLoadSuccess:(NSString *)placementId;


/**
 全屏视频广告加载时发生错误
 
 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdError:(NSError *)error placementId:(NSString *)placementId;


/**
 全屏视频广告关闭
 
 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdClosed:(NSString *)placementId;



@optional




/**
 全屏视频广告开始播放

 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdPlayStart:(NSString *)placementId;



/**
 全屏视频广告发生点击

 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdClicked:(NSString *)placementId;



/**
 全屏视频广告调用播放时发生错误
 
 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdPlayError:(NSError *)error placementId:(NSString *)placementId;

/**
 全屏视频广告视频播关闭
 
 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdPlayEnd:(NSString *)placementId;


/**
 全屏视频广告AdServer返回广告(表示渠道有广告填充)

 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdServerDidSuccess:(NSString *)placementId;


/**
 全屏视频广告AdServer无广告返回(表示渠道无广告填充)
 
 @param placementId 广告位Id
 */
- (void)onSMInterstitialAdServerDidFail:(NSString *)placementId;

@end


@interface WindInterstitialAd : NSObject

@property (nonatomic,weak) id<WindInterstitialAdDelegate> delegate;

+ (instancetype)sharedInstance;

- (BOOL)isReady:(NSString *)placementId;

- (void)loadRequest:(WindAdRequest *)request withPlacementId:(NSString *)placementId;

- (BOOL)playAd:(UIViewController *)controller withPlacementId:(NSString *)placementId options:(NSDictionary *)options error:( NSError **)error;

@end


#endif /* OMSigMobInterstitialClass_h */
