// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMBanner.h"
#import "OpenMediationConstant.h"
#import "OMModelUmbrella.h"
#import "OMNetworkUmbrella.h"
#import "OMToolUmbrella.h"
#import "OMBannerCustomEvent.h"
#import "OMConfig.h"
#import "OMBannerAd.h"
#import "OMEventManager.h"
#import "OMWeakObject.h"

@interface OMBanner ()<bannerDelegate> {
    OMBannerType _bannerType;
    CGSize _bannerSize;
}
@property (nonatomic, strong) OMBannerAd *bannerAd;
@property (nonatomic, strong) NSTimer *freshTimer;
@end

@implementation OMBanner

#pragma mark PublicMethod

- (instancetype)initWithBannerType:(OMBannerType)type placementID:(NSString *)placementID {
    _bannerSize = [self getBannerSizeWithBannerType:type];
    CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _bannerSize.height, _bannerSize.width, _bannerSize.height);
    if (self = [super initWithFrame:frame]) {
        self.bannerAd = [[OMBannerAd alloc]initWithPlacementID:placementID size:_bannerSize rootViewController:[UIViewController omRootViewController]];
        self.bannerAd.delegate = self;
    }
    return self;
}

- (void)addLayoutAttribute:(OMBannerLayoutAttribute)attribute constant:(CGFloat)constant {
    CGRect temp = self.frame;
    switch (attribute) {
        case OMBannerLayoutAttributeTop:
            temp.origin.y = constant;
            break;
        case OMBannerLayoutAttributeLeft:
            temp.origin.x = constant;
            break;
        case OMBannerLayoutAttributeBottom:
            temp.origin.y = [UIScreen mainScreen].bounds.size.height - constant - _bannerSize.height;
            break;
        case OMBannerLayoutAttributeRight:
            temp.origin.x = [UIScreen mainScreen].bounds.size.width - constant - _bannerSize.width;
            break;
        case OMBannerLayoutAttributeHorizontally:
            temp.origin.x = ([UIScreen mainScreen].bounds.size.width - _bannerSize.width)/2+constant;
            break;
        case OMBannerLayoutAttributeVertically:
            temp.origin.y = ([UIScreen mainScreen].bounds.size.height - _bannerSize.height)/2+constant;
            break;
    }
    
    self.frame = temp;
}

- (void)loadAndShow {
    [_bannerAd loadAd:OpenMediationAdFormatBanner actionType:OMLoadActionManualLoad];
    [self updateFreshTimer];
    [self addBannerEvent:CALLED_LOAD extraData:nil];
}

- (void)refresh {
    OMLogD(@"OMBanner refresh");
    [_bannerAd loadAd:OpenMediationAdFormatBanner actionType:OMLoadActionTimer];
}

- (void)updateFreshTimer {
    if (self.freshTimer) {
        [self.freshTimer invalidate];
        self.freshTimer = nil;
    }
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:_bannerAd.pid];
    if (unit.waterfallReloadTime >0 ) {
        self.freshTimer = [NSTimer scheduledTimerWithTimeInterval:unit.waterfallReloadTime target:[OMWeakObject proxyWithTarget:self] selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.freshTimer forMode:NSRunLoopCommonModes];
    }
}

- (NSString*)placementID {
    return _bannerAd.pid;
}

#pragma mark -- bannerDidLoad

- (void)bannerDidLoad:(NSString *)instanceID {
    [self updateFreshTimer];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIView *bannerView = [self.bannerAd.instanceAdapters objectForKey:instanceID];
    if (bannerView) {
        [self addSubview:bannerView];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(omBannerDidLoad:)]) {
        [self addBannerEvent:CALLBACK_LOAD_SUCCESS extraData:nil];
        [_delegate omBannerDidLoad:self];
    }

}

- (void)bannerDidFailToLoadWithError:(NSError *)error {
    [self updateFreshTimer];
    if (_delegate && [_delegate respondsToSelector:@selector(omBanner:didFailWithError:)]) {
        [self addBannerEvent:CALLBACK_LOAD_ERROR extraData:@{@"msg":OM_SAFE_STRING([error description])}];
        [_delegate omBanner:self didFailWithError:error];
    }

}

- (void)bannerWillExposure{
    if (self.delegate && [self.delegate respondsToSelector:@selector(omBannerWillExposure:)]) {
        [self.delegate omBannerWillExposure:self];
        [self addBannerEvent:CALLBACK_PRESENT_SCREEN extraData:nil];
    }

}

- (void)bannerDidClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(omBannerDidClick:)]) {
        [self addBannerEvent:CALLBACK_CLICK extraData:nil];
        [self.delegate omBannerDidClick:self];
    }
}

- (void)bannerWillPresentScreen {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(omBannerWillPresentScreen:)]) {
        [self.delegate omBannerWillPresentScreen:self];
    }
}

- (void)bannerDidDissmissScreen {
    if (self.delegate && [self.delegate respondsToSelector:@selector(omBannerDidDismissScreen:)]) {
        [self.delegate omBannerDidDismissScreen:self];
    }
}

- (void)bannerWillLeaveApplication {
    if (self.delegate && [self.delegate respondsToSelector:@selector(omBannerWillLeaveApplication:)]) {
        [self.delegate omBannerWillLeaveApplication:self];
    }
}

#pragma mark BannerMethod
- (BOOL)isPad {
    NSString *type = [UIDevice currentDevice].model;
    if([type isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

- (CGSize)getBannerSizeWithBannerType:(OMBannerType)type {
    switch (type) {
        case OMBannerTypeMediumRectangle:
            return CGSizeMake(300, 50);
        case OMBannerTypeLeaderboard:
            return CGSizeMake(728,90);
        case OMBannerTypeDefault:
            return CGSizeMake(320, 50);
        case OMBannerTypeSmart: {
            if ([self isPad]) {
                return CGSizeMake(728, 90);
            } else{
                return CGSizeMake(320, 50);
            }
        }
    }
}


    
- (void)addBannerEvent:(NSInteger)eventID extraData:data {
    NSMutableDictionary *wrapperData = [NSMutableDictionary dictionary];
    if (data) {
        [wrapperData addEntriesFromDictionary:data];
    }
    [wrapperData setObject:[NSNumber omStr2Number:[self placementID]] forKey:@"pid"];
     [[OMEventManager sharedInstance] addEvent:eventID extraData:wrapperData];
}

- (void)dealloc {
    [self.freshTimer invalidate];
    self.freshTimer = nil;
}
@end
