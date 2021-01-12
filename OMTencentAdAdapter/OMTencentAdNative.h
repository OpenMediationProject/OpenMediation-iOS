// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMTencentAdNativeClass.h"
#import "OMNativeCustomEvent.h"
NS_ASSUME_NONNULL_BEGIN
@class OMTencentAdNative;

@interface OMTencentAdNative : NSObject<OMNativeCustomEvent,GDTUnifiedNativeAdDelegate, GDTUnifiedNativeAdViewDelegate>

@property (nonatomic, strong) GDTUnifiedNativeAd *gdtNativeAd;
@property(nonatomic, strong) GDTUnifiedNativeAdDataObject *currentAdData;
@property (nonatomic, weak) UIViewController *rootVC;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;
- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
