// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef AdTimingGdtClass_h
#define AdTimingGdtClass_h

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
