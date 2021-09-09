// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediatedNativeAd.h"
#import "OMTencentAdNativeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMTencentAdNativeAd : NSObject<OMMediatedNativeAd>
/// Title.
@property (nonatomic, copy) NSString *title;

/// Body.
@property (nonatomic, copy) NSString *body;

/// Icon image.
@property (nonatomic, copy) NSString *iconUrl;

/// Text that encourages user to take some action with the ad. For example "Install".
@property (nonatomic, copy) NSString *callToAction;

/// App store rating (0 to 5).
@property (nonatomic, assign) double rating;

/// Native view class string.
@property (nonatomic, copy) NSString *nativeViewClass;


@property (nonatomic, strong) GDTUnifiedNativeAdDataObject *adObject;

@property (nonatomic, weak) id adLoader;

-(instancetype)initWithGdtDataObject:(GDTUnifiedNativeAdDataObject *)gdtDataObject;

@end

NS_ASSUME_NONNULL_END
