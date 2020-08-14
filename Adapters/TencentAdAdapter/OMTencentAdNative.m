// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdNative.h"
#import "OMTencentAdNativeAd.h"


@implementation OMTencentAdNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController{
    if (self = [super init]) {
        Class gdtNativeAdClass = NSClassFromString(@"GDTUnifiedNativeAd");
        if (gdtNativeAdClass && adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _gdtNativeAd = [[gdtNativeAdClass alloc] initWithPlacementId:[adParameter objectForKey:@"pid"]];
            _gdtNativeAd.delegate = self;
            _rootVC = rootViewController;
        }
    }
    return self;
}


- (void)loadAd{
    if(_gdtNativeAd){
        [_gdtNativeAd loadAdWithAdCount:1];
    }
}

#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> * _Nullable)unifiedNativeAdDataObjects error:(NSError * _Nullable)error{
    __weak __typeof(self) weakSelf = self;
    if (!error && unifiedNativeAdDataObjects.count > 0) {
        weakSelf.currentAdData = unifiedNativeAdDataObjects[0];
        OMTencentAdNativeAd *gdtNativeAd = [[OMTencentAdNativeAd alloc] initWithGdtDataObject:unifiedNativeAdDataObjects[0]];
        gdtNativeAd.adLoader = self;
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
            [weakSelf.delegate customEvent:weakSelf didLoadAd:gdtNativeAd];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
                [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
            }
        });
    }
}

#pragma mark - GDTUnifiedNativeAdViewDelegate
// 广告曝光回调
- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView{
    if(_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]){
        [_delegate nativeCustomEventWillShow:self];
    }
}


//广告点击回调
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView{
    if(_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]){
        [_delegate nativeCustomEventDidClick:self];
    }
}



//广告详情页关闭回调
- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView{
    
}


// 当点击应用下载或者广告调用系统程序打开时调用
- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView{
    
}

// 广告详情页面即将展示回调
- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView{
    
}


// 视频广告播放状态更改回调
// nativeExpressAdView GDTUnifiedNativeAdView 实例
// status 视频广告播放状态
// userInfo 视频广告信息
- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo{
    
}

@end
