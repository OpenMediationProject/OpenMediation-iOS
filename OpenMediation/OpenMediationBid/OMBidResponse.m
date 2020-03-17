// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMBidResponse.h"
#import "OMToolUmbrella.h"

@implementation OMBidResponse
+ (OMBidResponse *)buildResponseWithError:(NSString *)errorMsg {

    OMBidResponse *response = [[OMBidResponse alloc] init];
    response.isSuccess = NO;
    response.errorMsg = OM_SAFE_STRING(errorMsg);
    return response;
}


+ (OMBidResponse *)buildResponseWithPrice:(double)price
                                   currency:(NSString *)currency
                                    payLoad:(NSObject *)payLoad
                                notifyWin:(void (^)(void))win
                               notifyLoss:(void (^)(void))loss {
    OMBidResponse *response = [[OMBidResponse alloc] init];
    response.isSuccess = YES;
    response.payLoad = OM_SAFE_STRING(payLoad);
    response.price = price;
    response.currency = (currency?currency:@"USD");
    response.notifyWin = win;
    response.notifyLoss = loss;
    return response;
}


- (void)loss {
    if (self.notifyLoss) {
        self.notifyLoss();
        self.notifyLoss = nil;
        self.notifyWin = nil;
    }
}

- (void)win {
    if (self.notifyWin) {
        self.notifyWin();
        self.notifyLoss = nil;
        self.notifyWin = nil;
    }
}

@end
