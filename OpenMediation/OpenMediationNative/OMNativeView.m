// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMNativeView.h"
#import "OMToolUmbrella.h"
#import "OMNativeViewCustomEvent.h"

@interface OMFacebookNativeView : UIView
- (void)setClickableViews:(NSArray*)clickableViews;
@end

@interface OMNativeAd : NSObject
@property (nonatomic, strong) id<OMMediatedNativeAd> mediatedAd;
@property (nonatomic, assign) BOOL rendering;
@end

@interface OMNativeView()
@property (nonatomic, strong) UIView *currentNativeView;
@property (nonatomic, strong) UIView *currentMediaView;
@property (nonatomic, strong) NSMutableArray *addedSubviews;
@end


@implementation OMNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _addedSubviews = [NSMutableArray array];
        
    }
    return self;
}

- (void)setNativeAd:(OMNativeAd *)nativeAd {
    if (nativeAd.rendering) {
        OMLogE(@"Native ad already rendered");
        return;
    }
    nativeAd.rendering = YES;
    _nativeAd = nativeAd;
    [_nativeAdView removeFromSuperview];
    [_currentNativeView removeFromSuperview];
    
    if (_nativeAd.mediatedAd && [_nativeAd.mediatedAd.nativeViewClass length]>0) {
        Class nativeViewClass = NSClassFromString(_nativeAd.mediatedAd.nativeViewClass);
        if (nativeViewClass && [nativeViewClass conformsToProtocol:@protocol(OMNativeViewCustomEvent)]) {
            _currentNativeView = [[nativeViewClass alloc]initWithFrame:self.bounds];
            [self addSubview:_currentNativeView];
            [self sendSubviewToBack:_currentNativeView];
            [_currentNativeView addConstraintEqualSuperView];
            for (UIView *view in _addedSubviews) {
                [view removeFromSuperview];
                [_currentNativeView addSubview:view];
            }
            
            [_currentMediaView removeFromSuperview];
            id<OMNativeViewCustomEvent> customEventNativeView = (id<OMNativeViewCustomEvent>)_currentNativeView;
            if (_mediaView && _mediaView.superview) {
                [customEventNativeView setMediaViewWithFrame:_mediaView.bounds];
                _currentMediaView = customEventNativeView.mediaView;
                [_mediaView addSubview:_currentMediaView];
                [_currentMediaView addConstraintEqualSuperView];
            }
            [customEventNativeView setNativeAd:nativeAd.mediatedAd];
            

        }
    }
}


- (void)setMediaView:(OMNativeMediaView *)mediaView {
    [_mediaView removeFromSuperview];
    _mediaView = mediaView;
}

-(void)setNativeAdView:(OMNativeAdView *)nativeAdView {
    [_nativeAdView removeFromSuperview];
    _nativeAdView = nativeAdView;
    [self addSubview:(UIView *)nativeAdView];
}

- (void)addSubview:(UIView *)view {
    if (view != _currentNativeView && view != _nativeAdView) {
        [_addedSubviews addObject:view];
        if (_currentNativeView) {
            [_currentNativeView addSubview:view];
        } else {
            [super addSubview:view];
        }
    } else {
        [super addSubview:view];
    }

}


- (void)setClickableViews:(NSArray<UIView *> *)clickableViews {
    
    Class nativeViewClass = NSClassFromString(_nativeAd.mediatedAd.nativeViewClass);
    if (nativeViewClass && [nativeViewClass instancesRespondToSelector:@selector(setClickableViews:)]) {
        [((OMFacebookNativeView*)_currentNativeView)setClickableViews:clickableViews];
    }
}


@end
