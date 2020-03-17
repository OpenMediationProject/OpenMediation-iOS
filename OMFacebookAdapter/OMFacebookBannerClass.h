#ifndef OMFacebookBannerClass_h
#define OMFacebookBannerClass_h

NS_ASSUME_NONNULL_BEGIN

@class FBAdView;

struct FBAdSize {
    CGSize size;
};

typedef struct FBAdSize FBAdSize;

@protocol FBAdViewDelegate <NSObject>

@optional

- (void)adViewDidClick:(FBAdView *)adView;

- (void)adViewDidFinishHandlingClick:(FBAdView *)adView;

- (void)adViewDidLoad:(FBAdView *)adView;

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error;

- (void)adViewWillLogImpression:(FBAdView *)adView;

@end

@interface FBAdView : UIView

- (instancetype)initWithPlacementID:(NSString *)placementID
                             adSize:(FBAdSize)adSize
                 rootViewController:(nullable UIViewController *)rootViewController NS_DESIGNATED_INITIALIZER;

- (void)loadAd;

- (void)loadAdWithBidPayload:(NSString *)bidPayload;

@property (nonatomic, weak, nullable) id<FBAdViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

#endif /* OMFacebookBannerClass_h */
