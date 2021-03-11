// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMobNativeView.h"
@implementation OMAdMobNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        Class admobNativeAdViewClass = NSClassFromString(@"GADNativeAdView");
        if (admobNativeAdViewClass) {
            _gadNativeView = [[admobNativeAdViewClass alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            if ([_gadNativeView respondsToSelector:@selector(setHeadlineView:)]) {
                UILabel *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
                [_gadNativeView setHeadlineView:headView];
                [_gadNativeView addSubview:headView];
                [self addConstraintEqualSuperView:headView];
            }

            [self addSubview:_gadNativeView];
            [self addConstraintEqualSuperView:_gadNativeView];
        }
    }
    return self;
}

- (void)setMediaViewWithFrame:(CGRect)frame {
    Class GADMediaViewClass = NSClassFromString(@"GADMediaView");
    if (GADMediaViewClass) {
        _mediaView = [[GADMediaViewClass alloc]initWithFrame:frame];
    }
    if (_gadNativeView) {
        _gadNativeView.mediaView = _mediaView;
    }
}

- (void)setNativeAd:(OMAdMobNativeAd*)nativeAd {
    _nativeAd = nativeAd;
    if (self.gadNativeView) {
        self.gadNativeView.nativeAd = _nativeAd.gadNativeAd;
        self.heightConstraint.active = NO;
    }
}

- (void)addSubview:(UIView *)view {
    if (_gadNativeView && view != _gadNativeView) {
        [_gadNativeView addSubview:view];
    } else {
        [super addSubview:view];
    }
}

- (void)addConstraintEqualSuperView:(UIView*)view {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *topCos = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [view.superview addConstraint:topCos];
    
    NSLayoutConstraint *bootomCos = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [view.superview addConstraint:bootomCos];
    
    NSLayoutConstraint *leftCos = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [view.superview addConstraint:leftCos];
    
    NSLayoutConstraint *rightCos = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [view.superview addConstraint:rightCos];
}

@end
