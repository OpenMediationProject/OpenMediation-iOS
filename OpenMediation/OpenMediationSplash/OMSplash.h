// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OMSplashDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMSplash : NSObject

@property (nonatomic, weak)id<OMSplashDelegate> delegate;

- (instancetype)initWithPlacementId:(NSString *)placementId adSize:(CGSize)size fetchTime:(CGFloat)fetchTime;

- (void)loadAd;

- (BOOL)isReady;

- (void)showWithWindow:(UIWindow *)window customView:(nullable UIView *)customView;

@end

NS_ASSUME_NONNULL_END
