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

#pragma mark -- VungleSDKDelegate
- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error {
    
    id<OMVungleAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementID];
    
    if (!error && _vungleSDK && [_vungleSDK respondsToSelector:@selector(isAdCachedForPlacementID:)] && [_vungleSDK isAdCachedForPlacementID:placementID]) {
        if (delegate && [delegate respondsToSelector:@selector(omVungleDidload)]) {
            [delegate omVungleDidload];
        }
    } else {
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
}


- (void)vungleDidCloseAdWithViewInfo:(nonnull VungleViewInfo *)info placementID:(nonnull NSString *)placementID {
    id<OMVungleAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementID];
    if (info.didDownload) {
        if (delegate && [delegate respondsToSelector:@selector(omVungleDidClick)]) {
            [delegate omVungleDidClick];
        }
    }
    if (delegate && [delegate respondsToSelector:@selector(omVungleDidFinish:)]) {
        [delegate omVungleDidFinish:!((BOOL)[info.completedView integerValue])];
    }
}
@end
