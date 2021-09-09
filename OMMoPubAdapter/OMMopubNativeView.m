// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubNativeView.h"

@implementation OMMopubNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _mediaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:tap];
    
    }
    return self;
}

- (void)setMediaViewWithFrame:(CGRect)frame {
    _mediaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (void)setNativeAd:(OMMopubNativeAd*)nativeAd {
    _nativeAd = nativeAd;
    NSString *mainImageUrl = [_nativeAd.adObject.properties objectForKey:@"mainimage"];
    if (mainImageUrl) {
        NSURL *imageURL = [NSURL URLWithString:mainImageUrl];
        NSData *imageData = [[NSClassFromString(@"MPNativeCache") sharedCache]
            retrieveDataForKey:imageURL.absoluteString];
        if (imageData) {
            _mediaView.image = [UIImage imageWithData:imageData];
        }
    }
    
    if ([_nativeAd.adObject respondsToSelector:@selector(willAttachToView:withAdContentViews:)]) {
      [_nativeAd.adObject performSelector:@selector(willAttachToView:withAdContentViews:)
                      withObject:self
                      withObject:nil];
    } else {

    }
}

- (void)viewTapped:(UITapGestureRecognizer *)gr {
    if (_nativeAd.adObject) {
      [_nativeAd.adObject performSelector:@selector(adViewTapped)];
    }
}




@end
