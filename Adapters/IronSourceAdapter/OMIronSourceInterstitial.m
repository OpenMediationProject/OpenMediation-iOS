// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceInterstitial.h"

@implementation OMIronSourceInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter
{
    if (self = [super init]) {
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]){
            _pid = [adParameter objectForKey:@"pid"];
            _appID = @"";
            [[OMIronSourceRouter sharedInstance] registerPidDelegate:_pid delegate:self];
        }
    }
    return self;
}

-(void)loadAd
{
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(loadISDemandOnlyInterstitial:)]){
        [IronSourceClass loadISDemandOnlyInterstitial:_pid];
    }
}

-(BOOL)isReady
{
    BOOL isReady = NO;
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if(IronSourceClass && [IronSourceClass respondsToSelector:@selector(hasISDemandOnlyInterstitial:)]){
        isReady = [IronSourceClass hasISDemandOnlyInterstitial:_pid];
    }
    return isReady;
}

- (void)show:(UIViewController *)vc
{
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if ([self isReady] && IronSourceClass && [IronSourceClass respondsToSelector:@selector(showISDemandOnlyInterstitial:instanceId:)]) {
        [IronSourceClass showISDemandOnlyInterstitial:vc instanceId:_pid];
    }
}


- (void)OMIronSourceDidload {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)OMIronSourceDidFailToLoad:(nonnull NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)OMIronSourceDidStart {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]){
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]){
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)OMIronSourceDidClick{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]){
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)OMIronSourceDidFinish{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]){
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)OMIronSourceDidReceiveReward {
    
}


- (void)OMIronSourceVideoEnd {
    
}

- (void)OMIronSourceDidFailToShow:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]){
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
}


@end
