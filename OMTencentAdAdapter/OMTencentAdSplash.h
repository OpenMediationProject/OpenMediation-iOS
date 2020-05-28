// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMSplashCustomEvent.h"
#import "OMTencentAdSplashClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMTencentAdSplash : NSObject<GDTSplashAdDelegate,OMSplashCustomEvent>

@property (nonatomic, weak) id<splashCustomEventDelegate>delegate;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) GDTSplashAd *splashAd;
@property (nonatomic, assign) BOOL isLoadSuccess;

@property (nonatomic, assign) CGFloat fetchTime;

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size fetchTime:(CGFloat)fetchTime;
- (void)loadAd;
- (BOOL)isReady;
- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
