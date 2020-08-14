// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMyTargetBannerClass_h
#define OMMyTargetBannerClass_h

NS_ASSUME_NONNULL_BEGIN

@class MTRGAdView;
@class MTRGCustomParams;

typedef enum : NSUInteger
{
    MTRGAdSize_320x50 = 0,
    MTRGAdSize_300x250 = 1,
    MTRGAdSize_728x90 = 2
} MTRGAdSize;

@protocol MTRGAdViewDelegate <NSObject>

- (void)onLoadWithAdView:(MTRGAdView *)adView;

- (void)onNoAdWithReason:(NSString *)reason adView:(MTRGAdView *)adView;

@optional

- (void)onAdClickWithAdView:(MTRGAdView *)adView;

- (void)onAdShowWithAdView:(MTRGAdView *)adView;

- (void)onShowModalWithAdView:(MTRGAdView *)adView;

- (void)onDismissModalWithAdView:(MTRGAdView *)adView;

- (void)onLeaveApplicationWithAdView:(MTRGAdView *)adView;

@end

@interface MTRGAdView : UIView

@property(nonatomic, weak, nullable) id <MTRGAdViewDelegate> delegate;
@property(nonatomic, weak, nullable) UIViewController *viewController;
@property(nonatomic, readonly) MTRGCustomParams *customParams;
@property(nonatomic) BOOL trackLocationEnabled;
@property(nonatomic) BOOL mediationEnabled;
@property(nonatomic, readonly) MTRGAdSize adSize;
@property(nonatomic, readonly, nullable) NSString *adSource;

+ (void)setDebugMode:(BOOL)enabled;

+ (BOOL)isDebugMode;

+ (instancetype)adViewWithSlotId:(NSUInteger)slotId;

+ (instancetype)adViewWithSlotId:(NSUInteger)slotId adSize:(MTRGAdSize)adSize;

+ (instancetype)adViewWithSlotId:(NSUInteger)slotId withRefreshAd:(BOOL)refreshAd adSize:(MTRGAdSize)adSize;

- (instancetype)initWithSlotId:(NSUInteger)slotId;

- (instancetype)initWithSlotId:(NSUInteger)slotId adSize:(MTRGAdSize)adSize;

- (instancetype)initWithSlotId:(NSUInteger)slotId withRefreshAd:(BOOL)refreshAd adSize:(MTRGAdSize)adSize;

- (void)load;

- (void)loadFromBid:(NSString *)bidId;

@end

extern NSString *const kMTRGCustomParamsMediationKey;
extern NSString *const kMTRGCustomParamsMediationAdmob;
extern NSString *const kMTRGCustomParamsMediationMopub;

typedef enum
{
    MTRGGenderUnspecified = -1,
    MTRGGenderUnknown,
    MTRGGenderMale,
    MTRGGenderFemale
} MTRGGender;

@interface MTRGCustomParams : NSObject

@property(nullable) NSNumber *age;
@property(nonatomic) MTRGGender gender;
@property(copy, nullable) NSString *language;

@property(copy, nullable) NSString *email;
@property(copy, nullable) NSString *phone;
@property(copy, nullable) NSString *icqId;
@property(copy, nullable) NSString *okId;
@property(copy, nullable) NSString *vkId;

@property(copy, nullable) NSString *mrgsAppId;
@property(copy, nullable) NSString *mrgsUserId;
@property(copy, nullable) NSString *mrgsDeviceId;

+ (instancetype)create;

- (NSDictionary<NSString *, NSString *> *)asDictionary;

- (void)setCustomParam:(nullable NSString *)param forKey:(NSString *)key;

- (nullable NSString *)customParamForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

#endif /* OMMyTargetBannerClass_h */
