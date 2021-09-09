// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdNativeView.h"
#import "OMTencentAdNative.h"
@implementation OMTencentAdNativeView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        Class gdtNativeAdViewClass = NSClassFromString(@"GDTUnifiedNativeAdView");
        if (gdtNativeAdViewClass) {
            _gdtNativeView = [[gdtNativeAdViewClass alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [self addSubview:_gdtNativeView];
            [self addConstraintEqualSuperView:_gdtNativeView];
        }
    }
    return self;
}

- (void)setMediaViewWithFrame:(CGRect)frame{
    CGSize viewSize = frame.size;
    _mediaView = [[UIView alloc]initWithFrame:frame];
    _gdtMediaView = _gdtNativeView.mediaView;
    _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    
    [_mediaView addSubview:_mainImageView];
    
    if (_gdtMediaView) {
        [_gdtMediaView removeFromSuperview];
        _gdtMediaView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        [_mediaView addSubview:_gdtMediaView];
    }
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width/3.0, viewSize.height)];
    _midImageView = [[UIImageView alloc]initWithFrame:CGRectMake(viewSize.width/3.0, 0, viewSize.width/3.0, viewSize.height)];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(viewSize.width/3.0*2.0, 0, viewSize.width/3.0, viewSize.height)];
    [_mediaView addSubview:_leftImageView];
    [_mediaView addSubview:_midImageView];
    [_mediaView addSubview:_rightImageView];

}

- (void)setNativeAd:(OMTencentAdNativeAd *)nativeAd{
    _nativeAd = nativeAd;
    GDTUnifiedNativeAdDataObject *gdtDataObject = _nativeAd.adObject;
    NSURL *imageURL = [NSURL URLWithString:gdtDataObject.imageUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mainImageView.image = [UIImage imageWithData:imageData];
        });
    });

    if (gdtDataObject.isVideoAd || gdtDataObject.isVastAd) {
        self.gdtMediaView.hidden = NO;
    } else {
        self.gdtMediaView.hidden = YES;
    }
    
    if (gdtDataObject.isThreeImgsAd) {
        self.mainImageView.hidden = YES;
        self.leftImageView.hidden = NO;
        self.midImageView.hidden = NO;
        self.rightImageView.hidden = NO;
        NSURL *leftURL = [NSURL URLWithString:gdtDataObject.mediaUrlList[0]];
        NSURL *midURL = [NSURL URLWithString:gdtDataObject.mediaUrlList[1]];
        NSURL *rightURL = [NSURL URLWithString:gdtDataObject.mediaUrlList[2]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *leftData = [NSData dataWithContentsOfURL:leftURL];
            NSData *midData = [NSData dataWithContentsOfURL:midURL];
            NSData *rightData = [NSData dataWithContentsOfURL:rightURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.leftImageView.image = [UIImage imageWithData:leftData];
                self.midImageView.image = [UIImage imageWithData:midData];
                self.rightImageView.image = [UIImage imageWithData:rightData];
            });
        });
    } else {
        self.mainImageView.hidden = NO;
        self.leftImageView.hidden = YES;
        self.midImageView.hidden = YES;
        self.rightImageView.hidden = YES;
    }
    
    OMTencentAdNative *adLoader = (OMTencentAdNative*)_nativeAd.adLoader;
    if (adLoader) {
        _gdtNativeView.viewController = adLoader.rootVC;
        _gdtNativeView.delegate = adLoader;
    }
    
    
    if ([_gdtNativeView respondsToSelector:@selector(registerDataObject:clickableViews:)]) {
        [_gdtNativeView registerDataObject:_nativeAd.adObject clickableViews:@[self.gdtNativeView]];
    }
}

- (void)addSubview:(UIView *)view{
    if(_gdtNativeView && view != _gdtNativeView) {
        [_gdtNativeView addSubview:view];
    }else{
        [super addSubview:view];
    }
}

- (void)setClickableViews:(NSArray*)clickableViews {

    [_gdtNativeView unregisterDataObject];
    if ([_gdtNativeView respondsToSelector:@selector(registerDataObject:clickableViews:)]) {
        [_gdtNativeView registerDataObject:_nativeAd.adObject clickableViews:clickableViews];
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
