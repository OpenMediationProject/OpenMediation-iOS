// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMScene.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMInterstitialDelegate <NSObject>

@optional

/// Invoked when a interstitial video is available.
- (void)omInterstitialChangedAvailability:(BOOL)available;

/// Sent immediately when a interstitial video is opened.
- (void)omInterstitialDidOpen:(OMScene*)scene;

/// Sent immediately when a interstitial video starts to play.
- (void)omInterstitialDidShow:(OMScene*)scene;

/// Sent after a interstitial video has been clicked.
- (void)omInterstitialDidClick:(OMScene*)scene;

/// Sent after a interstitial video has been closed.
- (void)omInterstitialDidClose:(OMScene*)scene;

/// Sent after a interstitial video has failed to play.
- (void)omInterstitialDidFailToShow:(OMScene*)scene withError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
