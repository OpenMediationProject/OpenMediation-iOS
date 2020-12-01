// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionAd.h"
#import "OpenMediationAdFormats.h"
#import "OMModelUmbrella.h"
#import "OMNetworkUmbrella.h"
#import "OMCrossPromotionCustomEvent.h"
#import "OMInstanceContainer.h"
#import "OMAdBasePrivate.h"


@interface OMCrossPromotionAd () <crossPromotionCustomEventDelegate>

@end

@implementation OMCrossPromotionAd

- (instancetype)initWithPlacementID:(NSString *)placementID {
    if (self = [super initWithPlacementID:placementID size:[UIScreen mainScreen].bounds.size]) {
    }
    return self;
}

- (void)loadInstance:(NSString*)instanceID {
    OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
    if(instance) {
        NSString *mediationPid = instance.adnPlacementID;
        OMAdNetwork adnID = instance.adnID;
        NSString *instanceID = instance.instanceID;
        NSString *mediationName = [[OMConfig sharedInstance]adnName:adnID];
        if ([mediationName length]>0) {
            NSString *className = [NSString stringWithFormat:@"OM%@CP",mediationName];
            Class adapterClass = NSClassFromString(className);
            if (adapterClass && [adapterClass conformsToProtocol:@protocol(OMCrossPromotionCustomEvent)] && [adapterClass instancesRespondToSelector:@selector(initWithParameter:)]) {
                id <OMCrossPromotionCustomEvent> promotionAdapter = [[OMInstanceContainer sharedInstance]getInstance:instanceID block:^id {
                    id adapter = [[adapterClass alloc] initWithParameter:@{@"pid":mediationPid,@"appKey":[[OMConfig sharedInstance]adnAppKey:adnID] }];
                    return adapter;
                }] ;
                promotionAdapter.delegate = self;
                [self.instanceAdapters setObject:promotionAdapter forKey:instanceID];
            }
        }
    }
    [super loadInstance:instanceID];
}

- (void)loadAd {
    [super loadAd:OpenMediationAdFormatCrossPromotion actionType:OMLoadActionManualLoad];
}

- (void)preload{
    [self loadAd:OpenMediationAdFormatCrossPromotion actionType:OMLoadActionInit];
}

- (BOOL)isReady{
    return [super isReady];
}

- (NSString*)placementID{
    return self.pid;
}

- (void)showAdWithSize:(CGSize)adSize screenPoint:(CGPoint)scaleXY xAngle:(CGFloat) xAngle zAngle:(CGFloat)zAngle scene:(NSString*)sceneName {
    
    self.showSceneID = [[OMConfig sharedInstance] getSceneIDWithSceneName:sceneName inAdUnit:self.placementID];
    OMLogD(@"promotion show pid = %@ scene name %@ scene id %@",self.placementID,(OM_STR_EMPTY(sceneName)?@"empty":sceneName),self.showSceneID);
    
    if(self.adLoader && !OM_STR_EMPTY(self.adLoader.optimalFillInstance)) {
        id <OMCrossPromotionCustomEvent> promotionAdapter = [self.instanceAdapters objectForKey:self.adLoader.optimalFillInstance];
        if(promotionAdapter && [promotionAdapter respondsToSelector:@selector(setShowSceneID:)]) {
            [(OMAdBase*)promotionAdapter setShowSceneID:self.showSceneID];
        }

        if(promotionAdapter && [promotionAdapter respondsToSelector:@selector(showAdWithSize:screenPoint:xAngle:zAngle:scene:)]) {
            [promotionAdapter showAdWithSize:adSize screenPoint:scaleXY xAngle:xAngle zAngle:zAngle scene:sceneName];
        }
        [self showInstance:self.adLoader.optimalFillInstance];

    }
}

- (void)hideAd {
    NSArray *cpAdapters = self.instanceAdapters.allValues;
    for (id <OMCrossPromotionCustomEvent> promotionAdapter in cpAdapters) {
        if(promotionAdapter && [promotionAdapter respondsToSelector:@selector(hideAd)]) {
            [promotionAdapter hideAd];
        }
    }
}

- (void)omDidChangedAvailable:(BOOL)available{
    [super omDidChangedAvailable:available];
    if (self.delegate && [self.delegate respondsToSelector:@selector(promotionChangedAvailability:newValue:)]) {
        [self.delegate promotionChangedAvailability:self newValue:available];
    }
}

#pragma mark -- crossPromotionCustomEventDelegate

- (void)promotionCustomEventWillAppear:(id<OMCrossPromotionCustomEvent>)adapter {
    [self adshow:adapter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(promotionWillAppear:)]) {
        [self.delegate promotionWillAppear:self];
    }
}

- (void)promotionCustomEventDidClick:(id<OMCrossPromotionCustomEvent>)adapter {
    [self adClick:adapter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(promotionDidClick:)]) {
        [self.delegate promotionDidClick:self];
    }
}

- (void)promotionCustomEventDidDisAppear:(id<OMCrossPromotionCustomEvent>)adapter {
    [self adClose:adapter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(promotionDidDisappear:)]) {
        [self.delegate promotionDidDisappear:self];
    }
}

@end
