// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMostNativeAdView.h"

@interface OMAdMostNative : NSObject
- (void)didShowBanner:(AMRBanner*)banner;
@end

@implementation OMAdMostNativeAdView

- (instancetype)initWithAdmostNativeAd:(AMRBanner*)nativeAd {
    if (self = [super initWithFrame:nativeAd.bannerView.bounds]) {
        self.nativeAd = nativeAd;
        [self addSubview:nativeAd.bannerView];
    }
    return self;
}

- (void)observeView:(UIView*)view visible:(BOOL)visible {
    if (visible) {
        if (!_impr) {
            _impr  =YES;
            SEL showSelector =  NSSelectorFromString(@"didShowBanner:");
            if (self.nativeAd && self.nativeAd.delegate && [self.nativeAd.delegate respondsToSelector:showSelector] ) {
                OMAdMostNative *native = (OMAdMostNative*)self.nativeAd.delegate;
                [native didShowBanner:self.nativeAd];
            }
        }
    }
}

@end
