// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralSplashClass_h
#define OMMintegralSplashClass_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MTGBool) {
    /* No */
    MTGBoolNo = -1,
    
    /* Unknown */
    MTGBoolUnknown = 0,
    
    /* Yes */
    MTGBoolYes = 1,
};


typedef NS_ENUM(NSUInteger, MTGInterfaceOrientation) {
    MTGInterfaceOrientationAll = 0,       // to use current orientation of the device.
    MTGInterfaceOrientationPortrait = 1,  // to force to use portrait mode.
    MTGInterfaceOrientationLandscape = 2, // to force to use landscape mode.
};

@protocol MTGSplashADDelegate;


@interface MTGSplashAD : NSObject

/**
 Initialize a MTGSplashAD instance.
 @param placementID placementId String.
 @param unitID unitID String.
 @param countdown time duration of the ad can be showed. Should be range of 2-10s.
 @param allowSkip Whether or not to allow user to skip ad when showing.
 
 */
- (instancetype)initWithPlacementID:(nullable NSString *)placementID
                             unitID:(NSString *)unitID
                          countdown:(NSUInteger)countdown
                          allowSkip:(BOOL)allowSkip;

/**
 Initialize a MTGSplashAD instance with more detailed info.

 @param placementID placementId String.
 @param unitID unitID String.
 @param countdown time duration of the ad can be showed. Should be range of 2-10s.
 @param allowSkip whether or not to allow user to skip ad when showing.
 @param customViewSize if you want to display your own custom view on the ad area, you should pass the corresponding CGSize of your custome view.
 @param preferredOrientation specify preferred orientation to show the ad.
 
 @note  1. when you showing ad on the portrait mode, the height of the customViewSize should not           greater than 25% of the device's height.
        2. when you showing ad on the landscape mode, the width of the customViewSize should not greater than 25% of the device's width.
 */
- (instancetype)initWithPlacementID:(nullable NSString *)placementID
                             unitID:(NSString *)unitID
                          countdown:(NSUInteger)countdown
                          allowSkip:(BOOL)allowSkip
                     customViewSize:(CGSize)customViewSize
               preferredOrientation:(MTGInterfaceOrientation)preferredOrientation;

/* Set delegate to receive protocol event.  */
@property (nonatomic, weak) id <MTGSplashADDelegate> delegate;

/* corresponding placementId when you initialize the MTGSplashAD. */
@property (nonatomic, readonly, copy) NSString *placementID;

/* corresponding unitID when you initialize the MTGSplashAD. */
@property (nonatomic, readonly, copy) NSString *unitID;

/* Set this to show your own background image when loading ad. */
@property (nonatomic, strong) UIImage *backgroundImage;

/* Set this to show your own background color when loading ad. */
@property (nonatomic, copy) UIColor *backgroundColor;


/********************** Normal Request ***************************/

/**
 Show the ad after load successfully.

 @param window must be the key window of the application.
 @param customView display your own custom view, e.g. logo view.
 @param timeout load timeout, unit should be millisecond. If you passed 0 then 5000ms would be used.
 
 @note  You should always call this method on the main thread.
 */
- (void)loadAndShowInKeyWindow:(UIWindow *)window
                   customView:(nullable UIView *)customView
                    timeout:(NSInteger)timeout;

/**
 Preload a ad and then use `[MTGSplashAD showInKeyWindow:customView:]` to show the ad.
 @note  You should always call this method on the main thread.
 */
- (void)preload;


/**
 Whether or not if there was a available ad to show.

 @return YES means there was a available ad, otherwise NO.
 */
- (BOOL)isADReadyToShow;

/**
 if there was a available ad to show, you can call this method to show the ad.
 
 @param window must be the key window of the application.
 @param customView display your own custom view, e.g. logo view.

 @note  You should always call this method on the main thread.
 */
- (void)showInKeyWindow:(UIWindow *)window customView:(nullable UIView *)customView;



/********************** Bidding Request ***************************/

/**
 Show the bidding ad after load successfully.
 
 @param window must be the key window of the application.
 @param customView display your own custom view, e.g. logo view.
 @param bidToken token from bid request within MTGBidFramework.
 @param timeout load timeout, unit should be millisecond. If you passed 0 then 5000ms would be used.
 
 @note  You should always call this method on the main thread.
 */
- (void)loadAndShowInKeyWindow:(UIWindow *)window
                 customView:(nullable UIView *)customView
                   bidToken:(NSString *)bidToken
                    timeout:(NSInteger)timeout;

/**
 Preload a bidding ad and then use `[MTGSplashAD showBiddingADInKeyWindow:customView:]` to show the ad.
 @note  You should always call this method on the main thread.
 */
- (void)preloadWithBidToken:(NSString *)bidToken;

/**
 Whether or not if there was a available bidding ad to show.
 
 @return YES means there was a available bidding ad, otherwise NO.
 */
- (BOOL)isBiddingADReadyToShow;

/**
 if there was a available bidding ad to show, you can call this method to show the ad.
 
 @param window must be the key window of the application.
 @param customView display your own custom view, e.g. logo view.
 
 @note  You should always call this method on the main thread.
 */
- (void)showBiddingADInKeyWindow:(UIWindow *)window
                      customView:(nullable UIView *)customView;

@end

@protocol MTGSplashADDelegate <NSObject>

/* Called when preloading ad successfully. */
- (void)splashADPreloadSuccess:(MTGSplashAD *)splashAD;
/* Called when preloading ad failed. */
- (void)splashADPreloadFail:(MTGSplashAD *)splashAD error:(NSError *)error;
/* Called when loading ad successfully. */
- (void)splashADLoadSuccess:(MTGSplashAD *)splashAD;
/* Called when loading ad failed. */
- (void)splashADLoadFail:(MTGSplashAD *)splashAD error:(NSError *)error;
/* Called when showing ad successfully. */
- (void)splashADShowSuccess:(MTGSplashAD *)splashAD;
/* Called when showing ad failed. */
- (void)splashADShowFail:(MTGSplashAD *)splashAD error:(NSError *)error;
/* Called when the application is about to leave as a result of tap event.
   Your application will be moved to the background shortly after this method is called. */
- (void)splashADDidLeaveApplication:(MTGSplashAD *)splashAD;
/* Called when click event occured. */
- (void)splashADDidClick:(MTGSplashAD *)splashAD;
/* Called when ad is about to close. */
- (void)splashADWillClose:(MTGSplashAD *)splashAD;
/* Called when ad did close. */
- (void)splashADDidClose:(MTGSplashAD *)splashAD;
/* Called when remaining countdown update. */
- (void)splashAD:(MTGSplashAD *)splashAD timeLeft:(NSUInteger)time;

@end

NS_ASSUME_NONNULL_END

#endif /* OMMintegralSplashClass_h */
