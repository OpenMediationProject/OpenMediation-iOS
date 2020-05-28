// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OpenMediationAdFormats_h
#define OpenMediationAdFormats_h

typedef NS_ENUM(NSInteger, OpenMediationAdFormat) {
    OpenMediationAdFormatBanner = (1 << 0),
    OpenMediationAdFormatNative = (1 << 1),
    OpenMediationAdFormatRewardedVideo = (1 << 2),
    OpenMediationAdFormatInterstitial = (1 << 3),
    OpenMediationAdFormatSplash = (1 << 4),
};

#endif /* OpenMediationAdFormats_h */
