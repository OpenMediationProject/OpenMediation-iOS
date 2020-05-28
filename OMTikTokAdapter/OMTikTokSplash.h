// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMTikTokSplashClass.h"
#import "OMSplashCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMTikTokSplash : NSObject<OMSplashCustomEvent,BUSplashAdDelegate>

@property (nonatomic, weak) id <splashCustomEventDelegate>delegate;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) BUSplashAdView *splashView;

@property (nonatomic, assign) CGFloat fetchTime;

@property (nonatomic, assign) CGRect AdFrame;

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size fetchTime:(CGFloat)fetchTime;
- (void)loadAd;
- (BOOL)isReady;
- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
