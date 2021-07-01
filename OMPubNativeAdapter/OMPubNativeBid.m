// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPubNativeBid.h"
#import "OMPubNativeClass.h"
#import "OMInterstitialCustomEvent.h"
#import "OMRewardedVideoCustomEvent.h"
#import "OMBannerCustomEvent.h"
#import "OMNativeCustomEvent.h"

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

static NSMutableDictionary *bidBlockMapNew = nil;

@protocol OMPubNativeAd<OMInterstitialCustomEvent,OMCustomEventDelegate,OMRewardedVideoCustomEvent,OMBannerCustomEvent,OMNativeCustomEvent>

@property(nonatomic, weak, nullable) id<HyBidDelegate> bidDelegate;

@end

@implementation OMPubNativeBid

+ (void)bidWithNetworkItem:(OMBidNetworkItem*)networkItem adFormat:(NSString*)format adSize:(CGSize)size responseCallback:(void(^)(NSDictionary *bidResponseData))callback {
     NSString *appKey = networkItem.appKey;
     NSString *placementID = networkItem.placementID;
    
    if (![appKey length] || ![placementID length]) {
        callback(@{@"error":@"Required input params(appID placementID) for PubNative bid is invalid"});
        return;
    }
    
    if (![format isEqualToString:@"Interstitial"] && ![format isEqualToString:@"RewardedVideo"] && ![format isEqualToString:@"Banner"] && ![format isEqualToString:@"Native"]) {
        callback(@{@"error":@"current network still not support this adType"});
        return;
    }

    Class adapterClass = NSClassFromString([NSString stringWithFormat:@"OM%@%@",networkItem.adnName,format]);
    
    NSString *instanceID = networkItem.extraData[@"instanceID"];
    
    Class instanceContainerCls = NSClassFromString([NSString stringWithFormat:@"%@InstanceContainer",networkItem.extraData[@"prefix"]]);
    

    
    if (adapterClass && ([adapterClass instancesRespondToSelector:@selector(initWithParameter:)] || [adapterClass instancesRespondToSelector:@selector(initWithFrame:adParameter:rootViewController:)]||[adapterClass instancesRespondToSelector:@selector(initWithParameter:rootVC:)]) ) {
        
        id <OMPubNativeAd> adapter = nil;
        
        if ([adapterClass instancesRespondToSelector:@selector(initWithParameter:)]) { //IV RV
            adapter = [[instanceContainerCls sharedInstance]getInstance:instanceID block:^id{
                id adapter = [[adapterClass alloc] initWithParameter:@{@"pid":placementID,@"appKey":appKey}];
                return adapter;
            }];
        } else if([adapterClass instancesRespondToSelector:@selector(initWithFrame:adParameter:rootViewController:)]) { //Banner
            adapter = [[instanceContainerCls sharedInstance]getInstance:instanceID block:^id{
                id adapter = [[adapterClass alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) adParameter:@{@"pid":placementID,@"appKey":appKey} rootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
                return adapter;
            }];
        } else if([adapterClass instancesRespondToSelector:@selector(initWithParameter:rootVC:)]) { //Native
            adapter = [[instanceContainerCls sharedInstance]getInstance:instanceID block:^id{
                id adapter = [[adapterClass alloc] initWithParameter:@{@"pid":placementID,@"appKey":appKey} rootVC:[UIApplication sharedApplication].keyWindow.rootViewController];
                return adapter;
            }];
        }
        if (!bidBlockMapNew) {
            bidBlockMapNew = [NSMutableDictionary dictionary];
        }
        [bidBlockMapNew setObject:callback forKey:[NSNumber numberWithUnsignedInteger:[adapter hash]]];
        adapter.bidDelegate = (id<HyBidDelegate>)self;
        [adapter loadAd];
    } else {
        callback(@{@"error":@"PubNative Bid Adapter class not found"});
    }
}

+ (void)bidReseponse:(NSObject*)bidAdapter bid:(NSDictionary*)bidInfo error:(NSError*)error {
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:[bidAdapter hash]];
    
    bidCompletionHandler callback = [bidBlockMapNew objectForKey:key];
    
    if (callback) {
        
        if (error) {
            callback(@{@"error":(error.description?error.description:@"")});
        } else {
            NSMutableDictionary *bidResponseData = [NSMutableDictionary dictionaryWithDictionary:bidInfo];
            
            [bidResponseData setObject:^{
                NSLog(@"HyBid win");
            } forKey:@"winBlock"];

            [bidResponseData setObject:^{
                NSLog(@"HyBid loss");
            } forKey:@"lossBlock"];
            
            callback(bidResponseData);
        }
        
    }
    [bidBlockMapNew removeObjectForKey:key];
}


@end
