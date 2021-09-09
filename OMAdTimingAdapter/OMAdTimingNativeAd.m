// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingNativeAd.h"

@interface OMAdTimingNativeAd()

@property (nonatomic, strong) id<OMMediatedNativeAd> mediatedAd;
@property (nonatomic, assign) BOOL rendering;
@property (nonatomic, assign) BOOL impr;
@end


@implementation OMAdTimingNativeAd

- (instancetype)initWithAdTimingNativeAd:(AdTimingBidNativeAd*)adtNativeAd {
    if (self = [super init]) {
        _adObject = adtNativeAd;
        _title = [adtNativeAd title];
        _body = [adtNativeAd body];
        _iconUrl = [NSString stringWithFormat:@"%@",[adtNativeAd iconUrl]];
        _callToAction = [adtNativeAd callToAction];
        _rating = [adtNativeAd rating];
        _nativeViewClass = @"OMAdTimingNativeView";
    }
    return self;
}

@end
