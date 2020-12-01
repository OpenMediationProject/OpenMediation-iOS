// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionCampaignManager.h"
#import "OMCrossPromotionClRequest.h"
#import "OMConfig.h"


static OMCrossPromotionCampaignManager * _instance = nil;

@implementation OMCrossPromotionCampaignManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _placmentAdsMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadPid:(NSString*)pid
             size:(CGSize)size
           action:(NSInteger)action
completionHandler:(loadCompletionHandler)completionHandler {
    [self loadAdWithPid:pid size:size action:action payload:nil completionHandler:completionHandler];
}

- (void)loadAdWithPid:(NSString*)pid
             size:(CGSize)size
           action:(NSInteger)action
            payload:(NSString*)payload
completionHandler:(loadCompletionHandler)completionHandler {
    
    if ([payload length] > 0) {
        [self cleanAds:pid];
    }
    
    NSMutableArray *ads = [NSMutableArray array];
    if ([_placmentAdsMap objectForKey:pid]) {
        ads = [NSMutableArray arrayWithArray:[_placmentAdsMap objectForKey:pid]];
    }
    [self passExpireAds:ads];
    
    NSInteger cacheCount = 1;
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:pid];
    if (unit && unit.adFormat == OpenMediationAdFormatCrossPromotion) {
        cacheCount = unit.cacheCount;
    }
    if (ads.count > 0) {
        completionHandler(ads[0],nil);
        if (ads.count < cacheCount) {
            [OMCrossPromotionClRequest requestCampaignWithPid:pid size:size actionType:action payload:payload completionHandler:^(NSDictionary * _Nullable campaignsData, NSError * _Nullable error) {
                if (!error) {
                    NSArray *campaigns = [campaignsData objectForKey:@"campaigns"];
                    if (campaigns && [campaigns isKindOfClass:[NSArray class]]) {
                        [self addCampaignsWithData:campaigns pid:pid];
                    }
                }
                [self cacheCampaignMateriel:pid count:cacheCount];
            }];
        } else {
                [self cacheCampaignMateriel:pid count:cacheCount];
        }
    } else {
        [OMCrossPromotionClRequest requestCampaignWithPid:pid size:size actionType:action payload:payload  completionHandler:^(NSDictionary * _Nullable campaignsData, NSError * _Nullable error) {
            if (!error) {
                NSArray *campaigns = [campaignsData objectForKey:@"campaigns"];
                if (campaigns && [campaigns isKindOfClass:[NSArray class]]) {
                    [self addCampaignsWithData:campaigns pid:pid];
                }
                OMCrossPromotionCampaign *ad = [self getCampaignWithPid:pid];
                if (ad) {
                    completionHandler(ad,nil);
                    [self cacheCampaignMateriel:pid count:cacheCount];
                } else {
                    completionHandler(nil,[[NSError alloc]initWithDomain:@"com.om.promotion" code:1001 userInfo: @{NSLocalizedDescriptionKey:@"no fill"}]);
                }
            } else {
                completionHandler(nil,[[NSError alloc]initWithDomain:@"com.om.promotion" code:1000 userInfo: @{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"request error:%@",OM_SAFE_STRING([error description])]}]);
            }
            
        }];
    }
}

- (void)addCampaignsWithData:(NSArray*)campaignsData pid:(NSString*)pid {
    if([campaignsData isKindOfClass:[NSArray class]] && [campaignsData count] > 0) {
        NSMutableArray *loadAds = [NSMutableArray arrayWithArray:[_placmentAdsMap objectForKey:pid]];
        if(!loadAds) {
            loadAds = [NSMutableArray array];
        }
        for (NSDictionary *cData in campaignsData) {
            OMCrossPromotionCampaign *c = [[OMCrossPromotionCampaign alloc]initWithCampaignData:cData pid:pid];
            [loadAds addObject:c];
        }
        [_placmentAdsMap setObject:loadAds forKey:pid];
    }
}

- (void)cacheCampaignMateriel:(NSString*)pid count:(NSInteger)count {
   NSMutableArray *ads = [NSMutableArray array];
   if ([_placmentAdsMap objectForKey:pid]) {
       ads = [NSMutableArray arrayWithArray:[_placmentAdsMap objectForKey:pid]];
   }

    if (count >1) {
        for (int i=1; (i<ads.count && i<count); i++) {
            OMCrossPromotionCampaign *campaign = ads[i];
            if (!campaign.isReady) {
                [campaign cacheMaterielCompletion:^{
                    
                }];
            }
        }
    }
}

- (OMCrossPromotionCampaign*)getCampaignWithPid:(NSString*)pid {
    OMCrossPromotionCampaign *c = nil;
    NSMutableArray *ads = [NSMutableArray array];
    if([_placmentAdsMap objectForKey:pid]) {
        ads = [NSMutableArray arrayWithArray:[_placmentAdsMap objectForKey:pid]];
    }
    [self passExpireAds:ads];
    if(ads.count > 0) {
        c = ads[0];
    }
    return c;
}

- (void)passExpireAds:(NSMutableArray*)ads {

    NSMutableArray *expiredAds = [NSMutableArray array];
    for (int i=0; i< [ads count]; i++) {
        OMCrossPromotionCampaign *c = ads[i];
        if(c.state >=  OMCrossPromotionCampaignStateImpression || [c expire]) {
            [expiredAds addObject:c];
        }else{
            break;
        }
    }
    [ads removeObjectsInArray:expiredAds];
}

- (void)cleanAds:(NSString*)pid {
    [_placmentAdsMap setObject:[NSArray array] forKey:pid];
}


@end
