// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMAdTimingBannerClass.h"
#import "OMBannerCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdTimingBanner : UIView<OMBannerCustomEvent,AdTimingBidBannerDelegate>

@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
@property (nonatomic, strong) AdTimingBidBanner *banner;
@property (nonatomic, assign) BOOL impr;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAdWithBidPayload:(NSString *)bidPayload;

@end

NS_ASSUME_NONNULL_END
