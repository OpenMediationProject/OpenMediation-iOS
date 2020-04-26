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
    if (_mintegralSDK && [_mintegralSDK respondsToSelector:@selector(loadVideoWithPlacementId:unitId:delegate:)]) {
        [_mintegralSDK loadVideoWithPlacementId:@"" unitId:pid delegate:self];
    }
}

- (BOOL)isReady:(NSString *)pid {
    BOOL isReady = NO;
    if (_mintegralSDK && [_mintegralSDK respondsToSelector:@selector(isVideoReadyToPlayWithPlacementId:unitId:)]) {
        isReady = [_mintegralSDK isVideoReadyToPlayWithPlacementId:@"" unitId:pid];
    }
    return isReady;
}

- (void)showVideo:(NSString *)pid withVC:(UIViewController*)vc {
    if (_mintegralSDK && [_mintegralSDK respondsToSelector:@selector(showVideoWithPlacementId:unitId:withRewardId:userId:delegate:viewController:)]) {
        [_mintegralSDK showVideoWithPlacementId:@"" unitId:pid withRewardId:@"" userId:@"" delegate:self viewController:vc];
    }
}

#pragma mark - MTGRewardAdLoadDelegate
- (void)onVideoAdLoadSuccess:(nullable NSString *)placementId unitId:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
       if ([self isReady:unitId] && delegate && [delegate respondsToSelector:@selector(omMintegralDidload)] ) {
           [delegate omMintegralDidload];
       }
}

- (void)onVideoAdLoadFailed:(nullable NSString *)placementId unitId:(nullable NSString *)unitId error:(nonnull NSError *)error {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
   if (delegate && [delegate respondsToSelector:@selector(omMintegralDidFailToLoad:)]) {
       [delegate omMintegralDidFailToLoad:error];
   }
}

#pragma mark - MTGRewardAdShowDelegate Delegate

//Show Reward Video Ad Success Delegate
- (void)onVideoAdShowSuccess:(nullable NSString *)placementId unitId:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (delegate && [delegate respondsToSelector:@selector(omMintegralDidStart)]) {
        [delegate omMintegralDidStart];
    }
}


//Show Reward Video Ad Failed Delegate
- (void)onVideoAdShowFailed:(nullable NSString *)placementId unitId:(nullable NSString *)unitId withError:(nonnull NSError *)error {
   
}


//About RewardInfo Delegate
- (void)onVideoAdDismissed:(nullable NSString *)placementId unitId:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (rewardInfo) {
        if (delegate && [delegate respondsToSelector:@selector(omMintegralDidReceiveReward)]) {
            [delegate omMintegralDidReceiveReward];
        }
    }
}

- (void)onVideoAdDidClosed:(nullable NSString *)placementId unitId:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (delegate && [delegate respondsToSelector:@selector(omMintegralDidFinish:)]) {
        [delegate omMintegralDidFinish:NO];
    }
}

- (void)onVideoAdClicked:(nullable NSString *)placementId unitId:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (delegate && [delegate respondsToSelector:@selector(omMintegralDidClick)]) {
        [delegate omMintegralDidClick];
    }
}

- (void) onVideoPlayCompleted:(nullable NSString *)placementId unitId:(nullable NSString *)unitId {
    id<OMMintegralAdapterDelegate> delegate = [_placementDelegateMap objectForKey:unitId];
    if (delegate && [delegate respondsToSelector:@selector(omMintegralRewardedVideoEnd)]) {
        [delegate omMintegralRewardedVideoEnd];
    }
}

- (void) onVideoEndCardShowSuccess:(nullable NSString *)placementId unitId:(nullable NSString *)unitId {
    
}

@end
