// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleNativeAd.h"

@implementation OMPangleNativeAd

- (instancetype)initWithNativeAd:(BUNativeAd*)nativeAd {
    if (self = [super init]) {
        _adObject = nativeAd;
        _title = nativeAd.data.AdTitle;
        _body = nativeAd.data.AdDescription;
        _iconUrl = nativeAd.data.icon.imageURL;
        _rating = nativeAd.data.score;
        _callToAction = nativeAd.data.buttonText;
        _nativeViewClass = @"OMPangleNativeView";
    }
    return self;
}

@end
