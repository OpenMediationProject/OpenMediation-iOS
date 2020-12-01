// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMCrossPromotionNativeAd.h"
#import "OMNativeCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionNative : NSObject<OMNativeCustomEvent,OMCrossPromotionNativeAdDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, weak) UIViewController *rootVC;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAdWithBidPayload:(NSString*)bidPayload;

@end

NS_ASSUME_NONNULL_END
