// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleNativeView.h"
#import "OMPangleNative.h"

@implementation OMPangleNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        Class nativeAdViewClass = NSClassFromString(@"PAGLNativeAdRelatedView");
        if (nativeAdViewClass) {
            self.nativeView = [[nativeAdViewClass alloc]init];
            CGSize logoSize = CGSizeMake(20, 10);
            self.nativeView.logoADImageView.frame = CGRectMake(frame.size.width-2-logoSize.width, frame.size.height - logoSize.height, logoSize.width, logoSize.height);
            [self addSubview:self.nativeView.logoADImageView];
        }
    }
    return self;
}

- (void)setMediaViewWithFrame:(CGRect)frame {
    _mediaView = self.nativeView.mediaView;
    _mediaView.frame = frame;
}

- (void)setNativeAd:(OMPangleNativeAd*)nativeAd {
    _nativeAd = nativeAd;
    PAGLNativeAd *pagNativeAd = _nativeAd.adObject;
    [self.nativeView refreshWithNativeAd:pagNativeAd];
    [pagNativeAd registerContainer:self withClickableViews:nil];
}

@end
