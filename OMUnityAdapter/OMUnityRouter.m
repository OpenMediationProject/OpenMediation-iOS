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
        _placementDelegateMap = [NSMapTable weakToWeakObjectsMapTable];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}

- (void)loadPlacmentID:(NSString *)pid {
    Class unityClass = NSClassFromString(@"UnityAds");
    if (unityClass && [unityClass respondsToSelector:@selector(load:loadDelegate:)]) {
        [unityClass load:pid loadDelegate:self];
    }
}

- (void)showVideo:(NSString *)pid withVC:(UIViewController*)vc {
    Class unityClass = NSClassFromString(@"UnityAds");
    if (unityClass && [unityClass respondsToSelector:@selector(show: placementId:showDelegate:)]) {
        [unityClass show:vc placementId:pid showDelegate:self];
    }
}

// load success
- (void)unityAdsAdLoaded:(NSString *)placementId {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidload)]) {
        [delegate omUnityDidload];
    }
}

// load failed
- (void)unityAdsAdFailedToLoad: (NSString *)placementId
                     withError: (UnityAdsLoadError)error
                   withMessage: (NSString *)message {
    NSError *unityError = [NSError errorWithDomain:@"com.om.mediation" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"unity ads load failed"}];
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidFailToLoad:)]) {
        [delegate omUnityDidFailToLoad:unityError];
    }
}


- (void)unityAdsShowComplete: (NSString *)placementId withFinishState: (UnityAdsShowCompletionState)state {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidFinish:)]) {
        [delegate omUnityDidFinish:(state != kUnityShowCompletionStateCompleted)];
    }
    
    if (delegate && [delegate respondsToSelector:@selector(omUnityRewardedVideoEnd)]) {
        [delegate omUnityRewardedVideoEnd];
    }
}

- (void)unityAdsShowFailed: (NSString *)placementId withError: (UnityAdsShowError)error withMessage: (NSString *)message {
    NSError *errors = [[NSError alloc]initWithDomain:@"com.unity.ads" code:error userInfo: @{NSLocalizedDescriptionKey:message}];
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    if (delegate && [delegate respondsToSelector:@selector(omUnityFailToShow:)]) {
        [delegate omUnityFailToShow:errors];
    }
}

- (void)unityAdsShowStart: (NSString *)placementId {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidStart)]) {
        [delegate omUnityDidStart];
    }
}

- (void)unityAdsShowClick: (NSString *)placementId {
    id<OMUnityAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementId];
    
    if (delegate && [delegate respondsToSelector:@selector(omUnityDidClick)]) {
        [delegate omUnityDidClick];
    }
}

@end
