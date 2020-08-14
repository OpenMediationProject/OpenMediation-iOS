#ifndef OMFacebookInterstitialClass_h
#define OMFacebookInterstitialClass_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FBInterstitialAdDelegate;

@interface FBInterstitialAd : NSObject

@property (nonatomic, copy, readonly) NSString *placementID;

@property (nonatomic, weak, nullable) id<FBInterstitialAdDelegate> delegate;

- (instancetype)initWithPlacementID:(NSString *)placementID NS_DESIGNATED_INITIALIZER;

@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;

- (void)loadAd;

- (void)loadAdWithBidPayload:(NSString *)bidPayload;

- (BOOL)showAdFromRootViewController:(nullable UIViewController *)rootViewController;

@end

@protocol FBInterstitialAdDelegate <NSObject>

@optional

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd;

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd;

- (void)interstitialAdWillClose:(FBInterstitialAd *)interstitialAd;

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd;

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error;

- (void)interstitialAdWillLogImpression:(FBInterstitialAd *)interstitialAd;

@end

NS_ASSUME_NONNULL_END

#endif /* OMFacebookInterstitialClass_h */
