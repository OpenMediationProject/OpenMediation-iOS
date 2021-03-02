// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionJSBridge.h"
#import "OMConfig.h"
#import "OMRequest.h"

@implementation OMCrossPromotionJSBridge

- (instancetype)initWithBindWebView:(WKWebView*)bindWebView placementID:(NSString*)placementID {
    if (self = [super init]) {
        self.eventNames = @[@"wv.init",@"wv.show",@"wv.pause",@"wv.resume",@"wv.muted",@"wv.unmute"];
        self.bindWebView = bindWebView;
        [bindWebView.configuration.userContentController addScriptMessageHandler:self name:@"sdk"];
        self.placementID = placementID;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"sdk"]) {
      NSString *bodyStr = message.body;
      NSDictionary *body = [NSDictionary dictionary];
        if (!OM_STR_EMPTY(bodyStr)) {
            NSData *data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonErr = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
            if (!jsonErr && dict) {
                body = [dict copy];
            }
        }
      NSString *msg = @"";
      NSDictionary *parm = [NSDictionary dictionary];
      if([body isKindOfClass:[NSDictionary class]]) {
          msg = body[@"m"];
          if ([body objectForKey:@"d"]) {
              parm = body[@"d"];
          }
      }
        
        if ([msg isEqual:@"jsLoaded"]) {
            [self sendEvent:OMCrossPromotionJSEventInit];
            
        } else if ([msg isEqualToString:@"pushEvent"]) {
            NSString *p = parm[@"e"];
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgePushEvent:)]) {
                [self.jsMessageHandler jsBridgePushEvent:p];
            }
        } else if ([msg isEqualToString:@"setCloseVisible"]) {
            NSNumber *p = parm[@"visible"];
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgeSetCloseVisible:)]) {
                [self.jsMessageHandler jsBridgeSetCloseVisible:[p boolValue]];
            }
        } else if ([msg isEqualToString:@"close"]) {
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgeClose)]) {
                [self.jsMessageHandler jsBridgeClose];
            }
        } else if ([msg isEqualToString:@"click"]) {
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgeClick:)]) {
                [self.jsMessageHandler jsBridgeClick:YES];
            }
        } else if ([msg isEqualToString:@"wvclick"]) {
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgeClick:)]) {
                [self.jsMessageHandler jsBridgeClick:NO];
            }
        } else if ([msg isEqualToString:@"openBrowser"]) {
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgWillOpenBrowser)]) {
                [self.jsMessageHandler jsBridgWillOpenBrowser];
            }
            NSString *p = parm[@"url"];
            if (!OM_STR_EMPTY(p)) {
                NSURL *url = [NSURL URLWithString:p];
                [[UIApplication sharedApplication]openURL:url];
            }
        } else if ([msg isEqualToString:@"reportVideoProgress"]) {
            NSNumber *p = parm[@"progress"];
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgeVideoPlayProgress:)]) {
                [self.jsMessageHandler jsBridgeVideoPlayProgress:[p integerValue]];
            }
        } else if ([msg isEqualToString:@"addRewarded"]) {
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgeAddRewarded)]) {
                [self.jsMessageHandler jsBridgeAddRewarded];
            }
        } else if ([msg isEqualToString:@"refreshAd"]) {
            NSNumber *p = parm[@"delay"];
            if(self.jsMessageHandler && [self.jsMessageHandler respondsToSelector:@selector(jsBridgeRefreshAd:)]) {
                [self.jsMessageHandler jsBridgeRefreshAd:[p integerValue]];
            }
        }
    }
}


- (void)sendEvent:(OMCrossPromotionJSEvent)event {
    
    if (self.bindWebView) {
        NSMutableDictionary *eventData = [NSMutableDictionary dictionary];
        
        if (event < self.eventNames.count) {
            [eventData setObject:self.eventNames[event] forKey:@"type"];
        }
        
        if (event == OMCrossPromotionJSEventInit) {
        
            NSMutableDictionary *base = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
            [base setObject:[OMConfig sharedInstance].appKey forKey:@"appk"];
            [base setObject:OPENMEDIATION_SDK_VERSION forKey:@"sdkv"];
            
            [eventData setObject:base forKey:@"bfs"];
            
            OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:self.placementID];
            if (unit) {
                [eventData setObject:unit.unitModel forKey:@"placement"];
                NSString *sceneID = [[NSUserDefaults standardUserDefaults]stringForKey:[NSString stringWithFormat:@"%@_scene",self.placementID]];
                OMScene *scene = [unit getSceneById:sceneID];
                if (scene) {
                    [eventData setObject:@{@"id":[NSNumber numberWithInteger:[scene.sceneID integerValue]],@"name":scene.sceneName} forKey:@"scene"];
                }
            }
            
            if (self.campaign) {
                
                NSMutableDictionary *campaignData = [NSMutableDictionary dictionaryWithDictionary:[self.campaign originData]];
                if (self.campaign.model.app[@"icon"]) {
                    
                    NSMutableDictionary *app = [NSMutableDictionary dictionaryWithDictionary:[campaignData objectForKey:@"app"]];
                    [app setObject:[NSURL fileURLWithPath:[self.campaign iconCachePath]].absoluteString forKey:@"icon"];
                    [campaignData setObject:app forKey:@"app"];
                }
                
                NSMutableArray *imgs = [NSMutableArray array];
                for (NSString *img in self.campaign.model.imgs) {
                    [imgs addObject:[NSString omUrlCachePath:img]];
                }                
                [campaignData setObject:[imgs copy] forKey:@"imgs"];

                if (self.campaign.model.video[@"url"]) {
                    NSMutableDictionary *app = [NSMutableDictionary dictionaryWithDictionary:[campaignData objectForKey:@"video"]];
                    [app setObject:[NSURL fileURLWithPath:[self.campaign videoCachePath]].absoluteString forKey:@"url"];
                    [campaignData setObject:app forKey:@"video"];
                }
                if (self.campaign.model.resources.count >0) {
                    NSMutableArray *resourceLocalPaths = [NSMutableArray array];
                    for (NSString *resource in self.campaign.model.resources) {
                        [resourceLocalPaths  addObject:[NSString omUrlCachePath:resource]];
                    }
                    [campaignData setObject:resourceLocalPaths forKey:@"resources"];
                }
                
                [eventData setObject:campaignData forKey:@"campaign"];
            }
        }
        
        NSString *eventMsg = [self obj2JsonStr:eventData];
        
        NSString *criptJS = [NSString stringWithFormat:@"window.postMessage(%@, '*')",eventMsg];
        
        [self.bindWebView evaluateJavaScript:criptJS completionHandler:nil];
    }
    
}

- (void)handleApplicationDidBecomeActive {
    [self sendEvent:OMCrossPromotionJSEventResume];
}

- (void)handleApplicationWillResignActive {
    [self sendEvent:OMCrossPromotionJSEventPause];
}

- (NSString*)obj2JsonStr:(NSObject*)object {
    NSString *jsonStr = @"{}";
    if(object && ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]])) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
        if(!error && jsonData) {
            jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return jsonStr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:self];
}

@end
