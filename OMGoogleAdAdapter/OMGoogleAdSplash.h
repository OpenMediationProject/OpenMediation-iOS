// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMSplashCustomEvent.h"
#import "OMGoogleAdSplashClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMGoogleAdSplash : NSObject<OMSplashCustomEvent,GADFullScreenContentDelegate>

@property (nonatomic, weak) id <splashCustomEventDelegate> delegate;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) GADAppOpenAd *appOpenAd;
@property (nonatomic, assign) CGSize adSize;
@property (nonatomic, strong) NSDate *loadTime;
@property (nonatomic, assign) BOOL ready;

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size;
- (void)loadAd;
- (BOOL)isReady;
- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
