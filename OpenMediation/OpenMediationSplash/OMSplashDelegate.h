// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

@class OMSplash;

NS_ASSUME_NONNULL_BEGIN

@protocol OMSplashDelegate<NSObject>

@optional

- (void)omSplashDidLoad:(OMSplash *)splash;

- (void)omSplashFailToLoad:(OMSplash *)splash withError:(NSError *)error;

- (void)omSplashDidShow:(OMSplash *)splash;

- (void)omSplashDidClick:(OMSplash *)splash;

- (void)omSplashDidClose:(OMSplash *)splash;

- (void)omSplashDidFailToShow:(OMSplash *)splash withError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
