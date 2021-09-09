// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMCustomEventDelegate.h"
#import "OMBidCustomEvent.h"
NS_ASSUME_NONNULL_BEGIN

@protocol OMInterstitialCustomEvent;

@protocol interstitialCustomEventDelegate <OMCustomEventDelegate>

- (void)interstitialCustomEventDidOpen:(id<OMInterstitialCustomEvent>)adapter;
- (void)interstitialCustomEventDidShow:(id<OMInterstitialCustomEvent>)adapter;
- (void)interstitialCustomEventDidFailToShow:(id<OMInterstitialCustomEvent>)adapter error:(NSError*)error;
- (void)interstitialCustomEventDidClick:(id<OMInterstitialCustomEvent>)adapter;
- (void)interstitialCustomEventDidClose:(id<OMInterstitialCustomEvent>)adapter;

@end

@protocol OMInterstitialCustomEvent<NSObject>
@property(nonatomic, weak, nullable) id<interstitialCustomEventDelegate> delegate;
- (instancetype)initWithParameter:(NSDictionary*)adParameter;
@optional
- (void)setBidDelegate:(id<OMBidCustomEventDelegate>)bidDelegate;
- (void)loadAd;
- (void)loadAdWithBidPayload:(NSString*)bidPayload;
- (BOOL)isReady;
- (void)show:(UIViewController*)rootViewController;
@end

NS_ASSUME_NONNULL_END
