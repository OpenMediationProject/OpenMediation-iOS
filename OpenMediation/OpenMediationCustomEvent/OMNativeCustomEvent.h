// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMCustomEventDelegate.h"
#import "OMBidCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMNativeCustomEvent;

@protocol nativeCustomEventDelegate <OMCustomEventDelegate>
- (void)nativeCustomEventWillShow:(id)adObject;
- (void)nativeCustomEventDidClick:(id)adObject;

@end

@protocol OMNativeCustomEvent<NSObject>
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;
- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
@optional
- (void)setBidDelegate:(id<OMBidCustomEventDelegate>)bidDelegate;
- (void)loadAd;
- (void)loadAdWithBidPayload:(NSString*)bidPayload;
@end

NS_ASSUME_NONNULL_END
