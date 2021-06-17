// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMPubNativeNativeClass.h"
#import "OMNativeCustomEvent.h"
#import "OMPubNativeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMPubNativeNative : NSObject<OMNativeCustomEvent,HyBidNativeAdLoaderDelegate,HyBidNativeAdDelegate>

@property (nonatomic, strong) HyBidNativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) HyBidNativeAd *nativeAd;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, weak) id<HyBidDelegate> bidDelegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
