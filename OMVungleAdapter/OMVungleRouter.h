// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMVungleClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMVungleAdapterDelegate <NSObject>

- (void)omVungleDidload;
- (void)omVungleDidFailToLoad:(NSError*)error;
- (void)omVungleDidClick;

@optional
- (void)omVungleDidStart;
- (void)omVungleRewardedVideoEnd;
- (void)omVungleDidFinish:(BOOL)skipped;
- (void)omVungleWillLeaveApplication;

@end

@interface OMVungleRouter : NSObject<VungleSDKDelegate>

@property (nonatomic, assign) BOOL isAdPlaying;
@property (nonatomic, strong) NSMutableDictionary *placementDelegateMap;
@property (nonatomic, strong) id vungleSDK;

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;
- (void)loadPlacmentID:(NSString *)pid;
- (void)loadBannerWithPlacementID:(NSString*)pid;
- (BOOL)isAdAvailableForPlacementID:(NSString *) pid;
- (void)showAdFromViewController:(UIViewController *)viewController forPlacementId:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
