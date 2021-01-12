// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>

#import "OMMediationAdapter.h"
#import "OMUnityClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMUnityAdapterDelegate <NSObject>

- (void)omUnityDidload;
- (void)omUnityDidFailToLoad:(NSError*)error;
- (void)omUnityDidStart;
- (void)omUnityDidClick;
- (void)omUnityRewardedVideoEnd;
- (void)omUnityDidFinish:(BOOL)skipped;

@end

@interface OMUnityRouter : NSObject<UnityAdsDelegate,UnityAdsExtendedDelegate>
@property (nonatomic, strong) NSMutableDictionary *placementDelegateMap;

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;


@end

NS_ASSUME_NONNULL_END
