// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionNativeAd.h"
#import "OMToolUmbrella.h"

@implementation OMCrossPromotionNativeAd

- (instancetype)initWithCampaign:(OMCrossPromotionCampaign *)campaign {
    if (self = [super init]) {
        _campaign = campaign;
        _title = OM_SAFE_STRING(campaign.model.app[@"title"]);
        _body = campaign.model.descn;
        _iconUrl = OM_SAFE_STRING(campaign.model.app[@"icon"]);
        _callToAction = @"INSTALL";
        _rating = [campaign.model.app[@"rating"] floatValue];
        _nativeViewClass = @"OMCrossPromotionNativeView";
    }
    return self;
}

- (void)showAd:(UIViewController*)rootViewController {
    [_campaign clickAndShowAd:rootViewController sceneID:@""];
}

@end
