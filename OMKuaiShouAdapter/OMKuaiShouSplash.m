//
//  OMKsAdSplash.m
//  OpenMediationDemo
//
//  Created by M on 2021/1/26.
//  Copyright © 2021 AdTiming. All rights reserved.
//

#import "OMKsAdSplash.h"

@implementation OMKsAdSplash

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            _pid = @"5637000003";
        }
    }
    return self;
}

- (void)loadAd {
    Class KSSplashClass = NSClassFromString(@"KSAdSplashManager");
    if (KSSplashClass && [KSSplashClass respondsToSelector:@selector(loadSplash)]) {
        KSSplashClass.posId = _pid;
        KSSplashClass.interactDelegate = self;
        [KSSplashClass loadSplash];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.adReadyFlag = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                [self.delegate customEvent:self didLoadAd:nil];
            }
        });
    }
}


- (BOOL)isReady{
    return self.adReadyFlag;
}

- (void)showWithWindow:(UIWindow *)window customView:(nonnull UIView *)customView {
    Class KSSplashClass = NSClassFromString(@"KSAdSplashManager");
    if (KSSplashClass && [KSSplashClass respondsToSelector:@selector(checkSplashv2:)]) {
        [KSAdSplashManager checkSplashv2:^(KSAdSplashViewController * _Nonnull splashViewController, NSError * _Nullable error) {
            if (splashViewController) {
                [window.rootViewController presentViewController:splashViewController animated:YES completion:nil];
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(splashCustomEventFailToShow:error:)]) {
                    [self.delegate splashCustomEventFailToShow:self error:error];
                }
            }
        }];
    }
}


- (void)ksad_splashAdDidShow {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidShow:)]) {
        [_delegate splashCustomEventDidShow:self];
    }
}

- (void)ksad_splashAdClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClick:)]) {
        [_delegate splashCustomEventDidClick:self];
    }
}


- (void)ksad_splashAdVideoDidStartPlay {
    
}


- (void)ksad_splashAdVideoFailedToPlay:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventFailToShow:error:)]) {
        [_delegate splashCustomEventFailToShow:self error:error];
    }
}


- (void)ksad_splashAdDismiss:(BOOL)converted {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClose:)]) {
        [_delegate splashCustomEventDidClose:self];
    }
}

@end
