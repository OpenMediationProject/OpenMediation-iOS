// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingNativeView.h"
#import "OMNativeViewCustomEvent.h"
#import "OMAdTimingNativeClass.h"
#import <UIKit/UIKit.h>

@interface OMAdTimingNativeAd()

@end


@implementation OMAdTimingNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        Class adtimingNativeClass = NSClassFromString(@"AdTimingNativeView");
        if (adtimingNativeClass) {
            _adtNativeView = [[adtimingNativeClass alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

            [self addSubview:_adtNativeView];
            [self addConstraintEqualSuperView:_adtNativeView];
        }
    }
    return self;
}

- (void)setMediaViewWithFrame:(CGRect)frame {
    Class adtMediaViewClass = NSClassFromString(@"AdTimingNativeMediaView");
    if (adtMediaViewClass) {
        _mediaView = [[adtMediaViewClass alloc]initWithFrame:frame];
    }
    if (_adtNativeView) {
        _adtNativeView.mediaView = _mediaView;
        [_adtNativeView addSubview:_mediaView];
    }
}

- (void)setNativeAd:(OMAdTimingNativeAd*)nativeAd {
    _nativeAd = nativeAd;
    if (self.adtNativeView) {
        self.adtNativeView.nativeAd = _nativeAd.adtNativeAd;
    }
}

- (void)addSubview:(UIView *)view {
    if (_adtNativeView && view != _adtNativeView) {
        [_adtNativeView addSubview:view];
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
