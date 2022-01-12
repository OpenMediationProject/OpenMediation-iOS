// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionCampaign.h"
#import "OMToolUmbrella.h"
#import "OMCrossPromotionCacheFile.h"
#import "OMCrossPromotionCampaignModel.h"
#import "OMCrossPromotionClickHandler.h"
#import "OMNetworkUmbrella.h"
#import "OMCrossPromotionDownloadManager.h"

@implementation OMCrossPromotionCampaign

- (instancetype)initWithCampaignData:(NSDictionary*)cData pid:(NSString*)pid {
    
    if (self = [super init]) {
        _model = [[OMCrossPromotionCampaignModel alloc]initWithCampaignData:cData];
        _expireTime = [[NSDate date]timeIntervalSince1970] + _model.expire;
        _pid = pid;
        _adFormat = _model.adFormat;
        _state = OMCrossPromotionCampaignStateDataReady;
    }
    return self;
}

- (BOOL)isExpire {
    return ([[NSDate date]timeIntervalSince1970] > _expireTime);
}

- (BOOL)isReady {
    return (_state == OMCrossPromotionCampaignStateDataReady && ![self isExpire] && [self iconReady] && [self mainImgReady] && [self videoReady] && [self resourceReady] && [self adMarkReady]);
}

- (BOOL)mainImgReady {
    BOOL imgReady = YES;
    for (NSString *img in _model.imgs) {
        if(![OMCrossPromotionCacheFile cacheFresh:img]) {
            imgReady = NO;
        }
    }
    return imgReady;
}

- (BOOL)videoReady {
    return [OMCrossPromotionCacheFile cacheFresh:OM_SAFE_STRING(_model.video[@"url"])];
}

- (BOOL)resourceReady {
    BOOL isReady = YES;
    for (NSString* resource in _model.resources) {
        if(!OM_STR_EMPTY(resource)) {
            if(![OMCrossPromotionCacheFile cacheFresh:resource]) {
                isReady = NO;
            }
        }
    }
    return  isReady;
}

- (BOOL)adMarkReady {
    BOOL isReady = YES;
    if(_model.adMark && _model.adMark[@"logo"]) {
        isReady = [OMCrossPromotionCacheFile cacheFresh:_model.adMark[@"logo"]];
    }
    return isReady;
}
- (NSString*)webHtmlStr {
    if([self resourceReady]) {
        return [OMCrossPromotionCacheFile localHtmlStr:[self webUrl]];
    }else{
        return @"";
    }
}

- (void)cacheMaterielCompletion:(cacheCompletionHandler)completionHandler {
    _cacheReadyCompletion = completionHandler;
    if(!self.clickHandler) {
        self.clickHandler = [[OMCrossPromotionClickHandler alloc]initWithAppID:_model.app[@"id"] ska:_model.ska adURL:_model.link];
        self.clickHandler.campainID = _model.cid;
        self.clickHandler.delegate = self;
    }
    if([self isReady]) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf && weakSelf.cacheReadyCompletion) {
                weakSelf.cacheReadyCompletion();
                weakSelf.cacheReadyCompletion = nil;
            }
        });
    }else{
        NSDictionary *downloadExtraValue = @{@"pid":self.pid,@"campaignId":self.model.cid,@"creativeId":self.model.crid};
        if(![self iconImgEmpty] && ![self iconReady]) {
            OMLogD(@"campaign download icon image");
            [[OMCrossPromotionDownloadManager sharedInstance]downloadUrl:_model.app[@"icon"] extra:downloadExtraValue completion:^(NSError *error) {
                if(!error) {
                    OMLogD(@"campaign download icon image success");
                    [self checkCacheReady];
                }
            }];
        }
        if(![self mainImgEmpty] && ![self mainImgReady]) {
            OMLogD(@"campaign download main image");
            
            for (NSString *img in _model.imgs) {
                [[OMCrossPromotionDownloadManager sharedInstance]downloadUrl:img extra:downloadExtraValue completion:^(NSError *error) {
                    if(!error) {
                        OMLogD(@"campaign download image %@",img);
                        [self checkCacheReady];
                    }
                }];
            }
        }
        if(![self videoEmpty] && ![self videoReady]) {
            OMLogD(@"campaign download video ");
            [[OMCrossPromotionDownloadManager sharedInstance]downloadUrl:_model.video[@"url"] extra:downloadExtraValue completion:^(NSError *error) {
                if(!error) {
                    OMLogD(@"campaign download video success");
                    [self checkCacheReady];
                }
            }];
        }
        if(![self adMarkReady]) {
            OMLogD(@"campaign download admark %@",_model.adMark[@"logo"]);
            [[OMCrossPromotionDownloadManager sharedInstance]downloadUrl:_model.adMark[@"logo"] extra:downloadExtraValue completion:^(NSError *error) {
                if(!error) {
                    OMLogD(@"campaign download admark success");
                    [self checkCacheReady];
                }
            }];
        }
        for (NSString* resource in _model.resources) {
            if(!OM_STR_EMPTY(resource)) {
                [[OMCrossPromotionDownloadManager sharedInstance]downloadUrl:resource extra:downloadExtraValue completion:^(NSError *error) {
                    if(!error) {
                        OMLogD(@"campaign download resource %@ success",resource);
                        [self checkCacheReady];
                    }
                }];
            }
        }
    }
    

}

