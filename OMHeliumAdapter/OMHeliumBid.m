// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHeliumBid.h"
#import "OMHeliumClass.h"
#import "OMInterstitialCustomEvent.h"
#import "OMRewardedVideoCustomEvent.h"

@interface OMBidNetworkItem : NSObject

@property (nonatomic, strong) NSString *adnName;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *placementID;
@property (nonatomic, assign) NSInteger maxTimeOutMS;
@property (nonatomic, assign) BOOL testMode;
@property (nonatomic, strong) NSDictionary *extraData;

+ (OMBidNetworkItem *)networkItemWithName:(NSString*)adnName
                                   appKey:(NSString*)key
                              placementID:(NSString*)placementID
                                  timeOut:(NSInteger)maxTimeoutMS
                                     test:(BOOL)testMode
                                    extra:(NSDictionary*)extraData;

@end

typedef id _Nullable (^mInstanceInitBlock)(void);

@interface OMInstanceContainer : NSObject

+ (instancetype)sharedInstance;
- (id)getInstance:(NSString*)instanceID block:(mInstanceInitBlock)mInstanceInitBlock;

@end

typedef void (^bidCompletionHandler)(NSDictionary *bidResponse);

static NSMutableDictionary *bidBlockMap = nil;

@protocol OMHeliumAd<OMInterstitialCustomEvent>

@property(nonatomic, weak, nullable) id<HeliumDelegate> bidDelegate;

@end

@implementation OMHeliumBid


+ (void)bidWithNetworkItem:(OMBidNetworkItem*)networkItem adFormat:(NSString*)format adSize:(CGSize)size responseCallback:(void(^)(NSDictionary *bidResponseData))callback {
     NSString *appKey = networkItem.appKey;
     NSString *placementID = networkItem.placementID;
    
    if (![appKey length] || ![placementID length]) {
        callback(@{@"error":@"Required input params(appKey,placementID) for Helium is invalid"});
        return;
    }
    
    if (![format isEqualToString:@"Interstitial"]  && ![format isEqualToString:@"RewardedVideo"]) {
        callback(@{@"error":@"Helium still not support this adType"});
        return;
    }

    Class adapterClass = NSClassFromString([NSString stringWithFormat:@"OM%@%@",networkItem.adnName,format]);
    
    
    NSString *instanceID = networkItem.extraData[@"instanceID"];
    
    if(adapterClass && [adapterClass instancesRespondToSelector:@selector(initWithParameter:)]) {
        
        Class instanceContainerCls = NSClassFromString([NSString stringWithFormat:@"%@InstanceContainer",networkItem.extraData[@"prefix"]]);
        
        id <OMHeliumAd> interstitialAdapter = [[instanceContainerCls sharedInstance]getInstance:instanceID block:^id{
            id adapter = [[adapterClass alloc] initWithParameter:@{@"pid":placementID,@"appKey":appKey}];
            return adapter;
        }];
        
        if (!bidBlockMap) {
            bidBlockMap = [NSMutableDictionary dictionary];
        }
        
        [bidBlockMap setObject:callback forKey:[NSNumber numberWithUnsignedInteger:[interstitialAdapter hash]]];
        
        interstitialAdapter.bidDelegate = (id<HeliumDelegate>)self;
        [interstitialAdapter loadAd];
        
    } else {
        callback(@{@"error":@"Helium Adapter class not found"});
    }

    
    
}

+ (void)bidReseponse:(NSObject*)bidAdapter bid:(NSDictionary*)bidInfo error:(NSError*)error {
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:[bidAdapter hash]];
    
    bidCompletionHandler callback = [bidBlockMap objectForKey:key];
    
    if (callback) {
        
        if (error) {
            callback(@{@"error":(error.description?error.description:@"")});
        } else {
            NSMutableDictionary *bidResponseData = [NSMutableDictionary dictionaryWithDictionary:bidInfo];
            
            [bidResponseData setObject:^{
                NSLog(@"Helium win");
            } forKey:@"winBlock"];

            [bidResponseData setObject:^{
                NSLog(@"Helium loss");
            } forKey:@"lossBlock"];
            
            callback(bidResponseData);
        }
        
    }
    [bidBlockMap removeObjectForKey:key];
}


@end
