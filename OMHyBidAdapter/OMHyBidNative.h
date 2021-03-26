// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMHyBidNativeClass.h"
#import "OMNativeCustomEvent.h"
#import "OMHyBidClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMHyBidNative : NSObject<OMNativeCustomEvent,HyBidNativeAdLoaderDelegate,HyBidNativeAdDelegate>

@property (nonatomic, strong) HyBidNativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) HyBidNativeAd *nativeAd;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, weak) id<HyBidDelegate> bidDelegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
