// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSplash.h"
#import "OMSplashAd.h"
#import "OMToolUmbrella.h"
#import "OMEventManager.h"

@interface OMSplash ()<splashDelegate>
@property (nonatomic, strong) OMSplashAd *splashAd;
@end

@implementation OMSplash

- (instancetype)initWithPlacementId:(NSString *)placementId adSize:(CGSize)size {
    if (self = [super init]) {
        self.splashAd = [[OMSplashAd alloc] initWithPlacementID:placementId size:size];
        self.splashAd.delegate = self;
    }
    return self;
}

- (void)loadAd {
    [_splashAd loadAd:OpenMediationAdFormatSplash actionType:OMLoadActionManualLoad];
}

- (BOOL)isReady {
    BOOL isReady = [_splashAd isReady];
    NSInteger event = isReady?CALLED_IS_READY_TRUE:CALLED_IS_READY_FALSE;
    [self addEvent:event extraData:nil];
    return isReady;
    
    
}

- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView {
    if (![_splashAd isReady]) {
        NSError *error = [OMError omErrorWithCode:OMErrorShowFailNotReady];
        NSError *noReadyError = [OMSDKError errorWithAdtError:error];
        [OMSDKError throwDeveloperError:noReadyError];
        [self splashDidFailToShowWithError:noReadyError];
        return;
    }
    [_splashAd showWithWindow:window customView:customView];
}

- (NSString*)placementID {
    return _splashAd.pid;
}

#pragma mark -- splashDelegate

- (void)splashDidLoad:(NSString *)instanceId{
    if (_delegate && [_delegate respondsToSelector:@selector(omSplashDidLoad:)]) {
        [self addEvent:CALLBACK_LOAD_SUCCESS extraData:nil];
        [_delegate omSplashDidLoad:self];
    }
}

- (void)splashDidFailToLoadWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(omSplashFailToLoad:withError:)]) {
        [self addEvent:CALLBACK_LOAD_ERROR extraData:@{@"msg":OM_SAFE_STRING([error description])}];
        [_delegate omSplashFailToLoad:self withError:error];
    }
}

- (void)splashDidShow {
    if (_delegate && [_delegate respondsToSelector:@selector(omSplashDidShow:)]) {
        [self addEvent:CALLBACK_PRESENT_SCREEN extraData:nil];
        [_delegate omSplashDidShow:self];
    }
}

- (void)splashDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(omSplashDidClick:)]) {
        [self addEvent:CALLBACK_CLICK extraData:nil];
        [_delegate omSplashDidClick:self];
    }
}


- (void)splashDidClose {
    if (_delegate && [_delegate respondsToSelector:@selector(omSplashDidClose:)]) {
        [_delegate omSplashDidClose:self];
    }
}

- (void)splashDidFailToShowWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(omSplashDidFailToShow:withError:)]) {
        [self addEvent:CALLBACK_LOAD_ERROR extraData:@{@"msg":OM_SAFE_STRING([error description])}];
        [_delegate omSplashDidFailToShow:self withError:error];
    }
}

- (void)addEvent:(NSInteger)eventID extraData:data {
    NSMutableDictionary *wrapperData = [NSMutableDictionary dictionary];
    if (data) {
        [wrapperData addEntriesFromDictionary:data];
    }
    [wrapperData setObject:[NSNumber omStr2Number:[self placementID]] forKey:@"pid"];
     [[OMEventManager sharedInstance] addEvent:eventID extraData:wrapperData];
}

@end
