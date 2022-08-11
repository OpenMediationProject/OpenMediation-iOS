// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef AdTimingGdtClass_h
#define AdTimingGdtClass_h
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GDTMediaPlayerStatus) {
    GDTMediaPlayerStatusInitial = 0,         // 初始状态
    GDTMediaPlayerStatusLoading = 1,         // 加载中
    GDTMediaPlayerStatusStarted = 2,         // 开始播放
    GDTMediaPlayerStatusPaused = 3,          // 用户行为导致暂停
    GDTMediaPlayerStatusError = 4,           // 播放出错
    GDTMediaPlayerStatusStoped = 5,          // 播放停止
    
    GDTMediaPlayerStatusWillStart = 10,      // 即将播放
};

typedef NS_ENUM(NSInteger, GDTAdBiddingLossReason) {
    GDTAdBiddingLossReasonLowPrice          = 1,        // 竞争力不足
    GDTAdBiddingLossReasonLoadTimeout       = 2,        // 返回超时
    GDTAdBiddingLossReasonNoAd              = 3,        // 无广告回包
    GDTAdBiddingLossReasonAdDataError       = 4,        // 回包不合法
    GDTAdBiddingLossReasonOther             = 10001     // 其他
};

@interface GDTSDKConfig : NSObject
+ (NSString *)sdkVersion;
/**
 SDK 注册接口，请在 app 初始化时调用。
 @param appId - 媒体ID
 
 @return 注册是否成功。
*/
+ (BOOL)registerAppId:(NSString *)appId;
/**
在播放音频时是否使用SDK内部对AVAudioSession设置的category及options，默认使用，若不使用，SDK内部不做任何处理，由调用方在展示广告时自行设置；
SDK设置的category为AVAudioSessionCategoryAmbient，options为AVAudioSessionCategoryOptionDuckOthers
*/
+ (void)enableDefaultAudioSessionSetting:(BOOL)enabled;
@end

@protocol GDTAdProtocol <NSObject>

@optional
- (NSDictionary *)extraInfo;

/**
 *  竞胜之后调用, 需要在调用广告 show 之前调用，旧的- (void)sendWinNotificationWithPrice:(NSInteger)price已废弃
 *
 *  @param winInfo 字典类型，支持的key有
 *  GDT_M_W_E_COST_PRICE：竞胜价格 (单位: 分)，值类型为NSNumber *
 *  GDT_M_W_H_LOSS_PRICE：最高失败出价，值类型为NSNumber  *
 *
 */
- (void)sendWinNotificationWithInfo:(NSDictionary *)winInfo;

/**
 *  竞败之后或未参竞调用，旧的- (void)sendLossNotificationWithWinnerPrice:(NSInteger)price lossReason:(GDTAdBiddingLossReason)reason winnerAdnID:(NSString *)adnID已废弃
 *
 *  @pararm lossInfo 竞败信息，字典类型，支持的key有
 *  GDT_M_L_WIN_PRICE ：竞胜价格 (单位: 分)，值类型为NSNumber *，选填
 *  GDT_M_L_LOSS_REASON ：优量汇广告竞败原因，竞败原因参考枚举GDTAdBiddingLossReason中的定义，值类型为NSNumber *，必填
 *  GDT_M_ADNID  ：竞胜方渠道ID，值类型为NSString *，必填
 */
- (void)sendLossNotificationWithInfo:(NSDictionary *)lossInfo;

@end

@protocol GDTAdDelegate <NSObject>

@optional
/**
  投诉成功回调
  @params ad 广告对象实例
 */
- (void)gdtAdComplainSuccess:(id)ad;

@end

#endif /* AdTimingGdtClass_h */
