// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "OMCrossPromotionCampaign.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OMCrossPromotionJSEvent) {
    OMCrossPromotionJSEventInit = 0 ,
    OMCrossPromotionJSEventShow,
    OMCrossPromotionJSEventPause,
    OMCrossPromotionJSEventResume,
    OMCrossPromotionJSEventMuted,
    OMCrossPromotionJSEventUnmute,
};

@protocol OMCrossPromotionJSBridgeDelegate<NSObject>

@optional

- (void)jsBridgePushEvent:(NSString*)eventBody;

- (void)jsBridgeSetCloseVisible:(BOOL)visible;

- (void)jsBridgeClose;

- (void)jsBridgeClick:(BOOL)trackClick;

- (void)jsBridgWillOpenBrowser;

- (void)jsBridgeVideoPlayProgress:(NSInteger)percentage;

- (void)jsBridgeAddRewarded;

- (void)jsBridgeRefreshAd:(NSInteger)millisecond;

@end

@interface OMCrossPromotionJSBridge : NSObject <WKScriptMessageHandler>

@property (nonatomic, copy) NSArray *eventNames;
@property (nonatomic, weak) WKWebView *bindWebView;
@property (nonatomic, strong) NSString *placementID;
@property (nonatomic, strong) OMCrossPromotionCampaign *campaign;
@property (nonatomic, weak) id<OMCrossPromotionJSBridgeDelegate> jsMessageHandler;

- (instancetype)initWithBindWebView:(WKWebView*)bindWebView placementID:(NSString*)placementID;

- (void)sendEvent:(OMCrossPromotionJSEvent)event;
@end

NS_ASSUME_NONNULL_END
