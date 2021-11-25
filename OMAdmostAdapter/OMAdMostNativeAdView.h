// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMAdmostBannerClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface OMAdMostNativeAdView : UIView
@property (nonatomic, strong) AMRBanner *nativeAd;
@property (nonatomic, assign) BOOL impr;

- (instancetype)initWithAdmostNativeAd:(AMRBanner*)nativeAd;

@end

NS_ASSUME_NONNULL_END
