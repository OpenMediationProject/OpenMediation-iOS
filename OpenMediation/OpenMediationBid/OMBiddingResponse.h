// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM (NSInteger, OMBiddingLossedReasonCode) {
    
    OMBiddingLossedReasonCodeInternalError    = 1,
    OMBiddingLossedReasonCodeTimeOut          = 2,
    OMBiddingLossedReasonCodeInvalidBid       = 3,
    OMBiddingLossedReasonCodeNotHiggestBidder = 102,
    OMBiddingLossedReasonCodeNotShow          = 4902,
};


@interface OMBiddingResponse : NSObject

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSObject *payLoad;

@property (nonatomic,copy, nullable) void(^notifyWin)(void);
@property (nonatomic,copy, nullable) void(^notifyLoss)(void);

+ (OMBiddingResponse *)buildResponseWithError:(NSString *)errorMsg;

+ (OMBiddingResponse *)buildResponseWithPrice:(double)price
                                   currency:(NSString *)currency
                                    payLoad:(NSObject *)payLoad
                                  notifyWin:(void (^)(void))win
                                 notifyLoss:(void (^)(void))loss;

+ (OMBiddingResponse *)buildResponseWithData:(NSDictionary*)responseData;


- (void)win;

- (void)notifyLossWithReasonCode:(OMBiddingLossedReasonCode)lossReasonCode;

@end

NS_ASSUME_NONNULL_END
