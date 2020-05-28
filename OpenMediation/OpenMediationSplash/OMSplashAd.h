// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdBase.h"
#import "OMAdBasePrivate.h"
#import "OMSplashCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol splashDelegate<NSObject>

- (void)splashDidLoad:(NSString *)instanceId;
- (void)splashDidFailToLoadWithError:(NSError *)error;
- (void)splashDidShow;
- (void)splashDidClick;
- (void)splashDidClose;
- (void)splashDidFailToShowWithError:(NSError*)error;
@end

@interface OMSplashAd : OMAdBase<splashCustomEventDelegate>
@property (nonatomic, weak)id<splashDelegate>delegate;
@property (nonatomic, assign) CGFloat fetchTime;
- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
