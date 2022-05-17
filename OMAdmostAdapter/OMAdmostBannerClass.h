// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdmostBannerClass_h
#define OMAdmostBannerClass_h
#import "OMAdmostClass.h"


@class AMRBanner, AMRError;

/**
 * @protocol AMRBannerDelegate
 * @brief The AMRBannerDelegate protocol.
 * This protocol is used as a delegate for banner events.
 */
@protocol AMRBannerDelegate <NSObject>

/**
 * Successfully received a banner. Add AMRBanner's bannerView as a subview to show banner.
 * Example usage:
 * @code
 * [self.view addSubview:banner.bannerView];
 * @endcode
 * @param banner AMRBanner object with a bannerView to show
 */
- (void)didReceiveBanner:(AMRBanner *)banner;

/**
 * Failed to receive a banner. Inspect AMRError's errorCode and errorDescription properties to identify the problem.
 * @param banner Failed AMRBanner object
 * @param error AMRError object with error code and descriptions
 */
- (void)didFailToReceiveBanner:(AMRBanner *)banner error:(AMRError *)error;

/**
 * Successfully shown received banner.
 * @param banner Shown AMRBanner object.
 */
- (void)didShowBanner:(AMRBanner *)banner;

/**
 * User clicked banner.
 * @param banner Clicked AMRBanner object
 */
- (void)didClickBanner:(AMRBanner *)banner;

@end

@class AMRPlacement;

@interface AMRBannerView : UIView
@property AMRPlacement *placement;

@property NSURL *customNativeBannerIconURL;
@property NSString *customNativeBannerDetailText;
@property NSString *customNativeBannerHeaderText;
@property NSString *customNativeBannerCtaText;
@property NSInteger customNativeBannerDuration;
@end


@interface AMRBanner : AMRAd

/// An object conforms to <AMRBannerDelegate> protocol.
@property (weak) id<AMRBannerDelegate> delegate;
/// A UIView to add as a subview to show banner.
@property AMRBannerView *bannerView;
/// A parent UIViewController required to catch taps.
@property UIViewController *viewController;
/// Width value of banner, default is 320px for 50px, 300px for 250px, 728px for 90px.
@property (nonatomic) CGFloat bannerWidth;
/// Custom size for custom native ads
@property (nonatomic) CGSize customNativeSize;
/// Custom native ad xib name
@property NSString *customeNativeXibName;

/**
 * Create an instance of AMRBanner to show in your application.
 * Example usage:
 * @code
 * [AMRBanner bannerForZoneId:@"<zoneId>"];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param zoneId Your banner's zone ID displayed on AMR Dashboard.
 * @return An instance of AMRBanner created by zoneId provided.
 */
+ (instancetype)bannerForZoneId:(NSString *)zoneId;

/**
 * Start asynchronous banner loading request. Delegate must be set before loading a banner ad.
 * Example usage:
 * @code
 * [banner loadBanner];
 * @endcode
 */
- (void)loadBanner;

/**
 * Start synchronous banner loading request.
 * Example usage:
 * @code
 * [_banner50 loadWithReceiveHandler:^(AMRBanner *banner) {
 *     [self.view addSubview:banner.bannerView];
 * } failHandler:^(AMRError *error) {
 *     NSLog(@"Failed with error: %@", error.description);
 * }];
 * @endcode
 */
- (void)loadWithReceiveHandler:(void (^)(AMRBanner *banner))receive
                   failHandler:(void (^)(AMRError *error))fail;

// start caching banner
- (void)cacheBanner;

@end

#endif /* OMAdmostBannerClass_h */
