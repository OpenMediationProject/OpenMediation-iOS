// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMRewardedVideoAd.h"
#import "OMModelUmbrella.h"
#import "OMIcRequest.h"
#import "OMRewardedVideoCustomEvent.h"
#import "OMAdBasePrivate.h"
#import "OMInstanceContainer.h"
#import "OMMediations.h"

@interface OMTapjoyRewardedVideo : NSObject
@property (nonatomic, strong) id tapjoyPlacement;
@end

@interface OMAppLovinRewardedVideo : NSObject
@property (nonatomic, strong) id ad;
@end

@interface OMFacebookRewardedVideo : NSObject
@property (nonatomic, strong) id faceBookPlacement;
@end;

@interface OMRewardedVideoAd()<rewardedVideoCustomEventDelegate>
@property (nonatomic, strong) NSString *extraParams;
@end

@implementation OMRewardedVideoAd
- (instancetype)initWithPlacementID:(NSString*)placementID {
    if (self = [super initWithPlacementID:placementID size:[UIScreen mainScreen].bounds.size]) {
    }
    return self;
}


- (void)loadInstance:(NSString*)instanceID {
    OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
    if (instance) {
        NSString *mediationPid = instance.adnPlacementID;
        OMAdNetwork adnID = instance.adnID;
        NSString *instanceID = instance.instanceID;
        NSString *mediationName = [[OMConfig sharedInstance]adnName:adnID];
        if ([mediationName length]>0) {
            NSString *className = [NSString stringWithFormat:@"OM%@RewardedVideo",mediationName];
            Class adapterClass = NSClassFromString(className);
            if (adapterClass && [adapterClass conformsToProtocol:@protocol(OMRewardedVideoCustomEvent)] && [adapterClass instancesRespondToSelector:@selector(initWithParameter:)]) {
                id <OMRewardedVideoCustomEvent> videoAdapter = [[OMInstanceContainer sharedInstance]getInstance:instanceID block:^id {
                    id adapter = [[adapterClass alloc] initWithParameter:@{@"pid":mediationPid,@"appKey":[[OMConfig sharedInstance]adnAppKey:adnID] }];
                    return adapter;
                }] ;
                videoAdapter.delegate = self;
                [self.instanceAdapters setObject:videoAdapter forKey:instanceID];
            }
        }
    }
    [super loadInstance:instanceID];
}

- (void)loadAd {
    [super loadAd:OpenMediationAdFormatRewardedVideo actionType:OMLoadActionManualLoad];
}

- (void)preload {
    [self loadAd:OpenMediationAdFormatRewardedVideo actionType:OMLoadActionInit];
}

- (BOOL)isReady {
    return [super isReady];
}

- (void)show:(UIViewController*)viewController {
    [self show:viewController extraParams:@"" scene:@""];
}

- (void)show:(UIViewController*)viewController extraParams:(NSString*)extraParams scene:(NSString*)sceneName {
    if (![viewController isKindOfClass:[UIViewController class]]) {
        viewController = [UIViewController omRootViewController];
        OMLogW(@"rootViewController error, use default viewController")
    }
    self.showSceneID = [[OMConfig sharedInstance]getSceneIDWithSceneName:sceneName inAdUnit:self.placementID];
    OMLogD(@"video show pid = %@ scene name %@ scene id %@",self.placementID,(OM_STR_EMPTY(sceneName)?@"empty":sceneName),self.showSceneID);
    
    _extraParams = extraParams;
    if (self.adLoader && !OM_STR_EMPTY(self.adLoader.optimalFillInstance)) {
        id <OMRewardedVideoCustomEvent> videoAdapter = [self.instanceAdapters objectForKey:self.adLoader.optimalFillInstance];        
        if (videoAdapter && [videoAdapter respondsToSelector:@selector(show:)]) {
            [videoAdapter show:viewController];
        }
        [self showInstance:self.adLoader.optimalFillInstance];
        
    }
}


- (NSString*)placementID {
    return self.pid;
}


#pragma mark -- rewardedVideoCustomEventDelegate

- (void)omDidChangedAvailable:(BOOL)available {
    [super omDidChangedAvailable:available];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoChangedAvailability:newValue:)]) {
        [self.delegate rewardedVideoChangedAvailability:self newValue:available];
    }
}

- (void)rewardedVideoCustomEventDidOpen:(id<OMRewardedVideoCustomEvent>)adapter {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoDidOpen:)]) {
        [_delegate rewardedVideoDidOpen:self];
    }
}

- (void)rewardedVideoCustomEventDidFailToShow:(id<OMRewardedVideoCustomEvent>)adapter withError:(NSError*)error {
    [self adShowFail:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoDidFailToShow:error:)]) {
        [_delegate rewardedVideoDidFailToShow:self error:error];
    }
}

- (void)rewardedVideoCustomEventVideoStart:(id<OMRewardedVideoCustomEvent>)adapter {
    [self adshow:adapter];
    [self adVideoStart:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoDidStart:)]) {
        [_delegate rewardedVideoDidStart:self];
    }
}

- (void)rewardedVideoCustomEventVideoEnd:(id<OMRewardedVideoCustomEvent>)adapter {
    [self adVideoComplete:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoDidEnd:)]) {
        [_delegate rewardedVideoDidEnd:self];
    }
}

- (void)rewardedVideoCustomEventDidClick:(id<OMRewardedVideoCustomEvent>)adapter {
    
    [self adClick:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoDidClick:)]) {
        [_delegate rewardedVideoDidClick:self];
    }
}

- (void)rewardedVideoCustomEventDidReceiveReward:(id<OMRewardedVideoCustomEvent>)adapter {
    if (!OM_STR_EMPTY(_extraParams)) {
        NSString *instanceID = [self checkInstanceIDWithAdapter:adapter];
        [OMIcRequest postWithPid:self.pid instanceID:instanceID adnID:[[OMConfig sharedInstance] getInstanceAdNetwork:instanceID] sceneID:@"" extraParams:_extraParams];
        
    }
    [self adReceiveReward:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoDidReceiveReward:)]) {
        [_delegate rewardedVideoDidReceiveReward:self];
    }
}


- (void)rewardedVideoCustomEventDidClose:(id<OMRewardedVideoCustomEvent>)adapter {
    [self adClose:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoDidClose:)]) {
        [_delegate rewardedVideoDidClose:self];
    }
}

@end

