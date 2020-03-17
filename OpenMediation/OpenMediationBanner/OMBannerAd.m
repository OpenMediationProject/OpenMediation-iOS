// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMBannerAd.h"
#import "OMAdBasePrivate.h"
#import "OMConfig.h"
#import "OMBannerCustomEvent.h"
#import "OMToolUmbrella.h"
#import "OMMediations.h"
@implementation OMBannerAd

- (void)loadInstance:(NSString*)instanceID {
    OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
    if (instance) {
        NSString *mediationPid = instance.adnPlacementID;
        OMAdNetwork adnID = instance.adnID;
        NSString *instanceID = instance.instanceID;
        NSString *mediationName = [[OMConfig sharedInstance] adnName:adnID];
        if ([mediationName length]>0) {
            NSString *className = [NSString stringWithFormat:@"OM%@Banner",mediationName];
            Class adapterClass = NSClassFromString(className);
            if (adapterClass && [adapterClass conformsToProtocol:@protocol(OMBannerCustomEvent)] && [adapterClass instancesRespondToSelector:@selector(initWithFrame:adParameter:rootViewController:)]) {
                id <OMBannerCustomEvent> bannerAdapter = [[adapterClass alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height) adParameter:@{@"pid":mediationPid,@"appKey":[[OMConfig sharedInstance] adnAppKey:adnID]} rootViewController:self.rootViewController];
                if ([bannerAdapter respondsToSelector:@selector(setDelegate:)]) {
                    bannerAdapter.delegate = self;
                }
                [self.instanceAdapters setObject:bannerAdapter forKey:instanceID];
            }
        }
    }
    [super loadInstance:instanceID];
}

- (void)omDidLoad {
    if (self.adLoader && !OM_STR_EMPTY(self.adLoader.optimalFillInstance) && _delegate && [_delegate respondsToSelector:@selector(bannerDidLoad:)]) {
        [_delegate bannerDidLoad:self.adLoader.optimalFillInstance];
        [self showInstance:self.adLoader.optimalFillInstance];
        _impr = NO;
        UIView *bannerView = [self.instanceAdapters objectForKey:self.adLoader.optimalFillInstance];
        [[OMExposureMonitor sharedInstance]addObserver:self forView:bannerView];
    }

}

- (void)omDidFail:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerDidFailToLoadWithError:)]) {
        [_delegate bannerDidFailToLoadWithError:error];
    }
}

#pragma mark DelegateMethod

- (void)observeView:(UIView*)view visible:(BOOL)visible {
    if (visible) {
        if (!_impr) {
            _impr  =YES;
            [self bannerDidImprssion:view];
        }
    }

}

- (void)bannerDidImprssion:(UIView*)bannerAdapter {
    [self adshow:bannerAdapter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerWillExposure)]) {
        [self.delegate bannerWillExposure];
    }
}

- (void)bannerCustomEventDidClick:(id<OMBannerCustomEvent>)adapter {
    [self adClick:adapter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerDidClick)]) {
        [self.delegate bannerDidClick];
    }
}

- (void)bannerCustomEventWillPresentScreen:(id<OMBannerCustomEvent>)adapter {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerWillPresentScreen)]) {
        [self.delegate bannerWillPresentScreen];
    }
}

- (void)bannerCustomEventDismissScreen:(id<OMBannerCustomEvent>)adapter {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerDidDissmissScreen)]) {
        [self.delegate bannerDidDissmissScreen];
    }
}

- (void)bannerCustomEventWillLeaveApplication:(id<OMBannerCustomEvent>)adapter {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerWillLeaveApplication)]) {
        [self.delegate bannerWillLeaveApplication];
    }
}

@end
