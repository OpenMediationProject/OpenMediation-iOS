// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPubNativeNativeView.h"

@implementation OMPubNativeNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)setMediaViewWithFrame:(CGRect)frame {
    _mediaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)setNativeAd:(OMPubNativeNativeAd*)nativeAd {
    _nativeAd = nativeAd;
    if (nativeAd.adObject.bannerUrl) {
        NSURL *imageURL = [NSURL URLWithString:nativeAd.adObject.bannerUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mediaView.image = [UIImage imageWithData:imageData];
            });
        });
    }
    if ([_nativeAd.adObject respondsToSelector:@selector(startTrackingView:withDelegate:)]) {
        [_nativeAd.adObject startTrackingView:_mediaView withDelegate:nativeAd.adObject.delegate];
    }
}

@end
