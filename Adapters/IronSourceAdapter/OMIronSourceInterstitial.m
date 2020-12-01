// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceAdapter.h"
#import "OMIronSourceInterstitial.h"

@implementation OMIronSourceInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter
{
    if (self = [super init]) {
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            if ([OMIronSourceAdapter mediationAPI]) {
                Class IronSourceClass = NSClassFromString(@"IronSource");
                if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(setInterstitialDelegate:)]) {
                    [IronSourceClass setInterstitialDelegate:self];
                }
            } else {
                [[OMIronSourceRouter sharedInstance] registerPidDelegate:_pid delegate:self];
            }

        }
    }
    return self;
}

-(void)loadAd
{
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if ([OMIronSourceAdapter mediationAPI]) {
        if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(loadInterstitial)]) {
            [IronSourceClass loadInterstitial];
        }
    } else {
        if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(loadISDemandOnlyInterstitial:)]) {
            [IronSourceClass loadISDemandOnlyInterstitial:_pid];
        }
    }

}

-(BOOL)isReady
{
    BOOL isReady = NO;
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if ([OMIronSourceAdapter mediationAPI]) {
        if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(hasInterstitial)]) {
            isReady = [IronSourceClass hasInterstitial];
        }
    } else {
        if(IronSourceClass && [IronSourceClass respondsToSelector:@selector(hasISDemandOnlyInterstitial:)]) {
            isReady = [IronSourceClass hasISDemandOnlyInterstitial:_pid];
        }
    }

    return isReady;
}

- (void)show:(UIViewController *)vc
{
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if ([self isReady]) {
        if ([OMIronSourceAdapter mediationAPI]) {
            if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(showInterstitialWithViewController:placement:)]) {
                [IronSourceClass showInterstitialWithViewController:vc placement:_pid];
            }
        } else {
            if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(showISDemandOnlyInterstitial:instanceId:)]) {
                [IronSourceClass showISDemandOnlyInterstitial:vc instanceId:_pid];
            }
        }
        
    }
}

#pragma mark - DemandOnlyEvent

- (void)OMIronSourceDidload {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)OMIronSourceDidFailToLoad:(nonnull NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)OMIronSourceDidStart {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)OMIronSourceDidClick{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)OMIronSourceDidFinish{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)OMIronSourceDidReceiveReward {
    
}


- (void)OMIronSourceVideoEnd {
    
}

- (void)OMIronSourceDidFailToShow:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
}

#pragma mark - ISInterstitialDelegate

-(void)interstitialDidLoad {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

-(void)interstitialDidShow {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

-(void)interstitialDidFailToShowWithError:(NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
}

-(void)didClickInterstitial {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

-(void)interstitialDidClose {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

-(void)interstitialDidOpen {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
}

-(void)interstitialDidFailToLoadWithError:(NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}
@end
