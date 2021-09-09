// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubNativeAd.h"

@implementation OMMopubNativeAd


- (instancetype)initWithMopubResponse:(MPNativeAd*)nativeResponse {
    
    self = [super init];
    if (self) {
        _adObject =nativeResponse;
        _title = nativeResponse.properties[@"title"];
        _body= nativeResponse.properties[@"text"];
        _iconUrl = nativeResponse.properties[@"iconimage"];
        _rating = [nativeResponse.properties[@"starrating"]doubleValue];
        _callToAction = @"INSTALL";
        _nativeViewClass = @"OMMopubNativeView";
    }
    return self;
}

@end
