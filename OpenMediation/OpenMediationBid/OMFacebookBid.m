// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookBid.h"
#import "OMFacebookBidClass.h"
#import "OMToolUmbrella.h"



NSString * const OMFbBidError = @"com.om.fbbid";

@implementation OMFacebookBid

+ (void)bidWithNetworkItem:(OMBidNetworkItem*)networkItem adFormat:(OpenMediationAdFormat)format responseCallback:(void(^)(OMBidResponse *bidResponse))callback {
     NSString *appKey = networkItem.appKey;
     NSString *placementID = networkItem.placementID;
     NSInteger maxTimeoutMS = networkItem.maxTimeOutMS;
     BOOL testMode = networkItem.testMode;
    
    if (![appKey length] || ![placementID length]) {
        OMBidResponse *bidResponse = [OMBidResponse buildResponseWithError:@"Required input params(appID placementID) for Facebook bidding is invalid"];
        callback(bidResponse);
        return;
    }
    
    FBAdBidFormat fbAdFormat = [self convertWithFormat:format];
    if (fbAdFormat < 0) {
        OMBidResponse *bidResponse = [OMBidResponse buildResponseWithError:@"current network still not support this adType"];
        callback(bidResponse);
        return;
    }
    
    Class fbBidRequest = NSClassFromString(@"FBAdBidRequest");
    Class fbSetting = NSClassFromString(@"FBAdSettings");
    SEL bidUrlSelector = NSSelectorFromString(@"getBaseBiddingURL");
    SEL testBidSelector = NSSelectorFromString(@"getAudienceNetworkTestBidForAppID:placementID:platformID:adFormat:maxTimeoutMS:responseCallback:");
    SEL bidSelector = NSSelectorFromString(@"getAudienceNetworkBidForAppID:placementID:platformID:adFormat:maxTimeoutMS:coppa:auctionType:doNotTrack:responseCallback:");
    
    if (testMode && fbSetting && [fbSetting respondsToSelector:bidUrlSelector] && fbBidRequest && [fbBidRequest respondsToSelector:testBidSelector] ) {
        [fbBidRequest getAudienceNetworkTestBidForAppID:appKey placementID:placementID platformID:appKey adFormat:fbAdFormat maxTimeoutMS:maxTimeoutMS responseCallback:^(FBAdBidResponse *fbBidResponse) {
            if (fbBidResponse.isSuccess) {
                OMBidResponse *bidResponse = [OMBidResponse buildResponseWithPrice:fbBidResponse.getPrice currency:fbBidResponse.getCurrency payLoad:fbBidResponse.getPayload notifyWin:^{
                    [fbBidResponse notifyWin];
                } notifyLoss:^{
                    [fbBidResponse notifyLoss];
                }];
                callback(bidResponse);
            } else {
                OMBidResponse *bidResponse = [OMBidResponse buildResponseWithError:fbBidResponse.getErrorMessage];
                callback(bidResponse);
            }
        }];

    } else if (fbSetting && [fbSetting respondsToSelector:bidUrlSelector] && fbBidRequest && [fbBidRequest respondsToSelector:bidSelector]) {
        [fbBidRequest getAudienceNetworkBidForAppID:appKey placementID:placementID platformID:appKey adFormat:fbAdFormat maxTimeoutMS:maxTimeoutMS coppa:NO auctionType:FBAdBidAuctionType_First_Price doNotTrack:NO responseCallback:^(FBAdBidResponse *fbBidResponse) {
            if (fbBidResponse.isSuccess) {
                OMBidResponse *bidResponse = [OMBidResponse buildResponseWithPrice:fbBidResponse.getPrice currency:fbBidResponse.getCurrency payLoad:fbBidResponse.getPayload notifyWin:^{
                    [fbBidResponse notifyWin];
                } notifyLoss:^{
                    [fbBidResponse notifyLoss];
                }];
                callback(bidResponse);
            } else {
                OMBidResponse *bidResponse = [OMBidResponse buildResponseWithError:fbBidResponse.getErrorMessage];
                callback(bidResponse);
            }
        }];
    } else {
        OMBidResponse *bidResponse = [OMBidResponse buildResponseWithError:@"fb adnetwork not support bid kit"];
        callback(bidResponse);
        return;
    }
    
    

    
}

+ (FBAdBidFormat)convertWithFormat:(OpenMediationAdFormat)format {
    FBAdBidFormat fbAdFormat = -1;
    switch (format) {
        case OpenMediationAdFormatBanner:
            fbAdFormat = FBAdBidFormatBanner_300_50;
            break;
        case OpenMediationAdFormatNative:
            fbAdFormat = FBAdBidFormatNative;
            break;
        case OpenMediationAdFormatInterstitial:
            fbAdFormat = FBAdBidFormatInterstitial;
            break;
        case OpenMediationAdFormatRewardedVideo:
            fbAdFormat = FBAdBidFormatRewardedVideo;
            break;
        default:
            break;
    }
    return fbAdFormat;

}

+ (NSString*)bidderToken {
    NSString *token = @"";
    Class fbSetting = NSClassFromString(@"FBAdSettings");
    if (fbSetting && [fbSetting respondsToSelector:@selector(bidderToken)]) {
        token = [fbSetting bidderToken];
    }
    return token;
}

@end
