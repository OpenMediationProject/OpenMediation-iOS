// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "BannerViewController.h"

@implementation BannerViewController

- (void)viewDidLoad {
    self.title = @"Banner";
    self.adFormat = OpenMediationAdFormatBanner;
    [super viewDidLoad];
    
}

- (void)loadAd {
    if (!_banner) {
        _banner = [[OMBanner alloc] initWithBannerType:OMBannerTypeDefault placementID:self.loadID];
        [_banner addLayoutAttribute:OMBannerLayoutAttributeHorizontally constant:0];
        [_banner addLayoutAttribute:OMBannerLayoutAttributeVertically constant:0];
        _banner.delegate = self;
        [self.view addSubview:_banner];
    }
    
    [_banner loadAndShow];
}

- (void)removeItemAction {
    [super removeItemAction];
    [_banner removeFromSuperview];
    _banner = nil;
}

- (void)omBannerDidLoad:(OMBanner *)banner {
    [self showLog:@"banner did load"];
}

/// Sent after an OMBanner fails to load the ad.
- (void)omBanner:(OMBanner *)banner didFailWithError:(NSError *)error {
    [self showLog:@"banner load failed"];
}

/// Sent immediately before the impression of an OMBanner object will be logged.
- (void)omBannerWillExposure:(OMBanner *)banner {
    [self showLog:@"banner impression"];
}

/// Sent after an ad has been clicked by the person.
- (void)omBannerDidClick:(OMBanner *)banner {
    [self showLog:@"banner click"];
}

/// Sent when a banner is about to present a full screen content
- (void)omBannerWillPresentScreen:(OMBanner *)banner {
    [self showLog:@"banner present full screen content"];
}

/// Sent after a full screen content has been dismissed.
- (void)omBannerDidDismissScreen:(OMBanner *)banner {
    [self showLog:@"banner full screen content dismiss"];
}

 /// Sent when a user would be taken out of the application context.
- (void)omBannerWillLeaveApplication:(OMBanner *)banner {
    [self showLog:@"banner leave application"];
}
@end
