// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFyberBanner.h"

static const CGFloat kIADefaultIPhoneBannerWidth = 320;
static const CGFloat kIADefaultIPhoneBannerHeight = 50;
static const CGFloat kIADefaultIPadBannerWidth = 728;
static const CGFloat kIADefaultIPadBannerHeight = 90;

const NSTimeInterval BANNER_TIMEOUT_INTERVAL = 15.0;
extern NSString * const kIASDKOMAdapterErrorDomain;

@interface OMFyberBanner()

@property (nonatomic, strong) IAAdSpot *adSpot;
@property (nonatomic, strong) IAViewUnitController *bannerUnitController;
@property (nonatomic, strong) IAMRAIDContentController *MRAIDContentController;
@property (nonatomic, strong) IAVideoContentController *videoContentController;
@property (nonatomic, strong) NSDictionary *adParameter;

@property (nonatomic) BOOL isIABanner;
@property (atomic) BOOL clickTracked;

@property (nonatomic, weak) UIViewController *rootViewController;

@end

@implementation OMFyberBanner

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    _isIABanner =
    ((size.width == kIADefaultIPhoneBannerWidth) && (size.height == kIADefaultIPhoneBannerHeight)) ||
    ((size.width == kIADefaultIPadBannerWidth) && (size.height == kIADefaultIPadBannerHeight));
    NSString *spotID = @"";

    if (info && [info isKindOfClass:NSDictionary.class] && info.count) {
        NSString *receivedSpotID = info[@"pid"];
        if (receivedSpotID && [receivedSpotID isKindOfClass:NSString.class] && receivedSpotID.length) {
            spotID = receivedSpotID;
        }
    }

    Class IAUserClass = NSClassFromString(@"IAUserData");
    
    IAUserData *userData = [IAUserClass build:^(id<IAUserDataBuilder>  _Nonnull builder) {
        /*
         builder.age = 34;
         builder.gender = IAUserGenderTypeMale;
         builder.zipCode = @"90210";
         */
    }];
    
    Class requestClass = NSClassFromString(@"IAAdRequest");

    IAAdRequest *request = [requestClass build:^(id<IAAdRequestBuilder>  _Nonnull builder) {

        builder.useSecureConnections = NO;
        builder.spotID = spotID;
        builder.timeout = BANNER_TIMEOUT_INTERVAL - 1;
        builder.userData = userData;
        //            builder.keywords = mopubAdView.keywords;
        //            builder.location = self.delegate.location;
    }];
    Class videoControllerClass = NSClassFromString(@"IAVideoContentController");
    Class mraidControllerClass = NSClassFromString(@"IAMRAIDContentController");
    Class unitControllerClass = NSClassFromString(@"IAViewUnitController");
    
    self.videoContentController = [videoControllerClass build:^(id<IAVideoContentControllerBuilder>  _Nonnull builder) {
        builder.videoContentDelegate = (id<IAVideoContentDelegate>)self;
    }];

    self.MRAIDContentController = [mraidControllerClass build:^(id<IAMRAIDContentControllerBuilder>  _Nonnull builder) {
        builder.MRAIDContentDelegate =  (id<IAMRAIDContentDelegate>)self;;
        builder.contentAwareBackground = YES;
    }];

    self.bannerUnitController = [unitControllerClass build:^(id<IAViewUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate =  (id<IAUnitDelegate>)self;

        [builder addSupportedContentController:self.videoContentController];
        [builder addSupportedContentController:self.MRAIDContentController];
    }];

    Class adSpotrClass = NSClassFromString(@"IAAdSpot");
    
    self.adSpot = [adSpotrClass build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = request;
        [builder addSupportedUnitController:self.bannerUnitController];
    }];

    self.clickTracked = NO;

    __weak __typeof__(self) weakSelf = self; // a weak reference to 'self' should be used in the next block:

    [self.adSpot fetchAdWithCompletion:^(IAAdSpot * _Nullable adSpot, IAAdModel * _Nullable adModel, NSError * _Nullable error) {
        if (error) {
            [weakSelf treatError:error.localizedDescription];
        } else {
            if (adSpot.activeUnitController == weakSelf.bannerUnitController) {
                if (weakSelf.isIABanner && [adSpot.activeUnitController.activeContentController isKindOfClass:NSClassFromString(@"IAVideoContentController")]) {
                    [weakSelf treatError:@"incompatible banner content"];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.bannerUnitController.adView.superview) {
                            [weakSelf.bannerUnitController.adView removeFromSuperview];
                        }

                        weakSelf.bannerUnitController.adView.bounds = CGRectMake(0, 0, size.width, size.height);
                        [weakSelf addSubview:weakSelf.bannerUnitController.adView];
                    });
                    if ([weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                        [weakSelf.delegate customEvent:self didLoadAd:nil];
                    }
                }
            } else {
                [weakSelf treatError:@"mismatched ad object entities"];
            }
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        _rootViewController = rootViewController;
        _adParameter = adParameter;
    }

    return self;
}

