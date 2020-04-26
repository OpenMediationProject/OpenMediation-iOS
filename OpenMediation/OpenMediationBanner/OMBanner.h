//
//  OMBanner.h
//  OpenMediation SDK
//
//  Copyright 2017 OM Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OMBannerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// Banner Ad Size
typedef NS_ENUM(NSInteger, OMBannerType) {
    OMBannerTypeDefault = 0,        ///ad size: 320 x 50
    OMBannerTypeMediumRectangle = 1,///ad size: 300 x 250
    OMBannerTypeLeaderboard = 2     ///ad size: 728x90
};

/// Banner Ad layout attribute
typedef NS_ENUM(NSInteger, OMBannerLayoutAttribute) {
    OMBannerLayoutAttributeTop = 0,
    OMBannerLayoutAttributeLeft = 1,
    OMBannerLayoutAttributeBottom = 2,
    OMBannerLayoutAttributeRight = 3,
    OMBannerLayoutAttributeHorizontally = 4,
    OMBannerLayoutAttributeVertically = 5
};

/// A customized UIView to represent a OpenMediation ad (banner ad).
@interface OMBanner : UIView

@property(nonatomic, readonly, nullable) NSString *placementID;

/// the delegate
@property (nonatomic, weak)id<OMBannerDelegate> delegate;

/// The banner's ad placement ID.
- (NSString*)placementID;


/// This is a method to initialize an OMBanner.
/// type: The size of the ad. Default is OMBannerTypeDefault.
/// placementID: Typed access to the id of the ad placement.
- (instancetype)initWithBannerType:(OMBannerType)type placementID:(NSString *)placementID;

/// set the banner position.
- (void)addLayoutAttribute:(OMBannerLayoutAttribute)attribute constant:(CGFloat)constant;

/// Begins loading the OMBanner content. And to show with default controller([UIApplication sharedApplication].keyWindow.rootViewController) when load success.
- (void)loadAndShow;

@end

NS_ASSUME_NONNULL_END
