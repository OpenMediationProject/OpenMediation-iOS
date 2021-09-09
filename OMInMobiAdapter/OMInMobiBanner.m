// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMInMobiBanner.h"

@implementation OMInMobiBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        Class bannerClass = NSClassFromString(@"IMBanner");
        if (bannerClass && [adParameter isKindOfClass:[NSDictionary class]] && bannerClass && [bannerClass instancesRespondToSelector:@selector(initWithFrame:placementId:)]) {
            _pid = [adParameter objectForKey:@"pid"];
            _banner = [[bannerClass alloc] initWithFrame:frame placementId:[_pid longLongValue]];
            [self addSubview:self.banner];
        }
        _banner.delegate = self;
    }
    return self;
}

- (void)loadAd {
    if (_banner && [_banner respondsToSelector:@selector(load)]) {
        [_banner load];
    }
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    if (_banner && [_banner respondsToSelector:@selector(load:)]) {
        [_banner load:[bidPayload dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

#pragma mark - IMBannerDelegate

- (void)banner:(IMBanner*)banner didReceiveWithMetaInfo:(IMAdMetaInfo*)info {
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":[NSNumber numberWithDouble:[info getBid]]} error:nil];
    }

}
- (void)bannerDidFinishLoading:(IMBanner *)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}
- (void)banner:(IMBanner *)banner didFailToLoadWithError:(IMRequestStatus *)error {
    NSError *loadError = [[NSError alloc] initWithDomain:@"com.openmediation.inmobiadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:loadError];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:loadError];
    }
}
- (void)bannerWillPresentScreen:(IMBanner *)banner {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]) {
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)bannerDidDismissScreen:(IMBanner *)banner {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]) {
        [_delegate bannerCustomEventDismissScreen:self];
    }
}
- (void)userWillLeaveApplicationFromBanner:(IMBanner *)banner {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}
-(void)banner:(IMBanner *)banner didInteractWithParams:(NSDictionary *)params{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

@end