- (void)checkCacheReady {
    if([self isReady]) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf.cacheReadyCompletion) {
                weakSelf.cacheReadyCompletion();
                weakSelf.cacheReadyCompletion = nil;
            }
        });
    }
}

- (BOOL)iconImgEmpty {
    return OM_STR_EMPTY(_model.app[@"icon"]);
}

- (BOOL)iconReady{
    return [OMCrossPromotionCacheFile cacheFresh: _model.app[@"icon"]];
}

- (NSString*)iconCachePath {
    return [NSString omUrlCachePath:_model.app[@"icon"]];
}

- (BOOL)mainImgEmpty {
    return (_model.imgs.count == 0);
}

- (NSString*)mainImgCachePath {
    NSString *mainImg = @"";
    if (_model.imgs.count >0) {
        mainImg = [NSString omUrlCachePath:_model.imgs[0]];
    }
    return mainImg;
}


- (BOOL)videoEmpty {
    return OM_STR_EMPTY(_model.video[@"url"]);
}


- (NSString*)videoCachePath {
    return [NSString omUrlCachePath:_model.video[@"url"]];
}


- (NSString*)webUrl {
    NSString *url = @"";
    if(_model.resources.count > 0) {
        url = [_model.resources firstObject];
    }
    return  url;
}

- (void)impression {
    [self impression:nil];
}

- (void)impression:(NSString*)sceneID {
    if(_state < OMCrossPromotionCampaignStateImpression) {
        _state = OMCrossPromotionCampaignStateImpression;
        [self imprTrack:sceneID];
    }
}


- (void)skStartImpression {
    if (@available(iOS 14.5, *)) {
        if(!_model.iswv && _model.app && _model.app[@"id"] && _model.ska && _model.skai) {
            self.skImpr = [[SKAdImpression alloc]init];
            self.skImpr.version = OM_SAFE_STRING([_model.ska objectForKey:@"adNetworkPayloadVersion"]);
            self.skImpr.adNetworkIdentifier = OM_SAFE_STRING([_model.ska objectForKey:@"adNetworkId"]);
            self.skImpr.adCampaignIdentifier = @([[_model.ska objectForKey:@"adNetworkCampaignId"] integerValue]);
            self.skImpr.advertisedAppStoreItemIdentifier = @([_model.app[@"id"] integerValue]);
            self.skImpr.adImpressionIdentifier = OM_SAFE_STRING([_model.skai objectForKey:@"nonce"]);
            self.skImpr.sourceAppStoreItemIdentifier = @([[_model.ska objectForKey:@"adNetworkSourceAppStoreIdentifier"] integerValue]);
            self.skImpr.timestamp = @([[_model.ska objectForKey:@"adNetworkImpressionTimestamp"] integerValue]);
            self.skImpr.signature = OM_SAFE_STRING([_model.skai objectForKey:@"sign"]);
            [SKAdNetwork startImpression:self.skImpr completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    OMLogD(@"SKAdNetwork start impression %@ error  %@",self.model.app[@"id"],error);
                } else {
                    OMLogD(@"SKAdNetwork start impression %@",self.model.app[@"id"]);
                }
            }];
        }
    }
}

