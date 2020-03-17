// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostRouter.h"
#import "OMMediationAdapter.h"

@interface OMChartboostAdapter : NSObject
@property (nonatomic, copy) OMMediationAdapterInitCompletionBlock initBlock;

+ (instancetype)sharedInstance;
@end;

static OMChartboostRouter * _instance = nil;


@implementation OMChartboostRouter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
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
    if ([OMChartboostAdapter sharedInstance].initBlock) {
        [OMChartboostAdapter sharedInstance].initBlock(error);
        [OMChartboostAdapter sharedInstance].initBlock = nil;
    }
}


- (void)loadChartboostPlacmentID:(NSString *)pid {
    
    Class chartboostClass = NSClassFromString(@"Chartboost");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(cacheRewardedVideo:)]) {
        [chartboostClass cacheRewardedVideo:pid];
    }
}

- (void)loadChartboostInterstitial:(NSString *)pid {
    Class chartboostClass = NSClassFromString(@"Chartboost");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(cacheInterstitial:)]) {
        [chartboostClass cacheInterstitial:pid];
    }
}
#pragma mark -- ChartboostDelegate

- (void)didCacheRewardedVideo:(CBLocation)location {
    
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    
    Class chartboostClass = NSClassFromString(@"Chartboost");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(hasRewardedVideo:)] && [chartboostClass hasRewardedVideo:location] && delegate && [delegate respondsToSelector:@selector(omChartboostDidload)]) {
        [delegate omChartboostDidload];
    }
    
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location withError:(CBLoadError)error {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    NSError *cerror = [[NSError alloc] initWithDomain:@"" code:error userInfo:@{@"msg":@"chartboost fail to load rewardedvideo"}];
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidFailToLoad:)]) {
        [delegate omChartboostDidFailToLoad:cerror];
    }
}

- (void)didDisplayRewardedVideo:(CBLocation)location {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidStart)]) {
        [delegate omChartboostDidStart];
    }
}

- (void)didClickRewardedVideo:(CBLocation)location {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidClick)]) {
        [delegate omChartboostDidClick];
    }
}


- (void)didDismissRewardedVideo:(CBLocation)location {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidFinish)]) {
        [delegate omChartboostDidFinish];
    }
}

// 奖励
- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    if (delegate && [delegate respondsToSelector:@selector(omChartboostRewardedVideoEnd)]) {
        [delegate omChartboostRewardedVideoEnd];
    }
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidReceiveReward)]) {
        [delegate omChartboostDidReceiveReward];
    }
}

- (void)didCacheInterstitial:(CBLocation)location {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    
    Class chartboostClass = NSClassFromString(@"Chartboost");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(hasRewardedVideo:)] && [chartboostClass hasInterstitial:location] && delegate && [delegate respondsToSelector:@selector(omChartboostDidload)]) {
        [delegate omChartboostDidload];
    }
    
}

- (void)didFailToLoadInterstitial:(CBLocation)location withError:(CBLoadError)error {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    NSError *cerror = [[NSError alloc] initWithDomain:@"" code:error userInfo:@{@"msg":@"chartboost fail to load interstitial"}];
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidFailToLoad:)]) {
        [delegate omChartboostDidFailToLoad:cerror];
    }
}

- (void)didDisplayInterstitial:(CBLocation)location {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidStart)]) {
        [delegate omChartboostDidStart];
    }
}

- (void)didClickInterstitial:(CBLocation)location {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidClick)]) {
        [delegate omChartboostDidClick];
    }
}

- (void)didDismissInterstitial:(CBLocation)location {
    id<OMChartboostAdapterDelegate> delegate = [_placementDelegateMap objectForKey:location];
    
    if (delegate && [delegate respondsToSelector:@selector(omChartboostDidFinish)]) {
        [delegate omChartboostDidFinish];
    }
}

@end
