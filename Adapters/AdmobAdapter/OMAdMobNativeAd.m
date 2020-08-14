// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMobNativeAd.h"

@implementation OMAdMobNativeAd
- (instancetype)initWithGadNativeAd:(GADUnifiedNativeAd*)gadNativeAd {
    self = [super init];
    if (self) {
        _gadNativeAd = gadNativeAd;
        _title = [gadNativeAd headline];
        _body= [gadNativeAd body];
        id icon = [gadNativeAd icon];
        NSURL * url =(NSURL *) [icon imageURL];
        _iconUrl = [url absoluteString];
        _rating = [gadNativeAd starRating].doubleValue;
        _callToAction = [gadNativeAd callToAction];
        _nativeViewClass = @"OMAdMobNativeView";
    }
    return self;
}
@end
