// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionNativeMediaView.h"
#import "OMToolUmbrella.h"

@implementation OMCrossPromotionNativeMediaView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.imgView];
        [_imgView addConstraintEqualSuperView];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)setNativeAd:(OMCrossPromotionNativeAd *)nativeAd {
    _nativeAd  = nativeAd;
    _imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[nativeAd.adObject mainImgCachePath]]];
}

- (void)click {
    if(_nativeAd && _nativeAd.adDelegate && [_nativeAd.adDelegate respondsToSelector:@selector(OMCrossPromotionNativeAdDidClick:)]) {
        [_nativeAd.adDelegate OMCrossPromotionNativeAdDidClick:_nativeAd];
    }
}
@end
