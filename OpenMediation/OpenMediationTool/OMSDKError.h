// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"
#import "NSError+OMExtension.h"
#import "OMError.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OMSDKErrorCode) {
    /// SDK init: invalid request.
    OMSDKErrorInitInvalidRequest = 111,
    /// SDK init: network error.
    OMSDKErrorInitNetworkError = 121,
    /// SDK init: server error.
    OMSDKErrorInitServerError = 131,
    /// Ad loading: Invalid request.
    OMSDKErrorLoadInvalidRequest = 211,
    /// Ad loading: network error.
    OMSDKErrorLoadNetworkError = 221,
    /// Ad loading: server error.
    OMSDKErrorLoadServerError = 231,
    /// No ad fill.
    OMSDKErrorNoAdFill = 241,
    /// Ad loading: SDK not initialized.
    OMSDKErrorLoadNotInitialized = 242,
    /// Ad loading: reached impression cap.
    OMSDKErrorLoadCapped = 243,
    /// Ad showing: invalid request.
    OMSDKErrorShowInvalidRequest = 311,
    /// Ad showing: ad isn't ready.
    OMSDKErrorNoAdReady = 341,
    /// Ad showing: SDK not initialized.
    OMSDKErrorShowNotInitialized = 342,
    /// Ad showing: reached scene impression cap.
    OMSDKErrorShowSceneCapped = 343,
    /// Ad showing failure.
    OMSDKErrorShowError = 345,
};

@interface OMSDKError : NSObject
+ (NSError*)errorWithAdtError:(NSError*)error;
+ (void)throwDeveloperError:(NSError*)error;
@end

NS_ASSUME_NONNULL_END
