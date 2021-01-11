// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMInterstitialCustomEvent.h"
#import "OMAppLovinInterstitialClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAppLovinInterstitial : NSObject<OMInterstitialCustomEvent,ALAdDisplayDelegate, ALAdLoadDelegate,ALAdVideoPlaybackDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;
@property (nonatomic, strong) ALInterstitialAd *appLovinInterstitial;
@property (nonatomic, strong, nullable) ALAd *alAd;
@property (nonatomic, assign) BOOL ready;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
