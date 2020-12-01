// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <Webkit/Webkit.h>
#import <Storekit/Storekit.h>
#import "OMCrossPromotionWebController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMClickHandlerDelegate<NSObject>

@optional

- (void)clickHandlerWillPresentScreen;
- (void)clickHandlerDisDismissScrren;
- (void)clickHandlerLeaveApplication;
@end

@interface OMCrossPromotionClickHandler : NSObject<WKUIDelegate,WKNavigationDelegate,SKStoreProductViewControllerDelegate,OMWebViewControllerDelegate>

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *campainID;
@property (nonatomic, strong) NSDictionary *ska;
@property (nonatomic, strong) NSString *adUrl;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL storeLoadComplete;
@property (nonatomic, strong, nullable) SKStoreProductViewController *storeVC;
@property (nonatomic, weak) id<OMClickHandlerDelegate> delegate;

- (instancetype)initWithAppID:(NSString*)appID ska:(NSDictionary*)skaParameter adURL:(NSString*)url;
- (void)clickAppAd:(UIViewController*)rootVC scene:(NSString*)sceneID;
- (void)clickWebAd:(UIViewController*)rootVC scene:(NSString*)sceneID;

@end

NS_ASSUME_NONNULL_END
