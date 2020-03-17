// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMBid.h"
#import "OMBidNetworkItem.h"
#import "OMBidResponse.h"
#import "OMEventManager.h"
#import "OMToolUmbrella.h"

@implementation OMBid

- (void)bidWithNetworkItems:(NSArray*)networkItems adFormat:(OpenMediationAdFormat)format completionHandler:(bidCompletionHandler)completionHandler {
    _bidNetworkItems = networkItems;
    _completionHandler = completionHandler;
    _bidResponses = [NSMutableDictionary dictionary];

    
    NSInteger bidMaxTimeOut = 0;
    
    __weak __typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();

    for (OMBidNetworkItem *networkItem in networkItems) {
        if (!OM_STR_EMPTY(networkItem.adnName)) {
            NSString *className = [NSString stringWithFormat:@"OM%@Bid",networkItem.adnName];
            Class bidClass = NSClassFromString(className);
            if (bidClass && [bidClass respondsToSelector:@selector(bidWithNetworkItem:adFormat:responseCallback:)]) {
                NSInteger networkMaxTimeOut = networkItem.maxTimeOutMS;
                if (bidMaxTimeOut < networkMaxTimeOut) {
                    bidMaxTimeOut = networkMaxTimeOut;
                }
                dispatch_group_enter(group);
                
                [bidClass bidWithNetworkItem:networkItem adFormat:format responseCallback:^(OMBidResponse *bidResponse) {
                    if (weakSelf) {
                        @synchronized (weakSelf) {
                            [weakSelf.bidResponses setObject:bidResponse forKey:networkItem.extraData[@"instanceID"] ];
                        }
                    }
                    dispatch_group_leave(group);
                }];
                
            }
        }
    }
    
    if (_bidTimer) {
        [_bidTimer invalidate];
    }
    if (bidMaxTimeOut >0) {
        _bidTimer = [NSTimer scheduledTimerWithTimeInterval:(bidMaxTimeOut/1000.0) target:[OMWeakObject proxyWithTarget:self] selector:@selector(bidTimeOut) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.bidTimer forMode:NSRunLoopCommonModes];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (weakSelf) {
            [weakSelf bidComplete];
        }
    });
}


- (void)bidTimeOut {
    @synchronized (self) {
            for (OMBidNetworkItem *networkItem in _bidNetworkItems) {
            if (![_bidResponses objectForKey:networkItem.extraData[@"instanceID"]]) {
                OMBidResponse *bidResponse = [OMBidResponse buildResponseWithError:@"Bid time out"];
                [_bidResponses setObject:bidResponse forKey:networkItem.extraData[@"instanceID"]];
            }
        }
    }
    [self bidComplete];
}

- (void)bidComplete {
    
    @synchronized (self) {
            if (_bidTimer) {
            [_bidTimer invalidate];
            _bidTimer = nil;
        }
        if (self.completionHandler) {
            self.completionHandler([self.bidResponses copy]);
            self.completionHandler = nil;
        }
    }

}

@end
