// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdmostNative.h"

@implementation OMAdmostNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _uid = [adParameter objectForKey:@"uid"];
            _pid = [adParameter objectForKey:@"pid"];
            _controller = rootViewController;
        }
        _native.delegate = self;
    }
    return self;
}

- (void)loadAd {
    Class bannerClass = NSClassFromString(@"AMRBanner");
    if (bannerClass && [bannerClass respondsToSelector:@selector(bannerForZoneId:)]) {;
        _native = [bannerClass bannerForZoneId:_pid];
        _native.viewController = _controller;
        _native.customNativeSize = CGSizeMake(300, 120);
        _native.customeNativeXibName = [NSString stringWithFormat:@"AdmostCustomNative%@",_uid];
        _native.delegate = self;
    }
    if (_native && [_native respondsToSelector:@selector(loadBanner)]) {
        [_native loadBanner];
    }
}

#pragma mark - AMRBannerDelegate

- (void)didReceiveBanner:(AMRBanner *)banner {
    for (UIView *view in banner.bannerView.subviews) {
        [self addConstraintEqualSuperView:view];
    }
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":[NSNumber numberWithDouble:([banner.ecpm doubleValue]/100.0)],@"adObject":banner.bannerView} error:nil];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:banner.bannerView];
    }
}

- (void)didFailToReceiveBanner:(AMRBanner *)banner error:(AMRError *)error {
    NSError *loadError = [[NSError alloc] initWithDomain:@"com.openmediation.admostadapter" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:loadError];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:loadError];
    }
}

- (void)didClickBanner:(AMRBanner *)banner {
    if(_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
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
