// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OMUserData : NSObject

@property (nonatomic, assign)  NSInteger consent;//gdpr -1,0,1
@property (nonatomic, assign)  BOOL childrenApp;//coppa
@property (nonatomic, assign)  BOOL USPrivacy;//CCPA

@property (nonatomic, assign) NSInteger userAge; // age
@property (nonatomic, assign) NSInteger userGender; // 0:unknown,1:male,2:female

@property (nonatomic, strong) NSString *customUserID;
@property (nonatomic, strong) NSMutableDictionary *tags;

@property (nonatomic, assign) CGFloat purchaseAmount;

@property (nonatomic, assign) double lifeTimeValue;

+ (instancetype)sharedInstance;

-(void)userPurchase:(CGFloat)amout currency:(NSString*)currencyUnit;


- (void)addRevelue:(double)revenue;

@end

NS_ASSUME_NONNULL_END
