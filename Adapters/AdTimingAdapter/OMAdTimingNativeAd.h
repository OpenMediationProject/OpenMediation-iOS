// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediatedNativeAd.h"
#import "OMAdTimingNativeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdTimingNativeAd : NSObject<OMMediatedNativeAd>

/// Typed access to the ad title.
@property (nonatomic, copy) NSString *title;

/// Typed access to the body text, usually a longer description of the ad.
@property (nonatomic, copy) NSString *body;

/// Typed access to the ad icon.
@property (nonatomic, copy) NSString *iconUrl;

/// Typed access to the call to action phrase of the ad.
@property (nonatomic, copy) NSString *callToAction;

/// Typed access to the ad star rating.
@property (nonatomic, assign) double rating;

/// Native view class string.
@property (nonatomic, copy) NSString *nativeViewClass;

@property (nonatomic, strong) AdTimingBidNativeAd *adtNativeAd;

- (instancetype)initWithAdTimingNativeAd:(AdTimingBidNativeAd*)adtNativeAd;

@end

NS_ASSUME_NONNULL_END
