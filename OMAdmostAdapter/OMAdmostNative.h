// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMNativeCustomEvent.h"
#import "OMAdmostBannerClass.h"
#import "OMBidCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdmostNative : NSObject<OMNativeCustomEvent,AMRBannerDelegate>

@property (nonatomic, strong, nullable) AMRBanner *native;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *pid;
@property(nonatomic, weak, nullable) id<nativeCustomEventDelegate> delegate;
@property (nonatomic, weak) id<OMBidCustomEventDelegate> bidDelegate;
@property (nonatomic, strong) NSObject *baseView;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
