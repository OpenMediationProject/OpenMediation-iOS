// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMSigMobRewardedVideoClass.h"
#import "OMSigMobInterstitialClass.h"
#import "OMSigMobClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMSigMobAdapterDelegate <NSObject>

- (void)OMSigMobDidload;
- (void)OMSigMobDidFailToLoad:(NSError*)error;
- (void)OMSigMobDidStart;
- (void)OMSigMobDidClick;
- (void)OMSigMobDidClose;
- (void)OMSigMobVideoEnd;
- (void)OMSigMobDidFailToShow:(NSError *)error;

@optional
- (void)OMSigMobDidReceiveReward;

@end


@interface OMSigMobRouter : NSObject<WindInterstitialAdDelegate,WindRewardedVideoAdDelegate>

@property (nonatomic, strong) NSMapTable *placementDelegateMap;

@property (nonatomic, strong) id sigmobInterstitialSDK;
@property (nonatomic, strong) id sigmobVideoSDK;

@property (nonatomic, assign) BOOL isInterstitialPlaying;
@property (nonatomic, assign) BOOL isVideoPlaying;

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;
- (void)loadInterstitialWithPlacmentID:(NSString *)pid;
- (void)loadRewardedVideoWithPlacmentID:(NSString *)pid;
- (BOOL)isInterstitialReady:(NSString *)pid;
- (BOOL)isRewardedVideoReady:(NSString *)pid;
- (void)showInterstitialAd:(NSString *)pid withVC:(UIViewController*)vc;
- (void)showRewardedVideoAd:(NSString *)pid withVC:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
