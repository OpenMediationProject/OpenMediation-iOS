// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OMCustomEventDelegate<NSObject>
- (void)customEvent:(id)adapter didLoadAd:(nullable id)adObject;
- (void)customEvent:(id)adapter didLoadWithAdnName:(NSString*)adnName;
- (void)customEvent:(id)adapter didFailToLoadWithError:(NSError*)error;
- (void)customEventAdDidExpired:(id)adapter;
@end

NS_ASSUME_NONNULL_END
