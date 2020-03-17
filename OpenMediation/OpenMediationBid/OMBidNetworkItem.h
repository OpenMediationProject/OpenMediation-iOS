// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
