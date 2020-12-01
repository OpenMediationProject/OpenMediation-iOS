// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMNative.h"
#import "OMModelUmbrella.h"
#import "OMNativeCustomEvent.h"
#import "OMAdBasePrivate.h"
#import "OMMediatedNativeAd.h"
#import "OMEventManager.h"
#import "OMMediations.h"

@interface OMNativeAd : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *callToAction;
@property (nonatomic, assign) double rating;
- (instancetype)initWithMediatedAd:(id<OMMediatedNativeAd>)mediatedAd;
@end

@interface OMNative()<nativeCustomEventDelegate>

@end

@implementation OMNative
- (instancetype)initWithPlacementID:(NSString*)placementID {
    return [self initWithPlacementID:placementID rootViewController:[UIViewController omRootViewController]];
}

- (instancetype)initWithPlacementID:(NSString*)placementID rootViewController:(UIViewController*)viewController {
    if (self = [super initWithPlacementID:placementID size:CGSizeMake(1200, 627) rootViewController:viewController]) {
        
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
            NSString *nativeClassName = [NSString stringWithFormat:@"OM%@Native",mediationName];
            Class adapterClass = NSClassFromString(nativeClassName);
            if (adapterClass && [adapterClass instancesRespondToSelector:@selector(initWithParameter:rootVC:)]) {
                id <OMNativeCustomEvent> interstitialAdapter = [[adapterClass alloc] initWithParameter:@{@"pid":mediationPid,@"appKey":[[OMConfig sharedInstance]adnAppKey:adnID] }rootVC:self.rootViewController];
                interstitialAdapter.delegate = self;
                [self.instanceAdapters setObject:interstitialAdapter forKey:instanceID];
            }
        }
    }
    [super loadInstance:instanceID];
}

- (void)loadAd {
    [super loadAd:OpenMediationAdFormatNative actionType:OMLoadActionManualLoad];
    [self addNativeEvent:CALLED_LOAD extraData:nil];
}

- (NSString*)placementID{
    return self.pid;
}

- (void)nativeCustomEventWillShow:(id<OMNativeCustomEvent>)adapter {
    [self showInstance:self.adLoader.optimalFillInstance];
    [self adshow:adapter];
    [self omWillExposure];
}


- (void)omDidLoad {
    if (!OM_STR_EMPTY(self.adLoader.optimalFillInstance)) {
        id<OMMediatedNativeAd> mediatedNativeAd = [self.didLoadAdObjects objectForKey:self.adLoader.optimalFillInstance];
        if (mediatedNativeAd && [mediatedNativeAd conformsToProtocol:@protocol(OMMediatedNativeAd)]) {
            OMNativeAd *nativeAd = [[OMNativeAd alloc]initWithMediatedAd:mediatedNativeAd];
            if (self.adLoader && self.adLoader.optimalFillInstance && [self.didLoadAdObjects objectForKey:self.adLoader.optimalFillInstance] && _delegate && [_delegate respondsToSelector:@selector(omNative:didLoad:)]) {
                [self addNativeEvent:CALLBACK_LOAD_SUCCESS extraData:nil];
                [_delegate omNative:self didLoad:nativeAd];
            }
        }
    }
    
}
- (void)omDidFail:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(omNative:didFailWithError:)]) {
        [self addNativeEvent:CALLBACK_LOAD_ERROR extraData:@{@"msg":OM_SAFE_STRING([error description])}];
        [_delegate omNative:self didFailWithError:error];
    }

}

- (void)nativeCustomEventDidClick:(id<OMNativeCustomEvent>)adapter {
    [self adClick:adapter];
    [self omDidClick];
}

- (void)omWillExposure{
    if (_delegate && [_delegate respondsToSelector:@selector(omNativeWillExposure:)]) {
        [self addNativeEvent:CALLBACK_PRESENT_SCREEN extraData:nil];
        [_delegate omNativeWillExposure:self];
    }
}

- (void)omDidClick{
    if (_delegate && [_delegate respondsToSelector:@selector(omNativeDidClick:)]) {
        [self addNativeEvent:CALLBACK_CLICK extraData:nil];
        [_delegate omNativeDidClick:self];
    }

}

- (void)addNativeEvent:(NSInteger)eventID extraData:data {
    NSMutableDictionary *wrapperData = [NSMutableDictionary dictionary];
    if (data) {
        [wrapperData addEntriesFromDictionary:data];
    }
    [wrapperData setObject:[NSNumber omStr2Number:self.placementID] forKey:@"pid"];
    [[OMEventManager sharedInstance] addEvent:eventID extraData:wrapperData];
}

@end