- (void)treatError:(NSString * _Nullable)reason {
    if (!reason.length) {
        reason = @"internal error";
    }

    NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : reason};
    NSError *error = [NSError errorWithDomain:kIASDKOMAdapterErrorDomain code:500 userInfo:userInfo];
    if ([self.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [self.delegate customEvent:self didFailToLoadWithError:error];
    }
//    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

#pragma mark - IAViewUnitControllerDelegate

- (UIViewController * _Nonnull)IAParentViewControllerForUnitController:(IAUnitController * _Nullable)unitController {
    return _rootViewController;
}

- (void)IAAdDidReceiveClick:(IAUnitController * _Nullable)unitController {
    if (!self.clickTracked) {
        self.clickTracked = YES;
        [self.delegate bannerCustomEventDidClick:self]; // manual track;
    }
}

- (void)IAAdWillLogImpression:(IAUnitController * _Nullable)unitController {

}

- (void)IAUnitControllerWillPresentFullscreen:(IAUnitController * _Nullable)unitController {
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]) {
        [self.delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)IAUnitControllerDidPresentFullscreen:(IAUnitController * _Nullable)unitController {

}

- (void)IAUnitControllerWillDismissFullscreen:(IAUnitController * _Nullable)unitController {
}

- (void)IAUnitControllerDidDismissFullscreen:(IAUnitController * _Nullable)unitController {
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]) {
        [self.delegate bannerCustomEventDismissScreen:self];
    }
}

- (void)IAUnitControllerWillOpenExternalApp:(IAUnitController * _Nullable)unitController {
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [self.delegate bannerCustomEventWillLeaveApplication:self];
    }
}

#pragma mark - IAMRAIDContentDelegate
- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController MRAIDAdWillResizeToFrame:(CGRect)frame {
}

- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController MRAIDAdDidResizeToFrame:(CGRect)frame {
}

- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController MRAIDAdWillExpandToFrame:(CGRect)frame {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventWillExpandAd:)]) {
        [self.delegate performSelector:@selector(bannerCustomEventWillExpandAd:) withObject:self];
    }
#pragma clang diagnostic pop
}

- (void)IAMRAIDContentController:(IAMRAIDContentController * _Nullable)contentController MRAIDAdDidExpandToFrame:(CGRect)frame {
}

- (void)IAMRAIDContentControllerMRAIDAdWillCollapse:(IAMRAIDContentController * _Nullable)contentController {
}

- (void)IAMRAIDContentControllerMRAIDAdDidCollapse:(IAMRAIDContentController * _Nullable)contentController {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventDidCollapseAd:)]) {
        [self.delegate performSelector:@selector(bannerCustomEventDidCollapseAd:) withObject:self];
    }
#pragma clang diagnostic pop
}

#pragma mark - IAVideoContentDelegate
- (void)IAVideoCompleted:(IAVideoContentController * _Nullable)contentController {

}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoInterruptedWithError:(NSError *)error {
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoDurationUpdated:(NSTimeInterval)videoDuration {
}

- (void)loadAd {
    [self requestAdWithSize:self.bounds.size customEventInfo:self.adParameter adMarkup:nil];
}

@end
