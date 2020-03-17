// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OMBidResponse : NSObject

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSObject *payLoad;

@property (nonatomic,copy, nullable) void(^notifyWin)(void);
@property (nonatomic,copy, nullable) void(^notifyLoss)(void);

+ (OMBidResponse *)buildResponseWithError:(NSString *)errorMsg;

+ (OMBidResponse *)buildResponseWithPrice:(double)price
                                   currency:(NSString *)currency
                                    payLoad:(NSObject *)payLoad
                                notifyWin:(void (^)(void))win
                                     notifyLoss:(void (^)(void))loss;
- (void)loss;

- (void)win;

@end

NS_ASSUME_NONNULL_END
