// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralNativeAd.h"

@implementation OMMintegralNativeAd

-(instancetype)initWithMtgNativeAd:(MTGCampaign *)mtgCampaign withManager:(MTGNativeAdManager *)mtgManager withBidManager:(MTGBidNativeAdManager *)mtgBidManager {
    self = [super init];
    if (self) {
        _adObject = mtgCampaign;
        _mtgManager = mtgManager;
        _mtgBidManager = mtgBidManager;
        _title = [mtgCampaign appName];
        _body = [mtgCampaign appDesc];
        _iconUrl = [mtgCampaign iconUrl];
        _callToAction = [mtgCampaign adCall];
        _nativeViewClass = @"OMMintegralNativeView";
    }
    return self;
}

@end
