// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleNativeView.h"

@implementation OMPangleNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        Class relatedViewClass = NSClassFromString(@"BUNativeAdRelatedView");
        if (relatedViewClass) {
            _relatedView = [[relatedViewClass alloc] init];
        }
    }
    return self;
}

- (void)setMediaViewWithFrame:(CGRect)frame {
    CGSize viewSize = frame.size;
    _mediaView = [[UIView alloc]initWithFrame:frame];
    _videoView = _relatedView.videoAdView;
    _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    
    [_mediaView addSubview:_mainImageView];
    
    if (_videoView) {
        [_videoView removeFromSuperview];
        _videoView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        [_mediaView addSubview:_videoView];
    }
}

- (void)setNativeAd:(OMPangleNativeAd*)nativeAd {
    _nativeAd = nativeAd;
    BUNativeAd *buAd = nativeAd.adObject;
    if (buAd.data.imageMode == BUFeedVideoAdModeImage) {
        id <BUVideoAdViewDelegate> temp = (id <BUVideoAdViewDelegate>) buAd.delegate;
        self.relatedView.videoAdView.delegate = temp;
        self.relatedView.videoAdView.rootViewController = buAd.rootViewController;
        [_relatedView refreshData:buAd];
        self.videoView.hidden = NO;
        self.mainImageView.hidden = YES;

    } else {
        if (buAd.data.imageAry.count > 0) {
            BUImage *image = buAd.data.imageAry.firstObject;
            if (image.imageURL.length > 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageURL]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.mainImageView.image = [UIImage imageWithData:imageData];
                    });
                });
            }
        }
        self.videoView.hidden = YES;
        self.mainImageView.hidden = NO;
    }
    
    if (buAd && [buAd respondsToSelector:@selector(registerContainer:withClickableViews:)]) {
        [buAd registerContainer:self withClickableViews:@[self,self.mainImageView,self.videoView]];
    }
}

@end
