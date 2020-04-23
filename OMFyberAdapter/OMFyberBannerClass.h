// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMFyberBannerClass_h
#define OMFyberBannerClass_h


@class IAAdRequest;
@class IAMediation;
@class IAAdModel;
@class IAAdSpot;

typedef NS_ENUM(NSInteger, IAUserGenderType) {
    IAUserGenderTypeUnknown = 0,
    IAUserGenderTypeMale,
    IAUserGenderTypeFemale,
    IAUserGenderTypeOther,
};

@protocol IAUserDataBuilder <NSObject>

@required

@property (nonatomic) NSUInteger age;
@property (nonatomic) IAUserGenderType gender;
@property (nonatomic, copy, nullable) NSString *zipCode;

@end

@interface IAUserData : NSObject

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAUserDataBuilder> _Nonnull builder))buildBlock;

@end

@protocol IAAdRequestBuilder <NSObject>

@required

@property (nonatomic) BOOL useSecureConnections;

/**
 *  @brief A mandatory parameter.
 */
@property (nonatomic, copy, nonnull) NSString *spotID;

/**
 *  @brief The request timeout in seconds before the 'ready on client' will be received.
 *
 *  @discussion The min value is 1, the max value is 180, the default is 10. In case the input param is out of bounds, the default one will be set.
 */
@property (nonatomic) NSTimeInterval timeout;

@property (nonatomic, copy, nullable) IAUserData *userData;

/**
 *  @brief Single keyword string or several keywords, separated by comma.
 */
@property (nonatomic, copy, nullable) NSString *keywords;

/**
 *  @brief Current location. Use for better ad targeting.
 */
@property (nonatomic, copy, nullable)  id location;

@property (nonatomic, copy, nullable) id debugger;

/**
 *  @brief Subtype expected configuration. In case a certain type of ad has extra configuration, assign it here.
 */
@property (nonatomic, copy, nullable) id subtypeDescription;

@optional

/**
 *  @brief In case is enabled and the responded creative supports this feature, the creative will start interacting without sound.
 */
@property (nonatomic) BOOL muteAudio;

@end

@interface IAAdRequest : NSObject

/**
 *  @brief Use in order to determine type of unit returned.
 *  @discussion Will be assigned at response parsing phase.
 */
@property (nonatomic, strong, nullable, readonly) NSString *unitID;

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAAdRequestBuilder> _Nonnull builder))buildBlock;

@end

@class IAUnitController;

@protocol IAInterfaceBuilder;

@protocol IAInterfaceAllocBlocker <NSObject>

@required
+ (null_unspecified instancetype)alloc __attribute__((unavailable("<Inneractive> The 'alloc' is not available, use 'build:' instead.")));
- (null_unspecified instancetype)init __attribute__((unavailable("<Inneractive> The 'init' is not available, use 'build:' instead.")));
+ (null_unspecified instancetype)new __attribute__((unavailable("<Inneractive> The 'new' is not available, use 'build:' instead.")));

@end

@protocol IAInterfaceBuilder <IAInterfaceAllocBlocker>

@required
+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAInterfaceBuilder> _Nonnull builder))buildBlock;

@end

typedef void (^IAAdSpotAdResponseBlock)(IAAdSpot * _Nullable adSpot, IAAdModel * _Nullable adModel, NSError * _Nullable error);

@protocol IAAdSpotBuilder <NSObject>

@required
@property (atomic, copy, nonnull) IAAdRequest *adRequest;
@property (nonatomic, copy, nonnull) IAMediation *mediationType;

- (void)addSupportedUnitController:(IAUnitController * _Nonnull)supportedUnitController;

@end

@interface IAAdSpot : NSObject <IAInterfaceBuilder, IAAdSpotBuilder>

/**
 *  @brief The unit controller, that is relevant to the received ad unit.
 */
@property (nonatomic, weak, readonly, nullable) IAUnitController *activeUnitController;

@property (nonatomic, strong, readonly, nullable) IAAdModel *model;

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAAdSpotBuilder> _Nonnull builder))buildBlock;

/**
 *  @brief Fetch ad. Ad response block must be provided, otherwise fetch will not be performed.
 *
 *  @discussion Ad response block will be retained, therefore 'self' should not be used insided this block. Please use weak reference to 'self' instead.
 * This block will be invoked both on first ad request result, and on ad refresh result.
 */
- (void)fetchAdWithCompletion:(IAAdSpotAdResponseBlock _Nonnull)completionHandler;

/**
 *  @brief Use for being notified about ad reload result.
 *  @discussion IA SDK will copy this block, if you want to clean it, you should provide a 'nil' value.
 */
