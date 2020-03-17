// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMintegralInterstitialClass.h"
#import "OMInterstitialCustomEvent.h"


NS_ASSUME_NONNULL_BEGIN

@interface OMMintegralInterstitial : NSObject<OMInterstitialCustomEvent,MTGInterstitialVideoDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic,strong)  MTGInterstitialVideoAdManager *ivAdManager;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
