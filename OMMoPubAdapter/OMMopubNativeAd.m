// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubNativeAd.h"

@implementation OMMopubNativeAd


- (instancetype)initWithMopubResponse:(MPNativeAd*)nativeResponse {
    
    self = [super init];
    if (self) {
        _nativeResponse = nativeResponse;
        _title = _nativeResponse.properties[@"title"];
        _body= _nativeResponse.properties[@"text"];
        _iconUrl = _nativeResponse.properties[@"iconimage"];
        _rating = [_nativeResponse.properties[@"starrating"]doubleValue];
        _callToAction = @"INSTALL";
        _nativeViewClass = @"OMMopubNativeView";
    }
    return self;
}

@end
