// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMNativeCustomEvent.h"
#import "OMPangleNativeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMPangleNative : NSObject<OMNativeCustomEvent,BUNativeAdDelegate,BUVideoAdViewDelegate>

@property (nonatomic, strong) BUNativeAd *adLoader;
@property (nonatomic, weak, readwrite) UIViewController *rootVC;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
