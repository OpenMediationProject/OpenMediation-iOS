// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdBase.h"
#import "OMAdBasePrivate.h"
#import "OMBannerCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol bannerDelegate<NSObject>
- (void)bannerDidLoad:(NSString *)instanceID;
- (void)bannerDidFailToLoadWithError:(NSError *)error;
- (void)bannerWillExposure;
- (void)bannerDidClick;
- (void)bannerWillPresentScreen;
- (void)bannerDidDissmissScreen;
- (void)bannerWillLeaveApplication;
@end

@interface OMBannerAd : OMAdBase<bannerCustomEventDelegate>

@property (nonatomic, weak)id<bannerDelegate> delegate;
@property (nonatomic, assign) BOOL impr;

@end

NS_ASSUME_NONNULL_END
