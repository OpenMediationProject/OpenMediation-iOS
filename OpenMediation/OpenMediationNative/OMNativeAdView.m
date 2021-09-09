// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMNativeAdView.h"
#import "OpenMediationConstant.h"
#import "OMMediatedNativeAd.h"
#import "OMBidResponse.h"

@interface OMNativeAdView()
@property (nonatomic, strong) NSString *instanceID;
@property (nonatomic, strong) NSObject *adapter;
@property (nonatomic, strong) OMBidResponse *bidResponse;
@end

@implementation OMNativeAdView

- (instancetype)initWithMediatedAdView:(UIView *)mediatedAdView {
    self = [super initWithFrame:mediatedAdView.bounds];
    if (self) {
        [self addSubview:(UIView *)mediatedAdView];
        [self addConstraintEqualSuperView:mediatedAdView];
    }
    return self;
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

