// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHyBidNativeAd.h"

@implementation OMHyBidNativeAd

-(instancetype)initWithHybidNativeAd:(HyBidNativeAd *)hyBidNativeAd {
    self = [super init];
    if (self) {
        _hyBidNativeAd = hyBidNativeAd;
        _title = [hyBidNativeAd title];
        _body= [hyBidNativeAd body];
        _iconUrl = [hyBidNativeAd iconUrl];
        _rating = [hyBidNativeAd rating].doubleValue;
        _callToAction = [hyBidNativeAd callToActionTitle];
        _nativeViewClass = @"OMHyBidNativeView";
    }
    return self;
}

@end
