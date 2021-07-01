// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUnityRouter.h"

static OMUnityRouter * _instance = nil;

@implementation OMUnityRouter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        Class unityClass = NSClassFromString(@"UnityAds");
        if (unityClass && [unityClass respondsToSelector:@selector(addDelegate:)]) {
            [unityClass addDelegate:self];
        }
        _placementDelegateMap = [NSMapTable weakToWeakObjectsMapTable];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}

// load success
- (void)unityAdsAdLoaded:(NSString *)placementId {
    
}

- (void)showVideo:(NSString *)pid withVC:(UIViewController*)vc {
    Class unityClass = NSClassFromString(@"UnityAds");
    if (unityClass && [unityClass respondsToSelector:@selector(show: placementId:showDelegate:)]) {
        [unityClass show:vc placementId:pid showDelegate:self];
    }
}

// load failed
- (void)unityAdsAdFailedToLoad:(NSString *)placementId {
    NSError *error = [NSError errorWithDomain:@"com.om.mediation" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"unity ads load failed"}];
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidFailToLoad:)]) {
        [delegate omUnityDidFailToLoad:error];
    }
}

- (void)unityAdsReady:(NSString *)placementId {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidload)]) {
        [delegate omUnityDidload];
    }
}


- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message {
    
}

- (void)unityAdsDidStart:(NSString *)placementId {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidStart)]) {
        [delegate omUnityDidStart];
    }
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidFinish:)]) {
        [delegate omUnityDidFinish:(state != kUnityAdsFinishStateCompleted)];
    }
}

- (void)unityAdsDidClick:(NSString *)placementId {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidClick)]) {
        [delegate omUnityDidClick];
    }
}

- (void)unityAdsPlacementStateChanged:(NSString *)placementId oldState:(UnityAdsPlacementState)oldState newState:(UnityAdsPlacementState)newState {
    
}

- (void)unityAdsShowComplete:(NSString *)placementId withFinishState:(UnityAdsShowCompletionState)state {
    
}

- (void)unityAdsShowFailed:(NSString *)placementId withError:(UnityAdsShowError)error withMessage:(NSString *)message {
    NSError *errors = [[NSError alloc]initWithDomain:@"com.unity.ads" code:error userInfo: @{NSLocalizedDescriptionKey:message}];
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if (delegate && [delegate respondsToSelector:@selector(omUnityFailToShow:)]) {
        [delegate omUnityFailToShow:errors];
    }
}

- (void)unityAdsShowStart:(NSString *)placementId {

}

- (void)unityAdsShowClick:(NSString *)placementId {
    
}



@end
