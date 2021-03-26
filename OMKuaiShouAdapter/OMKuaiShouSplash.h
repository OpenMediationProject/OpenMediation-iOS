//
//  OMKsAdSplash.h
//  OpenMediationDemo
//
//  Created by M on 2021/1/26.
//  Copyright © 2021 AdTiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMKsAdSplashClass.h"
#import "OMSplashCustomEvent.h"


NS_ASSUME_NONNULL_BEGIN

@interface OMKsAdSplash : NSObject<OMSplashCustomEvent,KSAdSplashInteractDelegate>

@property (nonatomic, weak) id <splashCustomEventDelegate>delegate;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy, class) NSString *posId;
@property (nonatomic, weak, class) id<KSAdSplashInteractDelegate> interactDelegate;

@property (nonatomic, assign) BOOL adReadyFlag;

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size;
- (void)loadAd;
- (BOOL)isReady;
- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
