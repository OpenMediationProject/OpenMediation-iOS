// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdNativeAd.h"

@implementation OMTencentAdNativeAd

-(instancetype)initWithGdtDataObject:(GDTUnifiedNativeAdDataObject *)gdtDataObject {
    if (self = [super init]) {
        _adObject = gdtDataObject;
        _title = [gdtDataObject title];
        _body= [gdtDataObject desc];
        _iconUrl = [gdtDataObject iconUrl];
        _rating = [gdtDataObject appRating];
        _callToAction = [gdtDataObject callToAction];
        if (!_callToAction) {
            _callToAction = gdtDataObject.isAppAd?@"INSTALL":@"OPEN";
        }
        _nativeViewClass = @"OMTencentAdNativeView";
    }
    return self;
}

@end
