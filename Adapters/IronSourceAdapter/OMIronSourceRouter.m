// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceRouter.h"

static OMIronSourceRouter * _instance = nil;
@implementation OMIronSourceRouter

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    if (self = [super init]) {
        Class IronSourceClass = NSClassFromString(@"IronSource");
        if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(setISDemandOnlyInterstitialDelegate:)] && [IronSourceClass respondsToSelector:@selector(setISDemandOnlyRewardedVideoDelegate:)]) {
            [IronSourceClass setISDemandOnlyInterstitialDelegate:self];
            [IronSourceClass setISDemandOnlyRewardedVideoDelegate:self];
        }
        _placementDelegateMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}


#pragma mark - ISDemandOnlyInterstitialDelegate

/**
 Called after an interstitial has been loaded
 */
- (void)interstitialDidLoad:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidload)]) {
        [delegate OMIronSourceDidload];
    }
}

/**
 Called after an interstitial has attempted to load but failed.
 
 @param error The reason for the error
 */
- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidFailToLoad:)]) {
        [delegate OMIronSourceDidFailToLoad:error];
    }
}

/**
 Called after an interstitial has been opened.
 */
- (void)interstitialDidOpen:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidStart)]) {
        [delegate OMIronSourceDidStart];
    }
}

/**
 Called after an interstitial has been dismissed.
 */
- (void)interstitialDidClose:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidFinish)]) {
        [delegate OMIronSourceDidFinish];
    }
}

/**
 Called after an interstitial has attempted to show but failed.
 
 @param error The reason for the error
 */
- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidFailToShow:)]) {
        [delegate OMIronSourceDidFailToShow:error];
    }
}

/**
 Called after an interstitial has been clicked.
 */
- (void)didClickInterstitial:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidClick)]) {
        [delegate OMIronSourceDidClick];
    }
}


#pragma mark - ISDemandOnlyRewardedVideoDelegate

- (void)rewardedVideoDidLoad:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidload)]) {
        [delegate OMIronSourceDidload];
    }
}

- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidFailToLoad:)]) {
        [delegate OMIronSourceDidFailToLoad:error];
    }
}

- (void)rewardedVideoDidOpen:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidStart)]) {
        [delegate OMIronSourceDidStart];
    }
}

- (void)rewardedVideoDidClose:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceVideoEnd)]) {
        [delegate OMIronSourceVideoEnd];
    }
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidFinish)]) {
        [delegate OMIronSourceDidFinish];
    }
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidFailToShow:)]) {
        [delegate OMIronSourceDidFailToShow:error];
    }
}

- (void)rewardedVideoDidClick:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidClick)]) {
        [delegate OMIronSourceDidClick];
    }
}

- (void)rewardedVideoAdRewarded:(NSString *)instanceId{
    id<OMIronSourceAdapterDelegate> delegate = [_placementDelegateMap objectForKey:instanceId];
    if(delegate && [delegate respondsToSelector:@selector(OMIronSourceDidReceiveReward)]) {
        [delegate OMIronSourceDidReceiveReward];
    }
}


@end
