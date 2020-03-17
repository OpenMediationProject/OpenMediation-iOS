// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMFacebookBidClass_h
#define OMFacebookBidClass_h

NS_ASSUME_NONNULL_BEGIN

@interface FBAdBidResponse : NSObject
- (NSString *)getPlatformAuctionID;
- (NSString *)getBidRequestID;
- (NSString *)getImpressionID;
- (NSString *)getPlacementID;
- (double)getPrice;
- (nullable NSString *)getCurrency;
- (nullable NSString *)getPayload;
- (nullable NSString *)getErrorMessage;
- (BOOL)getIsNetworkTimedOut;
- (nullable NSString *)getFBDebugHeader;
- (NSInteger)getHttpStatusCode;
- (void)notifyWin;
- (void)notifyLoss;
- (BOOL)isSuccess;
@end


typedef NS_ENUM(NSInteger, FBAdBidFormat) {
    // Bid For Banner 300x50
    FBAdBidFormatBanner_300_50,
    // Bid For Banner 320x50
    FBAdBidFormatBanner_320_50,
    // Bid For Banner with flexible width and height 50
    FBAdBidFormatBanner_HEIGHT_50,
    // Bid For Banner with flexible width and height 90
    FBAdBidFormatBanner_HEIGHT_90,
    // Bid For Banner with flexible width and height 250
    FBAdBidFormatBanner_HEIGHT_250,
    // Bid For Interstitial
    FBAdBidFormatInterstitial,
    // Bid For Native
    FBAdBidFormatNative,
    // Bid For Native Banner
    FBAdBidFormatNativeBanner,
    // Bid For Rewarded Video
    FBAdBidFormatRewardedVideo,
    // Bid For Instream Video
    FBAdBidFormatInstreamVideo,
};

typedef NS_ENUM(NSInteger, FBAdBidAuctionType) {
    FBAdBidAuctionType_First_Price = 1,
    FBAdBidAuctionType_Second_Price = 2
};

@interface FBAdBidRequest: NSObject

/**
 Get Audience Nework Bid for app with default settings:
 Default max time out is set to 10000 ms
 Default auction type is FBAdBidAuctionType_First_Price
 Default Children's Online Privacy Protection Act (COPPA) is FALSE
 Uses system setting for assigning do-not-track-value
 */
+ (void)getAudienceNetworkBidForAppID:(NSString *)appID
                          placementID:(NSString *)placementID
                           platformID:(NSString *)platformID
                             adFormat:(FBAdBidFormat)bidAdFormat
                     responseCallback:(void(^)(FBAdBidResponse *bidResponse))callback;

/**
 Get Audience Nework Bid for app
 isAdvertisingTrackingEnabled from Systems settings takes precendence over doNotTrack param
 when isAdvertisingTrackingEnabled is false
 */
+ (void)getAudienceNetworkBidForAppID:(NSString *)appID
                          placementID:(NSString *)placementID
                           platformID:(NSString *)platformID
                             adFormat:(FBAdBidFormat)bidAdFormat
                         maxTimeoutMS:(NSInteger)maxTimeoutMS
                                coppa:(BOOL)coppa // Children's Online Privacy Protection Act (COPPA) TRUE(1)=child-directed, FALSE(0)=normal (default)
                          auctionType:(FBAdBidAuctionType)auctionType
                           doNotTrack:(BOOL)dnt // // TRUE(1): do-not-track FALSE(0): normal
                     responseCallback:(void(^)(FBAdBidResponse *bidResponse))callback;

/**
 Get Audience Nework Test Bid for app
 */
+ (void)getAudienceNetworkTestBidForAppID:(NSString *)appID
                              placementID:(NSString *)placementID
                               platformID:(NSString *)platformID
                                 adFormat:(FBAdBidFormat)bidAdFormat
                             maxTimeoutMS:(NSInteger)maxTimeoutMS
                         responseCallback:(void(^)(FBAdBidResponse *bidResponse))callback;

@end

NS_ASSUME_NONNULL_END

#endif /* OMFacebookBidClass_h */
