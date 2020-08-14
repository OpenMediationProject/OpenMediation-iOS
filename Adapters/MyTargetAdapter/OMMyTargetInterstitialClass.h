// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMyTargetInterstitialClass_h
#define OMMyTargetInterstitialClass_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MTRGInterstitialAd;

@protocol MTRGInterstitialAdDelegate <NSObject>

- (void)onLoadWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd;

- (void)onNoAdWithReason:(NSString *)reason interstitialAd:(MTRGInterstitialAd *)interstitialAd;

@optional

- (void)onClickWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd;

- (void)onCloseWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd;

- (void)onVideoCompleteWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd;

- (void)onDisplayWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd;

- (void)onLeaveApplicationWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd;

@end

@class MTRGCustomParams;

@interface MTRGInterstitialAd : NSObject

@property(nonatomic) BOOL mediationEnabled;
@property(nonatomic, weak, nullable) id <MTRGInterstitialAdDelegate> delegate;
@property(nonatomic, readonly, nullable) NSString *adSource;
@property(nonatomic, readonly) MTRGCustomParams *customParams;

+ (instancetype)interstitialAdWithSlotId:(NSUInteger)slotId;

- (instancetype)initWithSlotId:(NSUInteger)slotId;

- (void)load;

- (void)loadFromBid:(NSString *)bidId;

- (void)showWithController:(UIViewController *)controller;

- (void)showModalWithController:(UIViewController *)controller;

- (void)close;

@end

@class MTRGCustomParams;

@interface MTRGBaseAd : NSObject

@property(nonatomic, readonly) MTRGCustomParams *customParams;

@end

NS_ASSUME_NONNULL_END

#endif /* OMMyTargetInterstitialClass_h */
