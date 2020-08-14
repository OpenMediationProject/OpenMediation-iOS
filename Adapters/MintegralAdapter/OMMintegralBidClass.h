// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralBidClass_h
#define OMMintegralBidClass_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, MTGBidErrorCode) {
    kMTGBidErrorCodeUnknownError                             = 12930001,
    kMTGBidErrorCodeInvalidInput                             = 12930002,
    kMTGBidErrorCodeConnectionLost                           = 12930003,
    kMTGBidErrorCodeResponseParametersInvalid                = 12930004,
};

typedef NS_ENUM (NSInteger, MTGBidLossedReasonCode) {
    MTGBidLossedReasonCodeLowPrice                           = 1,
    MTGBidLossedReasonCodeBidTimeout                         = 2,
    MTGBidLossedReasonCodeWonNotShow                         = 3,
};

typedef NS_ENUM(NSInteger,MTGBannerSizeType) {
    /*Represents the fixed banner ad size - 320pt by 50pt.*/
    MTGStandardBannerType320x50,
    
    /*Represents the fixed banner ad size - 320pt by 90pt.*/
    MTGLargeBannerType320x90,
    
    /*Represents the fixed banner ad size - 300pt by 250pt.*/
    MTGMediumRectangularBanner300x250,
    
    /*if device height <=720,Represents the fixed banner ad size - 320pt by 50pt;
      if device height > 720,Represents the fixed banner ad size - 728pt by 90pt*/
    MTGSmartBannerType
};

@interface MTGBiddingSDK : NSObject

/* BuyerUID is required when you decide to request a bid response on your own server. */
+ (NSString *)buyerUID;

@end

@interface MTGBiddingResponse :NSObject

@property (nonatomic,assign,readonly) BOOL success;
@property (nonatomic,strong,readonly) NSError *error;
@property (nonatomic,assign,readonly) double price;
/**
 Default is USD
 */
@property (nonatomic,copy,readonly) NSString *currency;
/**
 You will need to use this value when you request the ads
 */
@property (nonatomic,copy,readonly) NSString *bidToken;

-(void)notifyWin;
-(void)notifyLoss:(MTGBidLossedReasonCode)reasonCode;

@end

@interface MTGBiddingRequestParameter : NSObject

@property(nonatomic,copy,readonly)NSString *placementId;
@property(nonatomic,copy,readonly)NSString *unitId;
@property(nonatomic,readonly)NSNumber *basePrice;

/**
 Initialize an MTGBiddingRequestParameter object
 @param placementId placementId
 @param unitId unitId
 @param basePrice The optional value provided to this method should be double,the requested bid should not be lower than this price if use this value
 */
- (instancetype)initWithPlacementId:(nullable NSString *)placementId
                             unitId:(nonnull NSString *) unitId
                          basePrice:(nullable NSNumber *)basePrice;

@end

@interface MTGBiddingRequest : NSObject

/**
  Get Mintegral Bid for current ad unit
  @param requestParameter
 
  NOTE:requestParameter --You need to construct an MTGBiddingRequestParameter object or his subclass object.
       If it is banner ad, you need to construct an MTGBiddingBannerRequestParameter object.
  */
+(void)getBidWithRequestParameter:(nonnull __kindof MTGBiddingRequestParameter *)requestParameter completionHandler:(void(^)(MTGBiddingResponse *bidResponse))completionHandler;

@end

@interface MTGBiddingBannerRequestParameter : MTGBiddingRequestParameter
/**
    banner unit size
 */
@property(nonatomic,assign,readonly)CGSize unitSize;

/**
  Initialize an MTGBiddingBannerRequestParameter object
  @param unitId unitId
  @param basePrice The optional value provided to this method should be double,the requested bid should not be lower than this price if use this value
  @param unitSize banner unit size
 */
- (instancetype)initWithPlacementId:(nullable NSString *)placementId
                             unitId:(nonnull NSString *) unitId
                          basePrice:(nullable NSNumber *)basePrice
                           unitSize:(CGSize)unitSize;

/**
 Initialize an MTGBiddingBannerRequestParameter object
 @param unitId unitId
 @param basePrice The optional value provided to this method should be double,the requested bid should not be lower than this price if use this value
 @param unitSize MTGBannerSizeTypeFormat
*/
- (instancetype)initWithPlacementId:(nullable NSString *)placementId
                             unitId:(nonnull NSString *) unitId
                          basePrice:(nullable NSNumber *)basePrice
                     bannerSizeType:(MTGBannerSizeType)bannerSizeType;
@end


NS_ASSUME_NONNULL_END

#endif /* OMMintegralBidClass_h */
