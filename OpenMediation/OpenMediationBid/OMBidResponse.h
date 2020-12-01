// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM (NSInteger, OMBidLossedReasonCode) {
    
    OMBidLossedReasonCodeInternalError    = 1,
    OMBidLossedReasonCodeTimeOut          = 2,
    OMBidLossedReasonCodeInvalidBid       = 3,
    OMBidLossedReasonCodeNotHiggestBidder = 102,
    OMBidLossedReasonCodeNotShow          = 4902,
};


@interface OMBidResponse : NSObject

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSObject *payLoad;
@property (nonatomic, assign) NSInteger expire;

@property (nonatomic,copy, nullable) void(^notifyWin)(void);
@property (nonatomic,copy, nullable) void(^notifyLoss)(void);

+ (OMBidResponse *)buildResponseWithError:(NSString *)errorMsg;

+ (OMBidResponse *)buildResponseWithPrice:(double)price
                                   currency:(NSString *)currency
                                    payLoad:(NSObject *)payLoad
                                  notifyWin:(void (^)(void))win
                                 notifyLoss:(void (^)(void))loss;

+ (OMBidResponse *)buildResponseWithData:(NSDictionary*)responseData;


- (void)win;

- (void)notifyLossWithReasonCode:(OMBidLossedReasonCode)lossReasonCode;

@end

NS_ASSUME_NONNULL_END
