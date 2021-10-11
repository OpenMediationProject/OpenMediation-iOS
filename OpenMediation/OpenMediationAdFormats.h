// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OpenMediationAdFormats_h
#define OpenMediationAdFormats_h

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, OpenMediationAdFormat) {
    OpenMediationAdFormatNone = 0,
    OpenMediationAdFormatBanner = (1 << 0),
    OpenMediationAdFormatNative = (1 << 1),
    OpenMediationAdFormatRewardedVideo = (1 << 2),
    OpenMediationAdFormatInterstitial = (1 << 3),
    OpenMediationAdFormatSplash = (1 << 4),
    OpenMediationAdFormatCrossPromotion = (1 << 5),
};

#endif /* OpenMediationAdFormats_h */
