// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMScene.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMRewardedVideoDelegate <NSObject>

@optional

/// Invoked when a rewarded video is available.
- (void)omRewardedVideoChangedAvailability:(BOOL)available;

/// Sent immediately when a rewarded video is opened.
- (void)omRewardedVideoDidOpen:(OMScene*)scene;

/// Sent immediately when a rewarded video starts to play.
- (void)omRewardedVideoPlayStart:(OMScene*)scene;

/// Send after a rewarded video has been completed.
- (void)omRewardedVideoPlayEnd:(OMScene*)scene;

/// Sent after a rewarded video has been clicked.
- (void)omRewardedVideoDidClick:(OMScene*)scene;

/// Sent after a user has been granted a reward.
- (void)omRewardedVideoDidReceiveReward:(OMScene*)scene;

/// Sent after a rewarded video has been closed.
- (void)omRewardedVideoDidClose:(OMScene*)scene;

/// Sent after a rewarded video has failed to play.
- (void)omRewardedVideoDidFailToShow:(OMScene*)scene withError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
