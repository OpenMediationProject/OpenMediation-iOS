// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMScene.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMCrossPromotionDelegate <NSObject>

@optional

/// Invoked when promotion ad is available.
- (void)omCrossPromotionChangedAvailability:(BOOL)available;

/// Sent immediately when promotion ad will appear.
- (void)omCrossPromotionWillAppear:(OMScene*)scene;

/// Sent after a promotion ad has been clicked.
- (void)omCrossPromotionDidClick:(OMScene*)scene;

/// Sent after a promotion ad did disappear.
- (void)omCrossPromotionDidDisappear:(OMScene*)scene;

/// Sent after a promotion ad has failed to play.
- (void)omCrossPromotionDidFailToShow:(OMScene*)scene withError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
