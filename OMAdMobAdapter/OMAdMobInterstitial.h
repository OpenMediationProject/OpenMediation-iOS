#import <Foundation/Foundation.h>
#import "OMAdMobInterstitialClass.h"
#import "OMInterstitialCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN



@interface OMAdMobInterstitial : NSObject <OMInterstitialCustomEvent,GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *admobInterstitial;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, weak) id<interstitialCustomEventDelegate> delegate;
@property (nonatomic, assign) BOOL ready;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)show:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
