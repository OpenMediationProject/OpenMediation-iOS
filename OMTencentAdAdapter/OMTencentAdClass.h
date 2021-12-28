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

#endif /* AdTimingGdtClass_h */
