// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMChartboostClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMChartboostAdapterDelegate <NSObject>

- (void)omChartboostDidReceiveReward;
- (void)omChartboostDidload;
- (void)omChartboostDidFailToLoad:(NSError*)error;
- (void)omChartboostDidStart;
- (void)omChartboostDidClick;
- (void)omChartboostRewardedVideoEnd;
- (void)omChartboostDidFinish;

@end

@interface OMChartboostRouter : NSObject<ChartboostDelegate>

@property (nonatomic, strong) NSMutableDictionary *placementDelegateMap;

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;
- (void)loadChartboostPlacmentID:(NSString *)pid;
- (void)loadChartboostInterstitial:(NSString *)pid;

@end

NS_ASSUME_NONNULL_END
