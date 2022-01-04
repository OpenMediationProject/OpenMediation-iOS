// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMintegralRewardedVideoClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMMintegralAdapterDelegate <NSObject>

- (void)omMintegralDidReceiveReward;
- (void)omMintegralDidload;
- (void)omMintegralDidFailToLoad:(NSError*)error;
- (void)omMintegralDidStart;
- (void)omMintegralDidClick;
- (void)omMintegralRewardedVideoEnd;
- (void)omMintegralDidFinish:(BOOL)skipped;

@end

@interface OMMintegralRouter : NSObject<MTGRewardAdLoadDelegate,MTGRewardAdShowDelegate>

@property (nonatomic, strong) NSMapTable *placementDelegateMap;
@property (nonatomic, strong) MTGRewardAdManager *rvAdManager;
@property (nonatomic, strong) MTGBidRewardAdManager *rvBidAdManager;

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;
- (void)loadPlacmentID:(NSString *)pid;
- (void)loadPlacmentID:(NSString *)pid withBidPayload:(NSString *)bidPayload;
- (BOOL)isReady:(NSString *)pid;
- (void)showVideo:(NSString *)pid withVC:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
