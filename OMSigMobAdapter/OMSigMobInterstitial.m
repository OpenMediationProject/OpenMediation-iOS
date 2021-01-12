// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSigMobInterstitial.h"

@implementation OMSigMobInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMSigMobRouter sharedInstance]registerPidDelegate:_pid delegate:self];
    }
    return self;
}

-(void)loadAd {
    [[OMSigMobRouter sharedInstance] loadInterstitialWithPlacmentID:_pid];
}

-(BOOL)isReady {
    return [[OMSigMobRouter sharedInstance] isInterstitialReady:_pid];;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [[OMSigMobRouter sharedInstance] showInterstitialAd:_pid withVC:vc];
    }
}


- (void)OMSigMobDidload {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)OMSigMobDidFailToLoad:(nonnull NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)OMSigMobDidStart {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)OMSigMobDidClick{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)OMSigMobDidClose{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)OMSigMobVideoEnd {
    
}

- (void)OMSigMobDidFailToShow:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
}

@end
