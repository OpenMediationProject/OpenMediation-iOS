// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3


#import <Foundation/Foundation.h>
#import "OMInterstitialCustomEvent.h"
#import "OMInMobiInterstitialClass.h"
#import "OMBidCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMInMobiInterstitial : NSObject<OMInterstitialCustomEvent,IMInterstitialDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) IMInterstitial *interstitial;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;
@property (nonatomic, weak) id<OMBidCustomEventDelegate> bidDelegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
