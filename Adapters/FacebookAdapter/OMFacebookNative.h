// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMFacebookNativeClass.h"
#import "OMNativeCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMFacebookNative : NSObject<OMNativeCustomEvent,FBNativeAdDelegate>

@property (nonatomic, strong) FBNativeAd *fbNativeAd;
@property (nonatomic, weak) UIViewController *rootVC;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;
- (void)loadAdWithBidPayload:(NSString *)bidPayload;

@end

NS_ASSUME_NONNULL_END
