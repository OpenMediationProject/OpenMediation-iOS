// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMBiddingResponse.h"
#import "OMToolUmbrella.h"

@interface OMBiddingResponse()

@property (nonatomic, copy) NSString* nurl;
@property (nonatomic, copy) NSString* lurl;
@property (nonatomic, assign) BOOL bidNotification;
@end

@implementation OMBiddingResponse
+ (OMBiddingResponse *)buildResponseWithError:(NSString *)errorMsg {

    OMBiddingResponse *response = [[OMBiddingResponse alloc] init];
    response.isSuccess = NO;
    response.errorMsg = OM_SAFE_STRING(errorMsg);
    return response;
}


+ (OMBiddingResponse *)buildResponseWithPrice:(double)price
                                   currency:(NSString *)currency
                                    payLoad:(NSObject *)payLoad
                                  notifyWin:(void (^)(void))win
                                 notifyLoss:(void (^)(void))loss {
    OMBiddingResponse *response = [[OMBiddingResponse alloc] init];
    response.isSuccess = YES;
    response.payLoad = OM_SAFE_STRING(payLoad);
    response.price = price;
    response.currency = (currency?currency:@"USD");
    response.notifyWin = win;
    response.notifyLoss = loss;
    return response;
}

+ (OMBiddingResponse *)buildResponseWithData:(NSDictionary*)responseData {
    OMBiddingResponse *response = [[OMBiddingResponse alloc] init];
    response.isSuccess = YES;
    response.payLoad = OM_SAFE_STRING([responseData objectForKey:@"adm"]);
    response.price = [[responseData objectForKey:@"price"]floatValue];
    response.currency = ([responseData objectForKey:@"currency"]?[responseData objectForKey:@"currency"]:@"USD");
    response.nurl = [responseData objectForKey:@"nurl"];
    response.lurl = [responseData objectForKey:@"lurl"];
    return response;
}

- (void)win {
    if (!self.bidNotification) {
        self.bidNotification = YES;
        if (self.notifyWin) {
            self.notifyWin();
        } else if ([self.nurl length]>0) {
            NSString *winUrl = [self.nurl stringByReplacingOccurrencesOfString:@"${AUCTION_PRICE}" withString:[NSString stringWithFormat:@"%lf",self.price]];
            OMLogD(@"bid notify win:%@",winUrl);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:winUrl]];
            [request setHTTPMethod:@"POST"];
            
                dispatch_queue_t requestQueue =   dispatch_queue_create("com.adt.bid", DISPATCH_QUEUE_SERIAL);
                
                dispatch_async(requestQueue,^{
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
                    }];
                    [task resume];
                });
        }
    }
}


- (void)notifyLossWithReasonCode:(OMBiddingLossedReasonCode)lossReasonCode {
    if (!self.bidNotification) {
        self.bidNotification = YES;
        if (self.notifyLoss) {
            self.notifyLoss();
        } else if ([self.lurl length] >0) {
            NSString *lossUrl = [self.lurl stringByReplacingOccurrencesOfString:@"${AUCTION_PRICE}" withString:[NSString stringWithFormat:@"%lf",self.price+0.1]];
            lossUrl = [lossUrl stringByReplacingOccurrencesOfString:@"${AUCTION_LOSS}" withString:[NSString stringWithFormat:@"%zd",lossReasonCode]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:lossUrl]];
            OMLogD(@"bid notify loss:%@",lossUrl);
            [request setHTTPMethod:@"POST"];
            
                dispatch_queue_t requestQueue =   dispatch_queue_create("com.adt.bid", DISPATCH_QUEUE_SERIAL);
                
                dispatch_async(requestQueue,^{
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
                    }];
                    [task resume];
                });
            }
    }
}

@end
