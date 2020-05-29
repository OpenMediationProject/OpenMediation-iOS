// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMSplashCustomEvent.h"
#import "OMMintegralSplashClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMMintegralSplash : NSObject<OMSplashCustomEvent,MTGSplashADDelegate>

@property (nonatomic, weak) id <splashCustomEventDelegate> delegate;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) MTGSplashAD *splashAD;
@property (nonatomic, assign) CGSize adSize;

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size;
- (void)loadAd;
- (BOOL)isReady;
- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
