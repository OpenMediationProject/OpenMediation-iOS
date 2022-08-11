// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMInterstitialCustomEvent.h"
#import "OMAdMobInterstitialClass.h"

NS_ASSUME_NONNULL_BEGIN



@interface OMAdMobInterstitial : NSObject <OMInterstitialCustomEvent,GADFullScreenContentDelegate>

@property (nonatomic, strong) GADInterstitialAd *admobInterstitial;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;
@property (nonatomic, assign) BOOL ready;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
