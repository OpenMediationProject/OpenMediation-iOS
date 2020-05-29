// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSplashAd.h"
#import "OMConfig.h"
#import "OMAdBasePrivate.h"
#import "OMSplashCustomEvent.h"
#import "OMToolUmbrella.h"
#import "OMMediations.h"

@implementation OMSplashAd

- (void)loadInstance:(NSString *)instanceID {
    OMInstance *instance = [[OMConfig sharedInstance] getInstanceByinstanceID:instanceID];
    if (instance) {
        NSString *mediationPid = instance.adnPlacementID;
        OMAdNetwork adnID = instance.adnID;
        NSString *instanceID = instance.instanceID;
        NSString *mediationName = [[OMConfig sharedInstance] adnName:adnID];
        if ([mediationName length] > 0) {
            NSString *className = [NSString stringWithFormat:@"OM%@Splash",mediationName];
            Class adapterClass = NSClassFromString(className);
            if (adapterClass && [adapterClass conformsToProtocol:@protocol(OMSplashCustomEvent)] && [adapterClass instancesRespondToSelector:@selector(initWithParameter:adSize:)]) {
                id <OMSplashCustomEvent> splashAdapter = [[adapterClass alloc] initWithParameter:@{@"pid":mediationPid,@"appKey":[[OMConfig sharedInstance] adnAppKey:adnID]} adSize:self.size];
                
                if ([splashAdapter respondsToSelector:@selector(setDelegate:)]) {
                    splashAdapter.delegate = self;
                }
                [self.instanceAdapters setObject:splashAdapter forKey:instanceID];
            }
        }
    }
    [super loadInstance:instanceID];
}

- (BOOL)isReady {
    return [super isReady];
}

- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView {
    if (self.adLoader && !OM_STR_EMPTY(self.adLoader.optimalFillInstance)) {
        id <OMSplashCustomEvent> splashAdapter = [self.instanceAdapters objectForKey:self.adLoader.optimalFillInstance];
        if (window && splashAdapter && [splashAdapter respondsToSelector:@selector(showWithWindow:customView:)]) {
            [splashAdapter showWithWindow:window customView:customView];
        }
        [self showInstance:self.adLoader.optimalFillInstance];
    }
}

- (void)omDidLoad {
    if (self.adLoader && !OM_STR_EMPTY(self.adLoader.optimalFillInstance) && _delegate && [_delegate respondsToSelector:@selector(splashDidLoad:)]) {
        [_delegate splashDidLoad:self.adLoader.optimalFillInstance];
    }
}

- (void)omDidFail:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(splashDidFailToLoadWithError:)]) {
        [_delegate splashDidFailToLoadWithError:error];
    }
}

- (void)splashCustomEventDidShow:(id<OMSplashCustomEvent>)adapter {
    [self adshow:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(splashDidShow)]) {
        [self.delegate splashDidShow];
    }
}

- (void)splashCustomEventDidClick:(id<OMSplashCustomEvent>)adapter {
    [self adClick:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(splashDidClick)]) {
        [self.delegate splashDidClick];
    }
}

- (void)splashCustomEventDidClose:(id<OMSplashCustomEvent>)adapter {
    [self adClose:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(splashDidClose)]) {
        [self.delegate splashDidClose];
    }
}

- (void)splashCustomEventFailToShow:(id<OMSplashCustomEvent>)adapter error:(NSError *)error {
    [self adShowFail:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(splashDidFailToShowWithError:)]) {
        [self.delegate splashDidFailToShowWithError:error];
    }
}

@end
