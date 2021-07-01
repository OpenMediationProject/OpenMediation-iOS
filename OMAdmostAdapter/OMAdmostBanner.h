// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMBannerCustomEvent.h"
#import "OMAdmostBannerClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdmostBanner : UIView <OMBannerCustomEvent,AMRBannerDelegate>

@property (nonatomic, strong) AMRBanner *banner;
@property (nonatomic, copy) NSString *pid;
@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
@property (nonatomic, weak) id<AdmostBidDelegate> bidDelegate;

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
