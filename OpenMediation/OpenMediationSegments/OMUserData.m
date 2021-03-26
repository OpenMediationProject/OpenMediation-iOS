// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUserData.h"
#import "OMIAPRequest.h"

static OMUserData * _instance = nil;

@implementation OMUserData

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _consent = -1;
        _userAge = 0;
        _userGender = 0;
        _tags = [NSMutableDictionary dictionary];
        _customUserID = @"";
        _lifeTimeValue = [[[NSUserDefaults standardUserDefaults]objectForKey:@"OMLifeTimeValue"]doubleValue];
        _purchaseAmount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"iap_usd"]floatValue];
    }
    return self;
}

-(void)userPurchase:(CGFloat)amout currency:(NSString*)currencyUnit {
    __weak __typeof(self) weakSelf = self;
    [OMIAPRequest iapWithPurchase:amout total:_purchaseAmount currency:currencyUnit completionHandler:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if (!error && [object isKindOfClass:[NSDictionary class]] && weakSelf) {
            weakSelf.purchaseAmount = [[object objectForKey:@"iapUsd"]floatValue];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithFloat:weakSelf.purchaseAmount] forKey:@"iap_usd"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    }];
}

- (void)addRevelue:(double)revenue {
    _lifeTimeValue += revenue;
    [[NSUserDefaults standardUserDefaults]setDouble:_lifeTimeValue forKey:@"OMLifeTimeValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
