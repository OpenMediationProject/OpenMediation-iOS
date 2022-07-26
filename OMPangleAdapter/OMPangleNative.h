// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMNativeCustomEvent.h"
#import "OMPangleNativeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMPangleNative : NSObject<OMNativeCustomEvent,BUNativeExpressAdViewDelegate,PAGLNativeAdDelegate>

@property (nonatomic, strong) BUNativeExpressAdManager *adLoader;
@property (nonatomic, weak, readwrite) UIViewController *rootVC;

// 海外
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) PAGLNativeAd *pagNativeAd;

@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;
@property (nonatomic, assign) BOOL hasShown;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
