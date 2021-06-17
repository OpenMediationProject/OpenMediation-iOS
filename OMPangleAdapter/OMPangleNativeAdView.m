// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3


#import "OMPangleNativeAdView.h"

@implementation OMPangleNativeAdView

- (instancetype)initWithNativeAdView:(BUNativeExpressAdView *)expressAdView {
    if (self = [super initWithFrame:expressAdView.bounds]) {
        [self addSubview:expressAdView];
    }
    return self;
}

@end
