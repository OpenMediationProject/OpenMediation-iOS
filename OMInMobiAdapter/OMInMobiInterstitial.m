// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3


#import "OMInMobiInterstitial.h"

@implementation OMInMobiInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

- (void)loadAd {
    Class interstitialClass = NSClassFromString(@"IMInterstitial");
    if (interstitialClass && [interstitialClass instancesRespondToSelector:@selector(initWithPlacementId:)] && !_interstitial) {
        _interstitial = [[interstitialClass alloc] initWithPlacementId:[_pid longLongValue]];
        _interstitial.delegate = self;
    }
    [_interstitial load];
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    Class interstitialClass = NSClassFromString(@"IMInterstitial");
    if (interstitialClass && [interstitialClass instancesRespondToSelector:@selector(initWithPlacementId:)] && !_interstitial) {
        _interstitial = [[interstitialClass alloc] initWithPlacementId:[_pid longLongValue]];
        _interstitial.delegate = self;
    }
    [_interstitial load:[bidPayload dataUsingEncoding:NSUTF8StringEncoding]];
}

- (BOOL)isReady {
    BOOL ready = NO;
    if (_interstitial && [_interstitial respondsToSelector:@selector(isReady)]) {
        ready = [_interstitial isReady];
    }
    return ready;
}

- (void)show:(UIViewController*)vc {
    if(self.interstitial && [self isReady] && [_interstitial respondsToSelector:@selector(showFromViewController:)]) {
        [_interstitial showFromViewController:vc];
    }
}

#pragma mark - IMInterstitialDelegate


-(void)interstitial:(IMInterstitial*)interstitial didReceiveWithMetaInfo:(IMAdMetaInfo*)metaInfo {
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":[NSNumber numberWithDouble:[metaInfo getBid]]} error:nil];
    }
}

-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus *)error {
    NSError *loadError = [[NSError alloc] initWithDomain:@"com.openmediation.inmobiadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:loadError];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:loadError];
    }
}

-(void)interstitialDidPresent:(IMInterstitial*)interstitial {
    
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

-(void)interstitial:(IMInterstitial*)interstitial didFailToPresentWithError:(IMRequestStatus*)error {
    NSError *failError = [[NSError alloc] initWithDomain:@"com.openmediation.inmobiadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
    
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:failError];
    }
}

-(void)interstitialWillDismiss:(IMInterstitial*)interstitial {
    
}

-(void)interstitialDidDismiss:(IMInterstitial*)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

-(void)interstitial:(IMInterstitial*)interstitial didInteractWithParams:(NSDictionary*)params {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

@end
