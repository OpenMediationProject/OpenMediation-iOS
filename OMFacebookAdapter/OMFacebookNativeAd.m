// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookNativeAd.h"

@implementation OMFacebookNativeAd
- (instancetype)initWithFBNativeAd:(FBNativeAd*)fbNativeAd {
    if (self = [super init]) {
        _fbNativeAd = fbNativeAd;
        _title = [fbNativeAd headline];
        _body = [fbNativeAd bodyText];
        FBAdImage *fbIcon = [fbNativeAd adChoicesIcon];
        _iconUrl = [NSString stringWithFormat:@"%@",[fbIcon url]];
        if ([fbNativeAd respondsToSelector:@selector(starRating)]) {
            struct FBAdStarRating star = [fbNativeAd starRating];
            _rating = star.value;
        }
        _callToAction = [fbNativeAd callToAction];
        _nativeViewClass = @"OMFacebookNativeView";
    }
    return self;
}
@end
