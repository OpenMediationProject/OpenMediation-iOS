// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMNativeCustomEvent.h"
@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface OMAdMobNative : NSObject<OMNativeCustomEvent,GADNativeAdLoaderDelegate,GADNativeAdDelegate,GADVideoControllerDelegate>

@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;
@property (nonatomic, assign) BOOL canLoadRequest;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
