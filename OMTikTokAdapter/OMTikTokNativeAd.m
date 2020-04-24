// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTikTokNativeAd.h"

@implementation OMTikTokNativeAd

- (instancetype)initWithNativeAd:(BUNativeAd*)nativeAd {
    if (self = [super init]) {
        _nativeAd = nativeAd;
        _title = nativeAd.data.AdTitle;
        _body = nativeAd.data.AdDescription;
        _iconUrl = nativeAd.data.icon.imageURL;
        _rating = nativeAd.data.score;
        _callToAction = nativeAd.data.buttonText;
        _nativeViewClass = @"OMTikTokNativeView";
    }
    return self;
}

@end
