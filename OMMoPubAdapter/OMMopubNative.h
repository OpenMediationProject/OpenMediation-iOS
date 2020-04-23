// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMopubNativeClass.h"
#import "OMNativeCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMMopubNative : NSObject <OMNativeCustomEvent,MPNativeAdDelegate>
@property (nonatomic, strong) MPImageDownloadQueue *imageDownloadQueue;
@property (nonatomic, strong) MPNativeAdRequest *adLoader;
@property (nonatomic, strong) MPNativeAd *nativeAd;
@property (nonatomic, weak) UIViewController *rootController;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;
@end

NS_ASSUME_NONNULL_END
