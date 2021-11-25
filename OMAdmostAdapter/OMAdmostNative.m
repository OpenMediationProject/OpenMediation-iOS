// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdmostNative.h"
#import "OMAdMostNativeAdView.h"
#import <objc/runtime.h>

static char const *const kOMAdapterNativeAdViewKey= "OMAdapterNativeAdView";


@implementation AMRBanner(OMAdMostAdapter)

- (void)setOmNativeAdView:(OMAdMostNativeAdView*)nativeAdView {
    objc_setAssociatedObject(self, &kOMAdapterNativeAdViewKey, nativeAdView, OBJC_ASSOCIATION_ASSIGN);
}

- (OMAdMostNativeAdView*)omNativeAdView {
    OMAdMostNativeAdView *admostNativeAdView = objc_getAssociatedObject(self, &kOMAdapterNativeAdViewKey);
    return admostNativeAdView;
}

@end

@implementation OMAdmostNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _uid = [adParameter objectForKey:@"uid"];
            _pid = [adParameter objectForKey:@"pid"];
        }
        _native.delegate = self;
    }
    return self;
}

- (void)loadAd {
    Class bannerClass = NSClassFromString(@"AMRBanner");
    if (bannerClass && [bannerClass respondsToSelector:@selector(bannerForZoneId:)]) {;
        _native = [bannerClass bannerForZoneId:_pid];
        NSString *xibFile = [NSString stringWithFormat:@"AdmostCustomNative%@",_uid];
        Class baseView = NSClassFromString(@"AMRNativeAdBaseView");
        if (baseView && [[NSFileManager defaultManager]fileExistsAtPath:[[NSBundle mainBundle] pathForResource:xibFile ofType:@"nib"] ]) {
            self.baseView = [[baseView alloc]initWithFrame:CGRectZero];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:xibFile owner:self.baseView options:nil];
            if (nib.count>0) {
                UIView *xibView = [nib firstObject];
                CGFloat width = xibView.frame.size.width;
                if (!width) {
                    width = [UIScreen mainScreen].bounds.size.width;
                }
                _native.customNativeSize = CGSizeMake(width, xibView.frame.size.height);
            }
        }
        _native.customeNativeXibName = xibFile;
        _native.delegate = self;
    }
    if (_native && [_native respondsToSelector:@selector(loadBanner)]) {
        [_native loadBanner];
    }
}

#pragma mark - AMRBannerDelegate

- (void)didReceiveBanner:(AMRBanner *)banner {
    OMAdMostNativeAdView *nativeAdView = [[OMAdMostNativeAdView alloc]initWithAdmostNativeAd:_native];
    [banner setOmNativeAdView:nativeAdView];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":[NSNumber numberWithDouble:([banner.ecpm doubleValue]/100.0)],@"adObject":nativeAdView} error:nil];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nativeAdView];
    }
    self.native = nil;
}

- (void)didFailToReceiveBanner:(AMRBanner *)banner error:(AMRError *)error {
    NSError *loadError = [[NSError alloc] initWithDomain:@"com.openmediation.admostadapter" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:loadError];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:loadError];
    }
    self.native = nil;
}

- (void)didShowBanner:(AMRBanner*)banner {
    if(_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:[banner omNativeAdView]];
    }
}

- (void)didClickBanner:(AMRBanner *)banner {
    if(_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:[banner omNativeAdView]];
    }
}

@end
