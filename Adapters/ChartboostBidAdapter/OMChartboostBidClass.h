// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMChartboostBidClass_h
#define OMChartboostBidClass_h

typedef NS_ENUM( NSUInteger, HeliumErrorCode ) {
    HeliumErrorCode_NoAdFound,
    HeliumErrorCode_NoBid,
    HeliumErrorCode_NoNetwork,
    HeliumErrorCode_ServerError,
    HeliumErrorCode_PartnerError,
    HeliumErrorCode_StartUpError,
    HeliumErrorCode_Unknown
};
@interface HeliumError : NSObject
@property (assign,readonly) HeliumErrorCode errorCode;
@property (nonatomic,readonly) NSString *errorDescription;
@end


@class UIViewController;
@class HeliumError;
@protocol HeliumSdkDelegate <NSObject>
- (void)heliumDidStartWithError:(HeliumError *)error;
@end
@protocol HeliumInterstitialAd <NSObject>
- (void) loadAd;
- (void) showAdWithViewController:(UIViewController *)vc;
- (BOOL) readyToShow;
@end
@protocol CHBHeliumInterstitialAdDelegate <NSObject>
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                           didLoadWithError:(HeliumError *)error;
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                           didShowWithError:(HeliumError *)error;
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                            didCloseWithError:(HeliumError *)error;
@optional
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                    didLoadWinningBidWithInfo:(NSDictionary*)bidInfo;
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                            didClickWithError:(HeliumError *)error;
@end
@protocol HeliumRewardedAd <NSObject>
- (void) loadAd;
- (void) showAdWithViewController:(UIViewController *)vc;
- (BOOL) readyToShow;
@end
@protocol CHBHeliumRewardedAdDelegate <NSObject>
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                            didLoadWithError:(HeliumError *)error;
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                            didShowWithError:(HeliumError *)error;
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                        didCloseWithError:(HeliumError *)error;
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                           didGetReward:(NSInteger)reward;
@optional
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                    didLoadWinningBidWithInfo:(NSDictionary*)bidInfo;
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                            didClickWithError:(HeliumError *)error;
@end

@interface HeliumSdk : NSObject
+ (HeliumSdk *)sharedHelium ;
- (void)startWithAppId:(NSString *)appId andAppSignature:(NSString*)appSignature delegate:(id<HeliumSdkDelegate>)delegate;
- (id<HeliumInterstitialAd>)interstitialAdProviderWithDelegate:(id<CHBHeliumInterstitialAdDelegate>)delegate andPlacementName:(nonnull NSString *)placementName;
- (id<HeliumRewardedAd>)rewardedAdProviderWithDelegate:(id<CHBHeliumRewardedAdDelegate>)delegate andPlacementName:(nonnull NSString *)placementName;
- (void)setSubjectToCoppa:(BOOL)isSubject;
- (void)setSubjectToGDPR:(BOOL)isSubject;
- (void)setUserHasGivenConsent:(BOOL)hasGivenConsent;
- (void)setCCPAConsent:(BOOL)hasGivenConsent;
@end


@protocol ChartboostBidDelegate <NSObject>

- (void)bidReseponse:(NSObject*)bidAdapter bid:(nullable NSDictionary*)bidInfo error:(nullable NSError*)error;
@end

#endif /* OMChartboostBidClass_h */
