// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMBidNetworkItem.h"

@implementation OMBidNetworkItem
+ (OMBidNetworkItem *)networkItemWithName:(NSString*)adnName
     appKey:(NSString*)key
placementID:(NSString*)placementID
    timeOut:(NSInteger)maxTimeoutMS
       test:(BOOL)testMode
      extra:(NSDictionary*)extraData {
    
    OMBidNetworkItem *item = [[OMBidNetworkItem alloc]init];
    item.adnName = adnName;
    item.appKey = key;
    item.placementID = placementID;
    item.maxTimeOutMS = maxTimeoutMS;
    item.testMode = testMode;
    item.extraData = extraData;
    return item;

}
@end
