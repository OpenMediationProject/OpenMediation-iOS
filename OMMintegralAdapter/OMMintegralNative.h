// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMNativeCustomEvent.h"
#import "OMMintegralNativeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMMintegralNative : NSObject<OMNativeCustomEvent,MTGNativeAdManagerDelegate,MTGMediaViewDelegate,MTGBidNativeAdManagerDelegate>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) MTGNativeAdManager *mtgManager;
@property (nonatomic, strong) MTGBidNativeAdManager *mtgBidManager;
@property (nonatomic, strong) MTGCampaign *campaign;
@property (nonatomic, weak, readwrite) UIViewController *rootVC;
@property (nonatomic, weak) id<nativeCustomEventDelegate> delegate;
@property (nonatomic, assign) BOOL hasShown;

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController;
- (void)loadAd;
- (void)loadAdWithBidPayload:(NSString *)bidPayload;

@end

NS_ASSUME_NONNULL_END
