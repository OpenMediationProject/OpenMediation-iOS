// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSigMobRouter.h"

static OMSigMobRouter * _instance = nil;

@implementation OMSigMobRouter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(instancetype)init {
    if (self = [super init]) {
        Class sigmobInterstitialClass = NSClassFromString(@"WindFullscreenVideoAd");
        if (sigmobInterstitialClass && [sigmobInterstitialClass respondsToSelector:@selector(sharedInstance)]) {
            _sigmobInterstitialSDK = [sigmobInterstitialClass sharedInstance];
            if (_sigmobInterstitialSDK && [_sigmobInterstitialSDK respondsToSelector:@selector(setDelegate:)]) {
                [_sigmobInterstitialSDK setDelegate:self];
            }
        }
        Class sigmobVideoClass = NSClassFromString(@"WindRewardedVideoAd");
        if (sigmobVideoClass && [sigmobVideoClass respondsToSelector:@selector(sharedInstance)]) {
            _sigmobVideoSDK = [sigmobVideoClass sharedInstance];
            if (_sigmobVideoSDK && [_sigmobVideoSDK respondsToSelector:@selector(setDelegate:)]) {
                [_sigmobVideoSDK setDelegate:self];
            }
        }
        _placementDelegateMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}


- (void)loadRewardedVideoWithPlacmentID:(NSString *)pid {
    Class sigmobRequestClass = NSClassFromString(@"WindAdRequest");
    if (sigmobRequestClass && [sigmobRequestClass respondsToSelector:@selector(request)]) {
        id requests = [sigmobRequestClass request];
        WindAdRequest *request = requests;
        Class sigmobClass = NSClassFromString(@"WindRewardedVideoAd");
        if (sigmobClass && [sigmobClass respondsToSelector:@selector(sharedInstance)]) {
            _sigmobVideoSDK = [sigmobClass sharedInstance];
        }
        if (_sigmobVideoSDK && [_sigmobVideoSDK respondsToSelector:@selector(loadRequest:withPlacementId:)]) {
            [_sigmobVideoSDK loadRequest:request withPlacementId:pid];
        }
    }
    
}

- (void)loadInterstitialWithPlacmentID:(NSString *)pid {
    Class sigmobRequestClass = NSClassFromString(@"WindAdRequest");
    if (sigmobRequestClass && [sigmobRequestClass respondsToSelector:@selector(request)]) {
        id requests = [sigmobRequestClass request];
        WindAdRequest *request = requests;
        Class sigmobClass = NSClassFromString(@"WindFullscreenVideoAd");
        if (sigmobClass && [sigmobClass respondsToSelector:@selector(sharedInstance)]) {
            _sigmobInterstitialSDK = [sigmobClass sharedInstance];
        }
        if (_sigmobInterstitialSDK && [_sigmobInterstitialSDK respondsToSelector:@selector(loadRequest:withPlacementId:)]) {
            [_sigmobInterstitialSDK loadRequest:request withPlacementId:pid];
        }
    }
}

- (BOOL)isInterstitialReady:(NSString *)pid {
    BOOL isReady = NO;
    Class sigmobClass = NSClassFromString(@"WindFullscreenVideoAd");
    if (sigmobClass && [sigmobClass respondsToSelector:@selector(sharedInstance)]) {
        _sigmobInterstitialSDK = [sigmobClass sharedInstance];
    }
    
    if (_sigmobInterstitialSDK && [_sigmobInterstitialSDK respondsToSelector:@selector(isReady:)]) {
        isReady = [_sigmobInterstitialSDK isReady:pid];
    }
    
    return isReady;
}

- (BOOL)isRewardedVideoReady:(NSString *)pid {
    BOOL isReady = NO;
    Class sigmobClass = NSClassFromString(@"WindRewardedVideoAd");
    if (sigmobClass && [sigmobClass respondsToSelector:@selector(sharedInstance)]) {
        _sigmobVideoSDK = [sigmobClass sharedInstance];
    }
    
    if (_sigmobVideoSDK && [_sigmobVideoSDK respondsToSelector:@selector(isReady:)]) {
        isReady = [_sigmobVideoSDK isReady:pid];
    }
    
    return isReady;
}

- (void)showInterstitialAd:(NSString *)pid withVC:(UIViewController*)vc {
    Class sigmobClass = NSClassFromString(@"WindFullscreenVideoAd");
    if (sigmobClass && [sigmobClass respondsToSelector:@selector(sharedInstance)]) {
        _sigmobInterstitialSDK = [sigmobClass sharedInstance];
    }
    
    if (_sigmobInterstitialSDK && [_sigmobInterstitialSDK respondsToSelector:@selector(playAd:withPlacementId:options:error:)]) {
        [_sigmobInterstitialSDK playAd:vc withPlacementId:pid options:nil error:nil];
    }
    
}

- (void)showRewardedVideoAd:(NSString *)pid withVC:(UIViewController*)vc {
    Class sigmobClass = NSClassFromString(@"WindRewardedVideoAd");
    if (sigmobClass && [sigmobClass respondsToSelector:@selector(sharedInstance)]) {
        _sigmobVideoSDK = [sigmobClass sharedInstance];
    }
    
    if (_sigmobVideoSDK && [_sigmobVideoSDK respondsToSelector:@selector(playAd:withPlacementId:options:error:)]) {
        [_sigmobVideoSDK playAd:vc withPlacementId:pid options:nil error:nil];
    }
}


// 插屏视频

- (void)onFullscreenVideoAdLoadSuccess:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidload)]) {
        [delegate OMSigMobDidload];
    }
}


