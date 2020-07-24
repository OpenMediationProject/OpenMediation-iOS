// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMAdTimingNativeClass.h"
#import "OMNativeCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdTimingNative : NSObject<OMNativeCustomEvent,AdTimingAdsNativeDelegate>

@property (nonatomic, strong) AdTimingAdsNative *native;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;
@property (nonatomic, weak) UIViewController *rootVC;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;


@end

NS_ASSUME_NONNULL_END
