// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMFacebookClass_h
#define OMFacebookClass_h

NS_ASSUME_NONNULL_BEGIN


@interface FBAdSettings : NSObject

/// Data processing options.
/// Please read more details at https://developers.facebook.com/docs/marketing-apis/data-processing-options
///
/// @param options Processing options you would like to enable for a specific event. Current accepted value is LDU for
/// Limited Data Use.
/// @param country A country that you want to associate to this data processing option. Current accepted values are 1,
/// for the United States of America, or 0, to request that we geolocate that event.
/// @param state A state that you want to associate with this data processing option. Current accepted values are 1000,
/// for California, or 0, to request that we geolocate that event.
+ (void)setDataProcessingOptions:(NSArray<NSString *> *)options country:(NSInteger)country state:(NSInteger)state;

/// Data processing options.
/// Please read more details at https://developers.facebook.com/docs/marketing-apis/data-processing-options
///
/// @param options Processing options you would like to enable for a specific event. Current accepted value is LDU for
/// Limited Data Use.
+ (void)setDataProcessingOptions:(NSArray<NSString *> *)options;

@end

NS_ASSUME_NONNULL_END

#endif /* OMFacebookClass_h */
