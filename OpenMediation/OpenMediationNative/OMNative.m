// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMNative.h"
#import "OMModelUmbrella.h"
#import "OMNativeCustomEvent.h"
#import "OMAdBasePrivate.h"
#import "OMMediatedNativeAd.h"
#import "OMEventManager.h"
#import "OMMediations.h"
#import "OMInstanceContainer.h"

@interface OMNativeAd : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *callToAction;
@property (nonatomic, assign) double rating;
@property (nonatomic, strong) NSString *instanceID;
@property (nonatomic, strong) OMBidResponse *bidResponse;
@property (nonatomic, strong) NSObject *adapter;
- (instancetype)initWithMediatedAd:(id<OMMediatedNativeAd>)mediatedAd;
@end

@interface OMNativeAdView : NSObject
@property (nonatomic, strong) NSString *instanceID;
@property (nonatomic, strong) NSObject *adapter;
@property (nonatomic, strong) OMBidResponse *bidResponse;
- (instancetype)initWithMediatedAdView:(UIView *)mediatedAdView;
@end

@interface OMNative()<nativeCustomEventDelegate>
@property (nonatomic, strong) NSMapTable *adnNativeAdMap; // key adn nativeAd, value OMNativeAd
@end

@implementation OMNative
- (instancetype)initWithPlacementID:(NSString*)placementID {
    return [self initWithPlacementID:placementID rootViewController:[UIViewController omRootViewController]];
}

- (instancetype)initWithPlacementID:(NSString*)placementID rootViewController:(UIViewController*)viewController {
    if (self = [super initWithPlacementID:placementID size:CGSizeMake(1200, 627) rootViewController:viewController]) {
        _adnNativeAdMap = [NSMapTable weakToWeakObjectsMapTable];
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
                id <OMNativeCustomEvent> nativeAdapter = [self.instanceAdapters objectForKey:instanceID];
                if (!nativeAdapter) {
                    nativeAdapter = [[adapterClass alloc] initWithParameter:@{@"pid":mediationPid,@"appKey":[[OMConfig sharedInstance]adnAppKey:adnID] }rootVC:self.rootViewController];
                    nativeAdapter.delegate = self;
                    if ([nativeAdapter respondsToSelector:@selector(setBidDelegate:)]) {
                        [nativeAdapter performSelector:@selector(setBidDelegate:) withObject:self];
                    }
                    [self.instanceAdapters setObject:nativeAdapter forKey:instanceID];
                }
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

- (void)omDidLoad {
    if (!OM_STR_EMPTY(self.adLoader.optimalFillInstance)) {
        id<OMMediatedNativeAd> mediatedNativeAd = [self.didLoadAdObjects objectForKey:self.adLoader.optimalFillInstance];
        if (mediatedNativeAd && [mediatedNativeAd conformsToProtocol:@protocol(OMMediatedNativeAd)]) {
            OMNativeAd *nativeAd = [[OMNativeAd alloc]initWithMediatedAd:mediatedNativeAd];
            nativeAd.instanceID = self.adLoader.optimalFillInstance;
            nativeAd.adapter = [self.instanceAdapters objectForKey:nativeAd.instanceID];
            nativeAd.bidResponse = [self.loadedInstanceBidResponses objectForKey:nativeAd.instanceID];
            [_adnNativeAdMap setObject:nativeAd forKey:[mediatedNativeAd performSelector:@selector(adObject)]];
            
            [self.loadedInstanceBidResponses removeObjectForKey:nativeAd.instanceID];
            if (_delegate && [_delegate respondsToSelector:@selector(omNative:didLoad:)]) {
                [self addNativeEvent:CALLBACK_LOAD_SUCCESS extraData:nil];
                [_delegate omNative:self didLoad:nativeAd];
            }
        } else if (mediatedNativeAd && [mediatedNativeAd isKindOfClass:[UIView class]]) {
            OMNativeAdView *nativeAdView = [[OMNativeAdView alloc] initWithMediatedAdView:(UIView*)mediatedNativeAd];
            nativeAdView.instanceID = self.adLoader.optimalFillInstance;
            nativeAdView.adapter = [self.instanceAdapters objectForKey:nativeAdView.instanceID];
            nativeAdView.bidResponse = [self.loadedInstanceBidResponses objectForKey:nativeAdView.instanceID];
            [_adnNativeAdMap setObject:nativeAdView forKey:mediatedNativeAd];
            
            [self.loadedInstanceBidResponses removeObjectForKey:nativeAdView.instanceID];
            if (_delegate && [_delegate respondsToSelector:@selector(omNative:didLoadAdView:)]) {
                [self addNativeEvent:CALLBACK_LOAD_SUCCESS extraData:nil];
                [_delegate omNative:self didLoadAdView:nativeAdView];
            }
        }
        
        [self.adLoader saveInstanceLoadState:self.adLoader.optimalFillInstance state:OMInstanceLoadStateCallShow];
        
        if(!self.adLoader.loading) {
            __weak __typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.adLoader saveInstanceLoadState:self.adLoader.optimalFillInstance state:OMInstanceLoadStateWait];
                [weakSelf loadAd:self.adFormat actionType:OMLoadActionCloseEvent];
            });
            
        }
    }
}

