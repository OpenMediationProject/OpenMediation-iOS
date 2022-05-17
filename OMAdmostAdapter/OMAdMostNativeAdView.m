// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMostNativeAdView.h"

@implementation OMAdMostNativeAdView

- (instancetype)initWithAdmostNativeAd:(AMRBanner*)nativeAd {
    if (self = [super initWithFrame:nativeAd.bannerView.bounds]) {
        self.nativeAd = nativeAd;
        [self addSubview:nativeAd.bannerView];
    }
    return self;
}

@end
