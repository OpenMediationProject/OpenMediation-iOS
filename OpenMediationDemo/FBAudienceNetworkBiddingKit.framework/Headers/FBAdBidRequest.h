// Copyright 2004-present Facebook. All Rights Reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/**
 Audience Network Bidding For Ad Format
 */

#import "FBAdBidResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FBAdBidFormat) {
    // Bid For Banner 300x50
    FBAdBidFormatBanner_300_50,
    // Bid For Banner 320x50
    FBAdBidFormatBanner_320_50,
    // Bid For Banner with flexible width and height 50
    FBAdBidFormatBanner_HEIGHT_50,
    // Bid For Banner with flexible width and height 90
    FBAdBidFormatBanner_HEIGHT_90,
    // Bid For Banner with flexible width and height 250
    FBAdBidFormatBanner_HEIGHT_250,
    // Bid For Interstitial
    FBAdBidFormatInterstitial,
    // Bid For Native
    FBAdBidFormatNative,
    // Bid For Native Banner
    FBAdBidFormatNativeBanner,
    // Bid For Rewarded Video
    FBAdBidFormatRewardedVideo,
    // Bid For Instream Video
    FBAdBidFormatInstreamVideo,
};

typedef NS_ENUM(NSInteger, FBAdBidAuctionType) {
    FBAdBidAuctionType_First_Price = 1,
    FBAdBidAuctionType_Second_Price = 2
};

@interface FBAdBidRequest: NSObject

/**
 Get Audience Nework Bid for app with default settings:
 Default max time out is set to 10000 ms
 Default auction type is FBAdBidAuctionType_First_Price
 Default Children's Online Privacy Protection Act (COPPA) is FALSE
 Uses system setting for assigning do-not-track-value
 */
+ (void)getAudienceNetworkBidForAppID:(NSString *)appID
                          placementID:(NSString *)placementID
                           platformID:(NSString *)platformID
                             adFormat:(FBAdBidFormat)bidAdFormat
                     responseCallback:(void(^)(FBAdBidResponse *bidResponse))callback;

/**
 Get Audience Nework Bid for app
 isAdvertisingTrackingEnabled from Systems settings takes precendence over doNotTrack param
 when isAdvertisingTrackingEnabled is false
 */
+ (void)getAudienceNetworkBidForAppID:(NSString *)appID
                          placementID:(NSString *)placementID
                           platformID:(NSString *)platformID
                             adFormat:(FBAdBidFormat)bidAdFormat
                         maxTimeoutMS:(NSInteger)maxTimeoutMS
                                coppa:(BOOL)coppa // Children's Online Privacy Protection Act (COPPA) TRUE(1)=child-directed, FALSE(0)=normal (default)
                          auctionType:(FBAdBidAuctionType)auctionType
                           doNotTrack:(BOOL)dnt // // TRUE(1): do-not-track FALSE(0): normal
                     responseCallback:(void(^)(FBAdBidResponse *bidResponse))callback;

/**
 Get Audience Nework Test Bid for app
 */
+ (void)getAudienceNetworkTestBidForAppID:(NSString *)appID
                              placementID:(NSString *)placementID
                               platformID:(NSString *)platformID
                                 adFormat:(FBAdBidFormat)bidAdFormat
                             maxTimeoutMS:(NSInteger)maxTimeoutMS
                         responseCallback:(void(^)(FBAdBidResponse *bidResponse))callback;

@end
NS_ASSUME_NONNULL_END
