// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMPubNativeClass.h"
#import "OMBannerCustomEvent.h"
#import "OMPubNativeClass.h"
#import "OMBidCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMPubNativeBanner : UIView<OMBannerCustomEvent,HyBidAdViewDelegate>
@property (nonatomic, strong) HyBidAdView *bannerAdView;
@property (nonatomic, copy) NSString *pid;
@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
@property (nonatomic, weak) id<OMBidCustomEventDelegate> bidDelegate;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAd;
@end

NS_ASSUME_NONNULL_END
