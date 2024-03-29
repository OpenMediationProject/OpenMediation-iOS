// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMInterstitialCustomEvent.h"
#import "OMSigMobInterstitialClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMSigMobInterstitial : NSObject<OMInterstitialCustomEvent,WindIntersititialAdDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) WindIntersititialAd *interstitialAd;
@property (nonatomic, getter=isAdReady, readonly) BOOL ready;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
