// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMNativeAdView.h"
#import "OpenMediationConstant.h"
//#import "OMNativeViewCustomEvent.h"

@implementation OMNativeAdView

- (instancetype)initWithMediatedAdView:(UIView *)mediatedAdView {
    self = [super initWithFrame:mediatedAdView.bounds];
    if (self) {
        [self addSubview:(UIView *)mediatedAdView];
    }
    return self;
}

@end

