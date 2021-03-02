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
        _placementDelegateMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}

// load success
- (void)unityAdsAdLoaded:(NSString *)placementId {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidload)]) {
        [delegate omUnityDidload];
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
@end
