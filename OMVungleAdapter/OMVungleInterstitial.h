//
//  OMVungleInterstitial.h
//  OMVungleAdapter
//
//  Created by M on 2023/4/12.
//  Copyright © 2023 AdTiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMInterstitialCustomEvent.h"
#import "OMVungleClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMVungleInterstitial : NSObject<VungleInterstitialDelegate,OMInterstitialCustomEvent>
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) VungleInterstitial *interstitialAd;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;
@property (nonatomic, assign) BOOL ready;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (void)loadAdWithBidPayload:(NSString *)bidPayload;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
