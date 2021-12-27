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
- (void)omUnityFailToShow:(NSError *)error;

@end

@interface OMUnityRouter : NSObject<UnityAdsLoadDelegate,UnityAdsShowDelegate>
@property (nonatomic, strong) NSMapTable *placementDelegateMap;

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;
- (void)loadPlacmentID:(NSString *)pid;
- (void)showVideo:(NSString *)pid withVC:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
