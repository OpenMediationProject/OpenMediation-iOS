// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMKuaiShouInterstitialClass.h"
#import "OMInterstitialCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMKuaiShouInterstitial : NSObject<OMInterstitialCustomEvent,KSFullscreenVideoAdDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, assign) BOOL adReadyFlag;
@property (nonatomic, readonly) BOOL isValid;
@property (nonatomic, strong) KSFullscreenVideoAd *fullscreenVideoAd;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
