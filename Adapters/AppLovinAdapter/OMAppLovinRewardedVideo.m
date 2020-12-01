// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAppLovinRewardedVideo.h"
#import "OMAppLovinAdapter.h"



@implementation OMAppLovinRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}


- (void)loadAd {
    Class appLovinAdClass = NSClassFromString(@"ALIncentivizedInterstitialAd");
    if (appLovinAdClass && [[appLovinAdClass alloc] respondsToSelector:@selector(initWithZoneIdentifier:sdk:)] && !_alAd && [OMAppLovinAdapter alShareSdk] && [_pid length]>0) {
        _alAd = [[appLovinAdClass alloc] initWithZoneIdentifier:_pid sdk:[OMAppLovinAdapter alShareSdk]];
        _alAd.adDisplayDelegate = self;
        _alAd.adVideoPlaybackDelegate = self;
    }     
    if (_alAd && [_alAd respondsToSelector:@selector(preloadAndNotify:)]) {
        [_alAd preloadAndNotify:self];
    }
}

- (BOOL)isReady {
    if (_alAd && [_alAd respondsToSelector:@selector(isReadyForDisplay)]) {
        return [_alAd isReadyForDisplay];
    }else
        return NO;
}

- (void)show:(UIViewController*)vc {
    if(_alAd && [_alAd respondsToSelector:@selector(showAd:andNotify:)] && _ad) {
        [_alAd showAd:_ad andNotify:nil];
    }
}

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    _ad = ad;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:[NSError errorWithDomain:@"applovin" code:code userInfo:[NSDictionary dictionary]]];
    }
}

#pragma mark - Ad Display Delegate

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
}

- (void)videoPlaybackBeganInAd:(ALAd *)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}


- (void)videoPlaybackEndedInAd:(ALAd *)ad atPlaybackPercent:(NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched {
    if (wasFullyWatched) {
        if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
            [_delegate rewardedVideoCustomEventDidReceiveReward:self];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}



- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}
@end
