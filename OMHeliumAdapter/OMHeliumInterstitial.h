// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMHeliumRouter.h"
#import "OMInterstitialCustomEvent.h"


NS_ASSUME_NONNULL_BEGIN

@interface OMHeliumInterstitial : NSObject <OMInterstitialCustomEvent,OMHeliumAdapterDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;
@property (nonatomic, weak) id<HeliumDelegate> bidDelegate;
@property (nonatomic, strong) NSDictionary *biInfo;
- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
