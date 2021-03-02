// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionRewardedVideo.h"

@protocol PromotionEventDelegate <OMRewardedVideoCustomEvent>

@optional

- (void)customEventAddEvent:(NSObject*)adapter event:(NSDictionary*)eventBody;

@end

@implementation OMCrossPromotionRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
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
    [[OMCrossPromotionCampaignManager sharedInstance] loadAdWithPid:_pid size:[UIScreen mainScreen].bounds.size reqId:@"" action:4 payload:payload completionHandler:^(OMCrossPromotionCampaign *campaign, NSError *error) {
        if(weakSelf) {
            if (!error) {
                weakSelf.campaign = campaign;
                [campaign cacheMaterielCompletion:^{
                    if(weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                        [weakSelf.delegate customEvent:weakSelf didLoadAd:nil];
                    }
                }];
            }else{
                if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                    [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
                }
            }
        }
    }];
}

- (BOOL)isReady {
    if(self.campaign && [self.campaign isReady]) {
        return YES;
    }
    return NO;
}

- (void)show:(UIViewController*)vc {
    if (!vc) {
        return;
    }
    self.crossPromotionVideo = [[OMCrossPromotionVideoController alloc]initWithCampaign:_campaign scene:self.showSceneID];
    _crossPromotionVideo.delegate = self;
    
    [vc presentViewController:self.crossPromotionVideo animated:YES completion:^{
        
    }];
}

#pragma  mark -- adtimingVideoPlayDelegate

- (void)promotionVideoOpen {
    [_campaign impression:OM_SAFE_STRING(self.showSceneID)];
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
}

- (void)promotionVideoPlayStart {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)promotionVideoPlayEnd {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}



- (void)promotionVideoClick:(BOOL)trackClick {
    if(trackClick) {
        [_campaign clickAndShowAd:self.crossPromotionVideo sceneID:OM_SAFE_STRING(self.showSceneID)];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)promotionVideoClose {
    
    _crossPromotionVideo = nil;
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)promotionVideoReward {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)promotionVideoAddEvent:(NSString*)eventBody {
    if(!OM_STR_EMPTY(eventBody)) {
        NSData *data = [eventBody dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonErr = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
        if(!jsonErr) {
            id<PromotionEventDelegate> delegate = (id<PromotionEventDelegate>)_delegate;
            NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:dict];
            [body setObject:OM_SAFE_STRING(self.showSceneID) forKey:@"scene"];
            if(delegate && [delegate respondsToSelector:@selector(customEventAddEvent:event:)]) {
                [delegate customEventAddEvent:self event:body];
            }
        }
    }
}


@end
