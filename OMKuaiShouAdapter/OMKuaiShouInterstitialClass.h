// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMKuaiShouInterstitialClass_h
#define OMKuaiShouInterstitialClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMKuaiShouAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KSFullscreenVideoAdDelegate;

@interface KSFullscreenVideoAd : KSVideoAd

@property (nonatomic, weak, nullable) id<KSFullscreenVideoAdDelegate> delegate;

- (instancetype)initWithPosId:(NSString *)posId;
@end


@protocol KSFullscreenVideoAdDelegate <NSObject>
@optional
/**
 This method is called when video ad material loaded successfully.
 */
- (void)fullscreenVideoAdDidLoad:(KSFullscreenVideoAd *)fullscreenVideoAd;
/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)fullscreenVideoAd:(KSFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error;
/**
 This method is called when cached successfully.
 */
- (void)fullscreenVideoAdVideoDidLoad:(KSFullscreenVideoAd *)fullscreenVideoAd;
/**
 This method is called when video ad slot will be showing.
 */
- (void)fullscreenVideoAdWillVisible:(KSFullscreenVideoAd *)fullscreenVideoAd;
/**
 This method is called when video ad slot has been shown.
 */
- (void)fullscreenVideoAdDidVisible:(KSFullscreenVideoAd *)fullscreenVideoAd;
/**
 This method is called when video ad is about to close.
 */
- (void)fullscreenVideoAdWillClose:(KSFullscreenVideoAd *)fullscreenVideoAd;
/**
 This method is called when video ad is closed.
 */
- (void)fullscreenVideoAdDidClose:(KSFullscreenVideoAd *)fullscreenVideoAd;

/**
 This method is called when video ad is clicked.
 */
- (void)fullscreenVideoAdDidClick:(KSFullscreenVideoAd *)fullscreenVideoAd;
/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)fullscreenVideoAdDidPlayFinish:(KSFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error;
/**
 This method is called when the video begin to play.
 */
- (void)fullscreenVideoAdStartPlay:(KSFullscreenVideoAd *)fullscreenVideoAd;
/**
 This method is called when the user clicked skip button.
 */
- (void)fullscreenVideoAdDidClickSkip:(KSFullscreenVideoAd *)fullscreenVideoAd;
@end

NS_ASSUME_NONNULL_END

#endif /* OMKuaiShouInterstitialClass_h */
