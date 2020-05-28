// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleRouter.h"

static OMVungleRouter * _instance = nil;


@implementation OMVungleRouter
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        Class vungleClass = NSClassFromString(@"VungleSDK");
        if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)]) {
            _vungleSDK = [vungleClass sharedSDK];
        }
        _placementDelegateMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}

- (void)loadPlacmentID:(NSString *)pid {
    NSError *error = nil;
    if (_vungleSDK && [_vungleSDK respondsToSelector:@selector(loadPlacementWithID: error:)]) {
        [_vungleSDK loadPlacementWithID:pid error:&error];
    }
}

- (VungleAdSize)convertWithSize:(CGSize)size {
    if (size.width == 300 && size.height == 250) {
        return VungleAdSizeBannerShort;
    } else if (size.width == 728 && size.height == 90) {
        return VungleAdSizeBannerLeaderboard;
    } else  {
        return VungleAdSizeBanner;
    }
}

- (void)loadBannerWithsize:(CGSize)size PlacementID:(NSString*)pid {
    NSError *error = nil;
    if (_vungleSDK && [_vungleSDK respondsToSelector:@selector(loadPlacementWithID:withSize:error:)]) {
        [_vungleSDK loadPlacementWithID:pid withSize:[self convertWithSize:size] error:&error];
    }
}

- (BOOL)isAdAvailableForPlacementID:(NSString *) pid {
    BOOL isReady = NO;
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)]) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        isReady = [vungle isAdCachedForPlacementID:pid];
    }
    return isReady;
}


- (void)showAdFromViewController:(UIViewController *)viewController forPlacementId:(NSString *)placementID {
    if (!self.isAdPlaying && [self isAdAvailableForPlacementID:placementID]) {
        NSDictionary *options = @{};
        NSError *error;
        Class vungleClass = NSClassFromString(@"VungleSDK");
        if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)] && [[vungleClass sharedSDK] respondsToSelector:@selector(playAd: options:placementID: error:)]) {
            VungleSDK *vungle = [vungleClass sharedSDK];
            self.isAdPlaying = YES;
            BOOL success = [vungle playAd:viewController options:options placementID:placementID error:&error];
            if (!success) {
                self.isAdPlaying = NO;
            }
        }
    }
}

#pragma mark -- VungleSDKDelegate
- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error {
    
    id<OMVungleAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementID];
    
    if(isAdPlayable && _vungleSDK && [_vungleSDK respondsToSelector:@selector(isAdCachedForPlacementID:)] && [_vungleSDK isAdCachedForPlacementID:placementID] ) {
        if (delegate && [delegate respondsToSelector:@selector(omVungleDidload)]) {
            [delegate omVungleDidload];
        }
    }

    if (error && !self.isAdPlaying) {
        if (delegate && [delegate respondsToSelector:@selector(omVungleDidFailToLoad:)]) {
            [delegate omVungleDidFailToLoad:error];
        }
    }
}

- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID {
    id<OMVungleAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementID];
    
    if (delegate && [delegate respondsToSelector:@selector(omVungleDidStart)]) {
        [delegate omVungleDidStart];
    }
}


- (void)vungleWillCloseAdWithViewInfo:(nonnull VungleViewInfo *)info placementID:(nonnull NSString *)placementID {
    id<OMVungleAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementID];
    
    if (delegate && [delegate respondsToSelector:@selector(omVungleRewardedVideoEnd)]) {
        [delegate omVungleRewardedVideoEnd];
    }
    self.isAdPlaying = NO;
}


- (void)vungleDidCloseAdWithViewInfo:(nonnull VungleViewInfo *)info placementID:(nonnull NSString *)placementID {
    id<OMVungleAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementID];
    if ([info.didDownload isEqual:@YES]) {
        if (delegate && [delegate respondsToSelector:@selector(omVungleDidClick)]) {
            [delegate omVungleDidClick];
        }
    }
    if (delegate && [delegate respondsToSelector:@selector(omVungleDidFinish:)]) {
        [delegate omVungleDidFinish:!((BOOL)[info.completedView integerValue])];
    }
}


@end
