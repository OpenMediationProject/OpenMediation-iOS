// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMTapjoyClass_h
#define OMTapjoyClass_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define TJC_CONNECT_SUCCESS                    @"TJC_Connect_Success"
#define TJC_LIMITED_CONNECT_SUCCESS                    @"TJC_Limited_Connect_Success"
#define TJC_CONNECT_FAILED                    @"TJC_Connect_Failed"
#define TJC_LIMITED_CONNECT_FAILED                    @"TJC_Limited_Connect_Failed"
@interface Tapjoy :  NSObject
+ (void)connect:(NSString *)sdkKey;
+ (void)limitedConnect:(NSString *)sdkKey;
+ (NSString*)getVersion;
+ (void)setUserConsent:(NSString*) value;
@end

@interface TJPrivacyPolicy : NSObject

+ (id)sharedInstance;

/**
 * This is used for sending User's consent to behavioral advertising such as in the context of GDPR
 * The consent value can be "0" (User has not provided consent), "1" (User has provided consent) or
 * a daisybit string as suggested in IAB's Transparency and Consent Framework
 *
 * @param value "0" (User has not provided consent), "1" (User has provided consent) or a daisybit string as suggested in IAB's Transparency and Consent Framework
 **/
- (void)setUserConsent:(NSString*) value;

/**
 * This can be used by the integrating App to indicate if the user falls in any of the GDPR applicable countries
 * (European Economic Area). The value should be set to YES when User (Subject) is applicable to GDPR regulations
 * and NO when User is not applicable to GDPR regulations. In the absence of this call, Tapjoy server makes the
 * determination of GDPR applicability.
 *
 * @param gdprApplicability YES if the user is affected by GDPR, NO if they are not.
 */
- (void)setSubjectToGDPR:(BOOL) gdprApplicability;

/**
 * In the US, the Children’s Online Privacy Protection Act (COPPA) imposes certain requirements on operators of online services that (a)
 * have actual knowledge that the connected user is a child under 13 years of age, or (b) operate services (including apps) that are
 * directed to children under 13.
 *
 * Similarly, the GDPR imposes certain requirements in connection with data subjects who are below the applicable local minimum age for
 * online consent (ranging from 13 to 16, as established by each member state).
 *
 * For applications that are not directed towards children under 13 years of age, but still have a minority share of users known to be
 * under the applicable minimum age, utilize this method to access Tapjoy’s monetization capability. This method will set
 * ad_tracking_enabled to false for Tapjoy which only shows the user contextual ads. No ad tracking will be done on this user.
 *
 * @param isBelowConsentAge YES if the user is affected by COPPA, NO if they are not.
 */
- (void)setBelowConsentAge:(BOOL) isBelowConsentAge;

/**
 * This is used for sending US Privacy value to behavioral advertising such as in the context of GDPR
 * The value can be in IAB's US Privacy String Format consists of specification version to encode the string in number, explicit notice or opportunity to opt out in enum, opt-out sale in enum, LSPA covered transaction in enum .
 * eg. "1YNN" where 1 is char in string for the version, Y = YES, N = No, - = Not Applicable
 * See: IAB suggested US Privacy String Format : https://github.com/InteractiveAdvertisingBureau/USPrivacy/blob/master/CCPA/Version%201.0/US%20Privacy%20String.md#us-privacy-string-format
 *
 * @param privacyValue The us privacy value string
 */
- (void)setUSPrivacy:(NSString*) privacyValue;

@end;


typedef enum TJCActionRequestTypeEnum {
    TJActionRequestInAppPurchase = 1,
    TJActionRequestVirtualGood,
    TJActionRequestCurrency,
    TJActionRequestNavigation
} TJCActionRequestType;
/**
 A request for an app to take an action, triggered by TJPlacement content.
 
 */
@interface TJActionRequest : NSObject

/**
 * The type of the request
 */
@property (nonatomic,assign) TJCActionRequestType type;

/**
 * Called by your app to indicate that the request was processed successfully.
 */
- (void)completed;

/**
 * Called by your app to indicate that the request was cancelled or otherwise not successfully completed.
 */
- (void)cancelled;

@property (nonatomic, copy) id callback;

/**
 * The identifier associated with the request.
 */
@property (nonatomic, copy) NSString* requestId;

/**
 * The identifier associated with the request.
 */
@property (nonatomic, copy) NSString* token;

@end

@class TJPlacement;

/**
 The Tapjoy placement Delegate protocol. Adopt this protocol in order to handle responses that send are received upon sending a TJPlacement.
 
 The methods to prepare are:
 
 - requestDidSucceed: Called when a placement request is sent successfully
 - requestDidFail:error: Called when an error occurs while sending the placement request
 - contentIsReady: Called when content for a placement is loaded and ready to display
 - contentDidAppear: Called when placement content did appear
 - contentDidDisappear: Called when placement content did disappear
 - placement:didRequestPurchase:productId: Called when the user has successfully completed a purchase request
 - placement:didRequestReward:itemId:quantity:(int)quantity: Called when the user successfully requests a reward
 
 */
@protocol TJPlacementDelegate <NSObject>

@optional

/**
 * Callback issued by TJ to publisher to state that placement request is successful
 */
