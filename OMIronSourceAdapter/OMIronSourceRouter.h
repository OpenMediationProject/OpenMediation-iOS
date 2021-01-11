// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMIronSourceClass.h"
#import "OMIronSourceAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMIronSourceAdapterDelegate <NSObject>

- (void)OMIronSourceDidReceiveReward;
- (void)OMIronSourceDidload;
- (void)OMIronSourceDidFailToLoad:(NSError*)error;
- (void)OMIronSourceDidStart;
- (void)OMIronSourceDidClick;
- (void)OMIronSourceVideoEnd;
- (void)OMIronSourceDidFinish;
- (void)OMIronSourceDidFailToShow:(NSError *)error;
@end

@interface OMIronSourceRouter : NSObject<ISDemandOnlyInterstitialDelegate,ISDemandOnlyRewardedVideoDelegate>

@property (nonatomic, strong) NSMutableDictionary *placementDelegateMap;

+ (instancetype)sharedInstance;
- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
