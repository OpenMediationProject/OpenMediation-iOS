// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMVungleClass.h"
#import "OMVungleBidClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMVungleAdapterDelegate <NSObject>

- (void)omVungleDidload;
- (void)omVungleDidFailToLoad:(NSError*)error;
- (void)omVungleDidClick;

@optional
- (void)omVungleDidStart;
- (void)omVungleShowFailed:(NSError*)error;
- (void)omVungleRewardedVideoEnd;
- (void)omVungleDidFinish:(BOOL)skipped;
- (void)omVungleWillLeaveApplication;
- (void)omVungleDidReceiveReward;

@end

@interface OMVungleRouter : NSObject<VungleSDKDelegate,VungleSDKHeaderBidding>

@property (nonatomic, assign) BOOL isAdPlaying;
@property (nonatomic, strong) NSMapTable *placementDelegateMap;
@property (nonatomic, strong) id vungleSDK;
@property (nonatomic, assign) BOOL sdkInitialized; // vungle sdk init status

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;
- (void)loadPlacmentID:(NSString *)pid;
- (void)loadBannerWithsize:(CGSize)size PlacementID:(NSString*)pid;
- (BOOL)isAdAvailableForPlacementID:(NSString *) pid;
- (void)showAdFromViewController:(UIViewController *)viewController forPlacementId:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
