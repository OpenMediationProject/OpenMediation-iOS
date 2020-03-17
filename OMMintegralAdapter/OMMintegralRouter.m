// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralRouter.h"

static OMMintegralRouter * _instance = nil;
@implementation OMMintegralRouter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        Class MTGRewardAdManagerClass = NSClassFromString(@"MTGRewardAdManager");
        if (MTGRewardAdManagerClass && [MTGRewardAdManagerClass respondsToSelector:@selector(sharedInstance)]) {
            _mintegralSDK = [MTGRewardAdManagerClass sharedInstance];
        }
        _placementDelegateMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}

- (void)didInitialize:(BOOL)status {
    NSError *error = nil;
    if (!status) {
        error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                           code:400
                                       userInfo:@{NSLocalizedDescriptionKey:@"Init failed"}];
    }
}

- (void)loadPlacmentID:(NSString *)pid {
    if (_mintegralSDK && [_mintegralSDK respondsToSelector:@selector(loadVideo:delegate:)]) {
        [_mintegralSDK loadVideo:pid delegate:self];
    }
}

- (BOOL)isReady:(NSString *)pid {
    BOOL isReady = NO;
    if (_mintegralSDK && [_mintegralSDK respondsToSelector:@selector(isVideoReadyToPlay:)]) {
       isReady = [_mintegralSDK isVideoReadyToPlay:pid];
    }
    return isReady;
}

- (void)showVideo:(NSString *)pid withVC:(UIViewController*)vc {
    if (_mintegralSDK && [_mintegralSDK respondsToSelector:@selector(showVideo:withRewardId:userId:delegate:viewController:)]) {
        [_mintegralSDK showVideo:pid withRewardId:@"" userId:@"" delegate:self viewController:vc];
    }
}

#pragma mark - MTGRewardAdLoadDelegate
- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
     Class MTGRewardAdManagerClass = NSClassFromString(@"MTGRewardAdManager");
       if (MTGRewardAdManagerClass && [[MTGRewardAdManagerClass sharedInstance] respondsToSelector:@selector(isVideoReadyToPlay:)] && [[MTGRewardAdManagerClass sharedInstance] isVideoReadyToPlay:unitId] && delegate && [delegate respondsToSelector:@selector(omMintegralDidload)] ) {
           [delegate omMintegralDidload];
       }
}

- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
   if (delegate && [delegate respondsToSelector:@selector(omMintegralDidFailToLoad:)]) {
       [delegate omMintegralDidFailToLoad:error];
   }
}

#pragma mark - MTGRewardAdShowDelegate Delegate

//Show Reward Video Ad Success Delegate
- (void)onVideoAdShowSuccess:(NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (delegate && [delegate respondsToSelector:@selector(omMintegralDidStart)]) {
        [delegate omMintegralDidStart];
    }
}


//Show Reward Video Ad Failed Delegate
- (void)onVideoAdShowFailed:(NSString *)unitId withError:(NSError *)error {
   
}


//About RewardInfo Delegate
- (void)onVideoAdDismissed:(NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(MTGRewardAdInfo *)rewardInfo {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (rewardInfo) {
        if (delegate && [delegate respondsToSelector:@selector(omMintegralDidReceiveReward)]) {
            [delegate omMintegralDidReceiveReward];
        }
    }
}

- (void)onVideoAdDidClosed:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (delegate && [delegate respondsToSelector:@selector(omMintegralDidFinish:)]) {
        [delegate omMintegralDidFinish:NO];
    }
}

- (void)onVideoAdClicked:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (delegate && [delegate respondsToSelector:@selector(omMintegralDidClick)]) {
        [delegate omMintegralDidClick];
    }
}

- (void) onVideoPlayCompleted:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (delegate && [delegate respondsToSelector:@selector(omMintegralRewardedVideoEnd)]) {
        [delegate omMintegralRewardedVideoEnd];
    }
}

- (void) onVideoEndCardShowSuccess:(nullable NSString *)unitId {
    
}

@end
