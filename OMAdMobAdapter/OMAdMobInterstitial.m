#import "OMAdMobAdapter.h"
#import "OMAdMobInterstitial.h"

@implementation OMAdMobInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }

    }
    return self;
}
- (void)loadAd {
    Class GADInterstitialClass = NSClassFromString(@"GADInterstitial");
    if (GADInterstitialClass && [GADInterstitialClass respondsToSelector:@selector(shimmedClass)]) {
        GADInterstitialClass = [GADInterstitialClass shimmedClass];
    }
    Class GADRequestClass = NSClassFromString(@"GADRequest");
    if (GADRequestClass && [GADRequestClass respondsToSelector:@selector(shimmedClass)]) {
        GADRequestClass = [GADRequestClass shimmedClass];
    }
    if (GADInterstitialClass && [GADInterstitialClass instancesRespondToSelector:@selector(initWithAdUnitID:)] && GADRequestClass && [GADRequestClass respondsToSelector:@selector(request)]) {
        _admobInterstitial = [[GADInterstitialClass alloc] initWithAdUnitID:_pid];
        _admobInterstitial.delegate = self;
        GADRequest *request  = [GADRequestClass request];
        if (![OMAdMobAdapter npaAd] && NSClassFromString(@"GADExtras")) {
            GADExtras *extras = [[NSClassFromString(@"GADExtras") alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }
        [_admobInterstitial loadRequest:request];
        
    }
}

- (BOOL)isReady{
    return _ready;
}

- (void)show:(UIViewController*)vc{
    [_admobInterstitial presentFromRootViewController:vc];
    _ready = NO;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    _ready = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
    [_delegate customEvent:self didFailToLoadWithError:error];
}
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        NSError *error = [NSError errorWithDomain:@"com.admob.interstitial" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"interstitialDidFailToPresentScreen"}];
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    _admobInterstitial = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

@end