- (void)onFullscreenVideoAdError:(NSError *)error placementId:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidFailToLoad:)]) {
        [delegate OMSigMobDidFailToLoad:error];
    }
}


- (void)onFullscreenVideoAdClosed:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidClose)]) {
        [delegate OMSigMobDidClose];
    }
    _isInterstitialPlaying = NO;
}

- (void)onFullscreenVideoAdPlayStart:(NSString *)placementId {
    if (!_isInterstitialPlaying) {
        id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
        if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidStart)]) {
            [delegate OMSigMobDidStart];
        }
    }
    _isInterstitialPlaying = YES;
}


- (void)onFullscreenVideoAdClicked:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidClick)]) {
        [delegate OMSigMobDidClick];
    }
}


- (void)onFullscreenVideoAdPlayError:(NSError *)error placementId:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidFailToShow:)]) {
        [delegate OMSigMobDidFailToShow:error];
    }
}


- (void)onFullscreenVideoAdPlayEnd:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobVideoEnd)]) {
        [delegate OMSigMobVideoEnd];
    }
}



// 激励视频

- (void)onVideoAdLoadSuccess:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidload)]) {
        [delegate OMSigMobDidload];
    }
}


- (void)onVideoError:(NSError *)error placementId:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidFailToLoad:)]) {
        [delegate OMSigMobDidFailToLoad:error];
    }
}


- (void)onVideoAdClosedWithInfo:(WindRewardInfo *)info placementId:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidReceiveReward)]) {
        [delegate OMSigMobDidReceiveReward];
    }
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidClose)]) {
        [delegate OMSigMobDidClose];
    }
    _isVideoPlaying = NO;
}


- (void)onVideoAdPlayStart:(NSString *)placementId {
    if (!_isVideoPlaying) {
        id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
        if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidStart)]) {
            [delegate OMSigMobDidStart];
        }
    }
    _isVideoPlaying = YES;
}


- (void)onVideoAdClicked:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidClick)]) {
        [delegate OMSigMobDidClick];
    }
}


- (void)onVideoAdPlayError:(NSError *)error placementId:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobDidFailToShow:)]) {
        [delegate OMSigMobDidFailToShow:error];
    }
}

- (void)onVideoAdPlayEnd:(NSString *)placementId {
    id<OMSigMobAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if(delegate && [delegate respondsToSelector:@selector(OMSigMobVideoEnd)]) {
        [delegate OMSigMobVideoEnd];
    }
}



@end
