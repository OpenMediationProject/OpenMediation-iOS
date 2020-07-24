// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostBidBidding.h"
#import "OMChartboostBidClass.h"
#import "OMConfig.h"
#import "OMMediations.h"
#import "OMInterstitialCustomEvent.h"
#import "OMRewardedVideoCustomEvent.h"
#import "OMInstanceContainer.h"


typedef void (^bidCompletionHandler)(OMBiddingResponse *bidResponse);

static NSMutableDictionary *bidBlockMap = nil;


@protocol ChartboostBidDelegate <NSObject>

- (void)bidReseponse:(NSObject*)bidAdapter bid:(nullable NSDictionary*)bidInfo error:(nullable NSError*)error;

@end


@protocol OMChartboostBidAd<OMInterstitialCustomEvent>

@property(nonatomic, weak, nullable) id<ChartboostBidDelegate> bidDelegate;

@end

@implementation OMChartboostBidBidding


+ (void)bidWithNetworkItem:(OMBiddingNetworkItem*)networkItem adFormat:(OpenMediationAdFormat)format responseCallback:(void(^)(OMBiddingResponse *bidResponse))callback {
     NSString *appKey = networkItem.appKey;
     NSString *placementID = networkItem.placementID;
    
    if (![appKey length] || ![placementID length]) {
        OMBiddingResponse *bidResponse = [OMBiddingResponse buildResponseWithError:@"Required input params(appID placementID) for Facebook bidding is invalid"];
        callback(bidResponse);
        return;
    }
    
    if (format != OpenMediationAdFormatInterstitial  && format != OpenMediationAdFormatRewardedVideo) {
        OMBiddingResponse *bidResponse = [OMBiddingResponse buildResponseWithError:@"current network still not support this adType"];
        callback(bidResponse);
        return;
    }
        
    if(![[OMMediations sharedInstance]adnSDKInitialized:OMAdNetworkChartboostBid]){
        [[OMMediations sharedInstance]initAdNetworkSDKWithId:OMAdNetworkChartboostBid
                                               completionHandler:^(NSError * _Nullable error) {
        }];
    }
    
    
    NSString *adFormatString = (format == OpenMediationAdFormatInterstitial)?@"Interstitial":@"RewardedVideo";
    
    NSString *interstitialClassName = [NSString stringWithFormat:@"OM%@%@",@"ChartboostBid",adFormatString];
    Class adapterClass = NSClassFromString(interstitialClassName);
    
    
    
    NSString *instanceID = [[OMConfig sharedInstance] checkinstanceIDWithAdNetwork:OMAdNetworkChartboostBid adnPlacementID:placementID];
    
    if(adapterClass && [adapterClass instancesRespondToSelector:@selector(initWithParameter:)]) {
        id <OMChartboostBidAd> interstitialAdapter = [[OMInstanceContainer sharedInstance]getInstance:instanceID block:^id{
            id adapter = [[adapterClass alloc] initWithParameter:@{@"pid":placementID,@"appKey":appKey}];
            return adapter;
        }];
        
        if (!bidBlockMap) {
            bidBlockMap = [NSMutableDictionary dictionary];
        }
        
        [bidBlockMap setObject:callback forKey:[NSNumber numberWithUnsignedInteger:[interstitialAdapter hash]]];
        
        interstitialAdapter.bidDelegate = (id<ChartboostBidDelegate>)self;
        [interstitialAdapter loadAd];
        
    } else {
        OMBiddingResponse *bidResponse = [OMBiddingResponse buildResponseWithError:@"Chartboost Bid Adapter class not found"];
         callback(bidResponse);
    }

    
    
}

+ (void)bidReseponse:(NSObject*)bidAdapter bid:(NSDictionary*)bidInfo error:(NSError*)error {
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:[bidAdapter hash]];
    
    bidCompletionHandler callback = [bidBlockMap objectForKey:key];
    
    if (callback) {
        
        if (error) {
            OMBiddingResponse *bidResponse = [OMBiddingResponse buildResponseWithError:error.description];
            callback(bidResponse);
        } else {
            OMBiddingResponse *bidResponse = [OMBiddingResponse buildResponseWithPrice:[[bidInfo objectForKey:@"price"]doubleValue] currency:[bidInfo objectForKey:@"currency"] payLoad:@"" notifyWin:^{
                NSLog(@"ChartboostBid win");
            } notifyLoss:^{
                NSLog(@"ChartboostBid loss");
            }];
            callback(bidResponse);
        }
        
    }
    [bidBlockMap removeObjectForKey:key];
}


@end