- (void)requestDidSucceed:(TJPlacement*)placement;

/**
 * Called when an error occurs while sending the placement
 * @param placement The TJPlacement that was sent
 * @error error code
 */
- (void)requestDidFail:(TJPlacement*)placement error:(NSError*)error;

/**
 * Called when content for an placement is successfully cached
 * @param placement The TJPlacement that was sent
 */
- (void)contentIsReady:(TJPlacement*)placement;

/**
 * Called when placement content did appear
 * @param placement The TJPlacement that was sent
 */
- (void)contentDidAppear:(TJPlacement*)placement;

/**
 * Called when placement content did disappear
 * @param placement The TJPlacement that was sent
 */
- (void)contentDidDisappear:(TJPlacement*)placement;


/**
 * Callback issued by TJ to publisher when the user has successfully completed a purchase request
 * @param request - The TJActionRequest object
 * @param productId - the id of the offer that sent the request
 */
- (void)placement:(TJPlacement*)placement didRequestPurchase:(TJActionRequest*)request productId:(NSString*)productId;

/**
 * Callback issued by TJ to publisher when the user has successfully requests a reward
 * @param placement - The TJPlacement that triggered the action request
 * @param request   - The TJActionRequest object
 * @param itemId    - The itemId for whose reward has been requested
 * @param quantity  - The quantity of the reward for the requested itemId
 */

- (void)placement:(TJPlacement*)placement didRequestReward:(TJActionRequest*)request itemId:(NSString*)itemId quantity:(int)quantity;


@end

/**
 * Delegate used to receive video events from TJPlacement
 */
@protocol TJPlacementVideoDelegate <NSObject>

@optional

/**
 * Called when a placement video starts playing.
 *
 */
- (void)videoDidStart:(TJPlacement*)placement;

/**
 * Called when a placement video has completed playing.
 *
 */
- (void)videoDidComplete:(TJPlacement*)placement;

/**
 * Called when a placement video related error occurs.
 *
 * @param errorMsg Error message.
 */
- (void)videoDidFail:(TJPlacement*)placement error:(NSString*)errorMsg;
@end

/**
 The Tapjoy placement-Based Framework allows one to identify key placements within their application during development,
 and then reconfigure them on the dashboard as desired to help maximize monetization and engagement, without the need to update or resubmit the application.
 
 Use the TJPlacement class to define placement points in your application where ads and other content can be served.
 placements could include launching the application, completing an achievement, finishing a level, or any other moment conducive to communicating with your users.
 
 During your application development process, the key steps are to:
 
 1. Create and configure each placement as a TJPlacement
 
 TJPlacement *placement = [TJPlacement placementWithName: @"level_complete" delegate: self];
 
 2. Request content
 
 [placement requestContent];
 
 3. Present any content that is returned by the placement callbacks defined in TJPlacementDelegate
 */
@interface TJPlacement : NSObject

/** The TJPlacementDelegate used to handle responses that are received upon sending this placement*/
@property (nonatomic, weak) id<TJPlacementDelegate> delegate;

/** The delegate that implements the TJPlacementVideoDelegate protocol */
@property (nonatomic, weak) id<TJPlacementVideoDelegate> videoDelegate;

/** The name of the placement */
@property (nonatomic, copy) NSString *placementName;

/** Whether content has been loaded and is ready to be presented */
@property (nonatomic, assign, readonly, getter=isContentReady) BOOL contentReady;

/** Whether content is available for this placement */
@property (nonatomic, assign, readonly, getter=isContentAvailable) BOOL contentAvailable;

/** The UIViewController to show the content in */
@property (nonatomic, retain) UIViewController* presentationViewController;

/** Allows plugins to specify a topViewController class (currently only used by Unity) */
@property (nonatomic, copy) NSString *topViewControllerClassName;

/**
 * Creates a new instance of TJPlacement
 * @param placementName The name of the placement
 * @param delegate The class that implements the TJPlacementDelegate protocol
 */
+ (id)placementWithName:(NSString*)placementName delegate:(id<TJPlacementDelegate>)delegate;

/**
 * Sends the placement request to the server
 *
 */
- (void)requestContent;

/**
 * Shows the content that was received from the server after sending this placement
 */
- (void)showContentWithViewController:(UIViewController*)viewController;

/**
 * Dismiss the content
 */
+ (void)dismissContent;

/** Mediation params(used by mediation adapters only) */
@property (nonatomic, copy) NSString *mediationAgent;
@property (nonatomic, copy) NSString *mediationId;
+ (id)placementWithName:(NSString*)placementName mediationAgent:(NSString*)mediationAgent mediationId:(NSString*)mediationId delegate:(id<TJPlacementDelegate>)delegate;

@property (nonatomic, copy) NSString *adapterVersion;

/** Programmatic mediation */
@property (nonatomic, copy) NSDictionary *auctionData;

/** Used by limited SDK request Only **/
@property (nonatomic, assign) BOOL isLimited;
+ (id)limitedPlacementWithName:(NSString*)placementName mediationAgent:(NSString*)mediationAgent delegate:(id<TJPlacementDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END

#endif /* OMTapjoyClass_h */