- (void)omDidFail:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(omNative:didFailWithError:)]) {
        [self addNativeEvent:CALLBACK_LOAD_ERROR extraData:@{@"msg":OM_SAFE_STRING([error description])}];
        [_delegate omNative:self didFailWithError:error];
    }
    
}

- (void)nativeCustomEventWillShow:(id)adObject {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        OMNativeAd * nativeAd = [weakSelf.adnNativeAdMap objectForKey:adObject];
        NSMutableDictionary *wrapperData = [NSMutableDictionary dictionary];
        if (nativeAd) {
            [self showNativeAd:nativeAd];
            if (nativeAd.bidResponse) {
                [wrapperData setObject:[NSNumber numberWithInt:1] forKey:@"bid"];
                [wrapperData setObject:[NSNumber numberWithDouble:nativeAd.bidResponse.price] forKey:@"price"];
                [wrapperData setObject:nativeAd.bidResponse.currency forKey:@"cur"];
            }
            [self adshow:nativeAd.adapter eventData:wrapperData];
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(omNative:nativeAdDidShow:)]) {
            [weakSelf addNativeEvent:CALLBACK_PRESENT_SCREEN extraData:nil];
            [weakSelf.delegate omNative:weakSelf nativeAdDidShow:nativeAd];
        }
    });
}

- (void)nativeCustomEventDidClick:(id)adObject {
    OMNativeAd * nativeAd = [_adnNativeAdMap objectForKey:adObject];
    NSMutableDictionary *wrapperData = [NSMutableDictionary dictionary];
    if (nativeAd) {
        if (nativeAd.bidResponse) {
            [wrapperData setObject:[NSNumber numberWithInt:1] forKey:@"bid"];
            [wrapperData setObject:[NSNumber numberWithDouble:nativeAd.bidResponse.price] forKey:@"price"];
            [wrapperData setObject:nativeAd.bidResponse.currency forKey:@"cur"];
        }
        [self adClick:nativeAd.adapter eventData:wrapperData];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(omNative:nativeAdDidClick:)]) {
        [self addNativeEvent:CALLBACK_CLICK extraData:nil];
        [_delegate omNative:self nativeAdDidClick:nativeAd];
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


- (void)showNativeAd:(OMNativeAd*)nativeAd {
    NSMutableDictionary *wrapperData = [NSMutableDictionary dictionary];
    if (!OM_STR_EMPTY(nativeAd.instanceID)) {
        if (nativeAd.bidResponse) {
            [nativeAd.bidResponse win];
            OMLogD(@"%@ %@ bid win notice",self.pid,nativeAd.instanceID);
            [wrapperData setObject:[NSNumber numberWithInt:1] forKey:@"bid"];
            [wrapperData setObject:[NSNumber numberWithDouble:nativeAd.bidResponse.price] forKey:@"price"];
            [wrapperData setObject:nativeAd.bidResponse.currency forKey:@"cur"];
            [self addEvent:INSTANCE_BID_WIN instance:nativeAd.instanceID extraData:nil];
        }
        [self addEvent:INSTANCE_SHOW instance:nativeAd.instanceID extraData:wrapperData];
    }
}

@end
