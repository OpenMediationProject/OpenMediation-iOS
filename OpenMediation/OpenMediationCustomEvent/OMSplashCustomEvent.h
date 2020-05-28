// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMCustomEventDelegate.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol OMSplashCustomEvent;

@protocol splashCustomEventDelegate <OMCustomEventDelegate>

- (void)splashCustomEventDidShow:(id<OMSplashCustomEvent>)adapter;
- (void)splashCustomEventDidClick:(id<OMSplashCustomEvent>)adapter;
- (void)splashCustomEventDidClose:(id<OMSplashCustomEvent>)adapter;
- (void)splashCustomEventFailToShow:(id<OMSplashCustomEvent>)adapter error:(NSError*)error;
@end

@protocol OMSplashCustomEvent<NSObject>
@property(nonatomic, weak, nullable) id<splashCustomEventDelegate> delegate;
- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size fetchTime:(CGFloat)fetchTime;
- (void)loadAd;
- (BOOL)isReady;
- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView;
@end

NS_ASSUME_NONNULL_END
