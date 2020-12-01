// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionNative.h"
#import "OpenMediationConstant.h"
#import "OMCrossPromotionCampaignManager.h"

@interface OMNativeAd : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *callToAction;
@property (nonatomic, assign) double rating;
- (instancetype)initWithPlatform:(OMAdNetwork)adnID didLoadAd:(id)ad;
@end

@implementation OMCrossPromotionNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
        _rootVC = rootViewController;
    }
    return self;
}

- (void)loadAdWithBidPayload:(NSString*)bidPayload {
    NSString *payload = @"";
    if ([bidPayload length]>0) {
        NSData *data = [bidPayload dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonErr = nil;
        NSDictionary *admBody = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
        if([admBody isKindOfClass:[NSDictionary class]]) {
            payload = admBody[@"payload"];
        }
    }
    if (![payload length]) {
        if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            NSError *error = [[NSError alloc]initWithDomain:@"com.crosspromotion.ads" code:501 userInfo: @{NSLocalizedDescriptionKey:@"Invalid bid payload"}];
            [_delegate customEvent:self didFailToLoadWithError:error];
        }
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [[OMCrossPromotionCampaignManager sharedInstance] loadAdWithPid:_pid size:CGSizeMake(1200, 627) action:4 payload:payload completionHandler:^(OMCrossPromotionCampaign *campaign, NSError *error) {
        if(!error) {
            [campaign cacheMaterielCompletion:^{
                if(weakSelf) {
                    OMCrossPromotionNativeAd* nativeAd = [[OMCrossPromotionNativeAd alloc]initWithCampaign:campaign];
                    nativeAd.adDelegate = weakSelf;
                    if(weakSelf.delegate  && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                        [weakSelf.delegate customEvent:weakSelf didLoadAd:nativeAd];
                    }
                }
            }];
            
        }else{
            if(weakSelf.delegate  && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                [weakSelf.delegate customEvent:self didFailToLoadWithError:error];
            }
        }
    }];
}


#pragma mark -- OMCrossPromotionNativeAdDelegate
- (void)OMCrossPromotionNativeAdWillShow:(OMCrossPromotionNativeAd*)natvieAd {
    [natvieAd.campaign impression:@""];
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:self];
    }
}

- (void)OMCrossPromotionNativeAdDidClick:(OMCrossPromotionNativeAd*)natvieAd{
    [natvieAd showAd:_rootVC];
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
    }
}



@end