- (void)setAdRefreshCompletion:(IAAdSpotAdResponseBlock _Nonnull)completionHandler;

- (void)refreshAd;

@end

@protocol IAUnitDelegate;
@class IAContentController;

@protocol IAUnitControllerBuilderProtocol <NSObject>

@required
- (void)addSupportedContentController:(IAContentController * _Nonnull)supportedContentController;

@end

@protocol IAInterfaceUnitController <IAUnitControllerBuilderProtocol>

@required

@property (nonatomic, weak, nullable) id<IAUnitDelegate> unitDelegate;

/**
 *  @brief The content controller, that is relevant to the received ad unit.
 */
@property (nonatomic, weak, readonly, nullable) IAContentController *activeContentController;

/**
 *  @brief Cleans all internal data. After use of this method, current unit controller is no more useable until a new response of same ad unit type is received.
 */
- (void)clean;

@end

@class IAUnitController;

@protocol IAUnitDelegate <NSObject>

@required

/**
 *  @brief Required delegate method for supplying parent view controller. App will crash, if it is not implemented in delegate and delegate declares itself as conforming to protocol.
 *
 *  @discussion The 'modalPresentationStyle' property of the supplied view controller will be changed to 'UIModalPresentationFullScreen';
 */
- (UIViewController * _Nonnull)IAParentViewControllerForUnitController:(IAUnitController * _Nullable)unitController;

@optional
- (void)IAAdDidReceiveClick:(IAUnitController * _Nullable)unitController;
- (void)IAAdWillLogImpression:(IAUnitController * _Nullable)unitController;

/**
 *  @brief The rewarded units callback for a user reward.
 *
 *  @discussion This callback is called for all type of the rewarded content, both HTML/JS and video (VAST/VPAID).
 */
- (void)IAAdDidReward:(IAUnitController * _Nullable)unitController;
#warning in order to use the rewarded callback for all available rewarded content, you will have to implement this method (not the `IAVideoCompleted:`;

- (void)IAUnitControllerWillPresentFullscreen:(IAUnitController * _Nullable)unitController;
- (void)IAUnitControllerDidPresentFullscreen:(IAUnitController * _Nullable)unitController;
- (void)IAUnitControllerWillDismissFullscreen:(IAUnitController * _Nullable)unitController;
- (void)IAUnitControllerDidDismissFullscreen:(IAUnitController * _Nullable)unitController;

- (void)IAUnitControllerWillOpenExternalApp:(IAUnitController * _Nullable)unitController;
@end


@protocol IAViewUnitControllerBuilder <IAUnitControllerBuilderProtocol>

@required
@property (nonatomic, weak, nullable) id<IAUnitDelegate> unitDelegate;

@end

@interface IAUnitController : NSObject
@property (nonatomic, weak, readonly, nullable) IAContentController *activeContentController;
@end

@interface IAContentController : NSObject

@end

@interface IAAdView : UIView

@end

@interface IAViewUnitController : IAUnitController <IAInterfaceBuilder, IAViewUnitControllerBuilder>

@property (nonatomic, strong, readonly, nullable) IAAdView *adView;

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAViewUnitControllerBuilder> _Nonnull builder))buildBlock;

- (void)showAdInParentView:(UIView * _Nonnull)parentView;

@end

@class IAAdModel;
@protocol IAMRAIDContentDelegate;

@protocol IAMRAIDContentControllerBuilder <NSObject>

@required
@property (nonatomic, weak, nullable) id<IAMRAIDContentDelegate> MRAIDContentDelegate;

@optional
@property (nonatomic, getter=isContentAwareBackground) BOOL contentAwareBackground;

@end

@interface IAMRAIDContentController : IAContentController <IAInterfaceBuilder, IAMRAIDContentControllerBuilder>

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAMRAIDContentControllerBuilder> _Nonnull builder))buildBlock;

@end


@class IAAdModel;
@protocol IAVideoContentDelegate;

@protocol IAVideoContentControllerBuilder <NSObject>

@required
@property (nonatomic, weak, nullable) id<IAVideoContentDelegate> videoContentDelegate;

@end

@interface IAVideoContentController : IAContentController <IAInterfaceBuilder, IAVideoContentControllerBuilder>

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAVideoContentControllerBuilder> _Nonnull builder))buildBlock;

@property (nonatomic, readwrite, getter=isMuted) BOOL muted;

/**
 *  @brief Manual play.
 *  @discussion Use this API only if manual control is needed, since this API disables auto play/pause.
 */
- (void)play;

/**
 *  @brief Manual pause.
 *  @discussion Use this API only if manual control is needed, since this API disables auto play/pause.
 */
- (void)pause;

@end


#endif /* OMFyberBannerClass_h */
