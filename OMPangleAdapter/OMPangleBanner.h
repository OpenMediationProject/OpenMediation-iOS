// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMPangleClass.h"
#import "OMPangleBannerClass.h"
#import "OMBannerCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMPangleBanner : UIView<OMBannerCustomEvent,BUNativeExpressBannerViewDelegate,PAGBannerAdDelegate>

@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
@property (nonatomic, strong) BUNativeExpressBannerView *bannerAdView;
// 海外
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, strong) UIView *pagBannerView;
@property (nonatomic, strong) PAGBannerAd *pagBannerAd;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAd;


@end

NS_ASSUME_NONNULL_END
