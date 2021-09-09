// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionNativeView.h"
#import "OMCrossPromotionExposureMonitor.h"

@implementation OMCrossPromotionNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:gesture];

    }
    return self;
}

- (void)setNativeAd:(OMCrossPromotionNativeAd *)nativeAd {
    _nativeAd = nativeAd;
    _campaign = _nativeAd.adObject;
    if(_mediaView) {
        _mediaView.nativeAd = _nativeAd;
    }
    [self addAdChoicesView];
    self.adChoicesView.image = [_campaign logoImage];
}

- (void)drawRect:(CGRect)rect {
    [[OMCrossPromotionExposureMonitor sharedInstance]addObserver:self forView:self];
    [super drawRect:rect];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [[OMCrossPromotionExposureMonitor sharedInstance]removeObserver:self];
}

- (void)observeView:(UIView*)view visible:(BOOL)visible {
    if(visible) {
        if(!_nativeAd.impr) {
             _nativeAd.impr  =YES;
             [self recordImpr];
         }
    }
}

- (void)recordImpr {
    if(_nativeAd && _nativeAd.adDelegate && [_nativeAd.adDelegate respondsToSelector:@selector(OMCrossPromotionNativeAdWillShow:)]) {
        [_nativeAd.adDelegate OMCrossPromotionNativeAdWillShow:_nativeAd];
    }
}

- (void)click {
    if(_nativeAd && _nativeAd.adDelegate && [_nativeAd.adDelegate respondsToSelector:@selector(OMCrossPromotionNativeAdDidClick:)]) {
        [_nativeAd.adDelegate OMCrossPromotionNativeAdDidClick:_nativeAd];
    }
}

- (void)adIconClick {
    [self.campaign iconClick];
}

- (void)addAdChoicesView {
    [self addSubview:self.adChoicesView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_adChoicesView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:16.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_adChoicesView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:16.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_adChoicesView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_adChoicesView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
}


- (UIImageView*)adChoicesView {
    if (!_adChoicesView) {
        _adChoicesView = [[UIImageView alloc] init];
        _adChoicesView.userInteractionEnabled = YES;
        _adChoicesView.translatesAutoresizingMaskIntoConstraints = NO;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adIconClick)];
        [_adChoicesView addGestureRecognizer:gesture];
    }
    return _adChoicesView;
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    [self bringSubviewToFront:self.adChoicesView];
}

- (void)setMediaViewWithFrame:(CGRect)frame {
    _mediaView = [[OMCrossPromotionNativeMediaView alloc]initWithFrame:frame];
}

@end
