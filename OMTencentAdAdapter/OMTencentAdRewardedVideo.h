// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMTencentAdRewardedVideoClass.h"
#import "OMRewardedVideoCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMTencentAdRewardedVideo : NSObject<OMRewardedVideoCustomEvent,GDTRewardedVideoAdDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, strong) GDTRewardVideoAd *rewardedVideoAd;
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;
@property (nonatomic, weak) id<rewardedVideoCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