- (void)skEndImpression {
    if (self.skImpr) {
        if (@available(iOS 14.5, *)) {
            [SKAdNetwork endImpression:self.skImpr completionHandler:^(NSError * _Nullable error) {
                self.skImpr = nil;
                if (error) {
                    OMLogD(@"SKAdNetwork end impression %@ error  %@",self.model.app[@"id"],error);
                } else {
                    OMLogD(@"SKAdNetwork end impression %@",self.model.app[@"id"]);
                }
            }];
        }
    }
}



- (void)imprTrack {
    [self imprTrack:nil];
}

- (void)imprTrack:(NSString*)sceneID {
    
    for (NSString* url in _model.imptks) {
        NSString *trackUrl = [NSString stringWithFormat:@"%@&con_type=%@",url,[[OMNetMonitor sharedInstance] getNetWorkType]];
        if([trackUrl containsString:@"{scene}"]) {
            trackUrl = [trackUrl stringByReplacingOccurrencesOfString:@"{scene}" withString:OM_SAFE_STRING(sceneID)];
        }
        [OMBaseRequest getWithUrl:trackUrl type:OMRequestTypeNormal body:[NSData data] completionHandler:^(NSObject * _Nullable object, NSError * _Nullable error) {
            if(!error) {
            }else{
                OMLogD(@"itrak fail");
            }
        }];
    }

}

- (void)clickAndShowAd:(UIViewController*)rootVC {
    [self clickAndShowAd:rootVC sceneID:nil];
}

- (void)clickAndShowAd:(UIViewController*)rootVC sceneID:(NSString*)sceneID {
    _state = OMCrossPromotionCampaignStateClick;
    if (_model.clktks.count>0) {
        OMLogD(@"clicks task -- %@",_model.clktks);
        [self requestClksWithScene:sceneID];
    }
    if(rootVC) {
        if(_model.iswv) {
            [_clickHandler clickWebAd:rootVC scene:sceneID];
        }else{
            [_clickHandler clickAppAd:rootVC scene:sceneID];
        }
    }
}


- (BOOL)expire {
    return ([[NSDate date]timeIntervalSince1970]>_expireTime);
}

- (NSDictionary*)originData {
    return _model.originData;
}

-(void)requestClksWithScene:(NSString*)sceneID {
    for (NSString *url in _model.clktks) {
        NSString *clickUrl = url;
        if([clickUrl containsString:@"{scene}"]) {
            clickUrl = [clickUrl stringByReplacingOccurrencesOfString:@"{scene}" withString:OM_SAFE_STRING(sceneID)];
        }
        [OMBaseRequest getWithUrl:clickUrl type:OMRequestTypeNormal body:[NSData data] completionHandler:^(NSObject * _Nullable object, NSError * _Nullable error) {
            if(!error) {
            }else{
                OMLogD(@"itrak fail");
            }
        }];
    }
}

- (UIImage*)logoImage {
    if ([_model.adMark isKindOfClass:[NSNull class]] || [_model.adMark isEqual:[NSNull null]]) {
        return nil;
    }
    if (!OM_STR_EMPTY(_model.adMark[@"logo"])) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.adMark[@"logo"]]]];
        return image;
    }else{
        UIImage *image = [UIImage new];
        return image;
    }
}

- (void)iconClick {
    if (_model.adMark && [_model.adMark isKindOfClass:[NSDictionary class]] && !OM_STR_EMPTY(_model.adMark[@"link"])) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.adMark[@"link"]]];
    }
}


#pragma mark -- AdTimingClickHandlerDelegate

- (void)clickHandlerWillPresentScreen {
    if(_clickHanlerDelegate && [_clickHanlerDelegate respondsToSelector:@selector(campaignClickHandlerWillPresentScreen)]) {
        [_clickHanlerDelegate campaignClickHandlerWillPresentScreen];
    }
}

- (void)clickHandlerDisDismissScrren {
    if(_clickHanlerDelegate && [_clickHanlerDelegate respondsToSelector:@selector(campaignClickHandlerDisDismissScrren)]) {
        [_clickHanlerDelegate campaignClickHandlerDisDismissScrren];
    }
}

- (void)clickHandlerLeaveApplication {
    if(_clickHanlerDelegate && [_clickHanlerDelegate respondsToSelector:@selector(campaignClickHandlerLeaveApplication)]) {
        [_clickHanlerDelegate campaignClickHandlerLeaveApplication];
    }
}

- (void)dealloc {
    [self skEndImpression];
}
@end
