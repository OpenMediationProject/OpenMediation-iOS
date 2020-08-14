// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMBannerCustomEvent.h"
#import "OMIronSourceClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMIronSourceBanner : UIView<OMBannerCustomEvent,ISBannerDelegate>

@property (nonatomic, weak) id<bannerCustomEventDelegate> delegate;
@property (nonatomic, strong, nullable) ISBannerView *bannerView;
@property (nonatomic, weak) UIViewController *showVC;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
