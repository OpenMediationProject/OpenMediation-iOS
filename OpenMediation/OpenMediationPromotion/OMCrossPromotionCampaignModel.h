// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionCampaignModel : NSObject

@property (nonatomic, strong) NSDictionary *originData;
@property (nonatomic, strong) NSString *cid; //Campaign ID
@property (nonatomic, strong) NSString *crid; //Creative ID
@property (nonatomic, strong) NSString *title; //Title
@property (nonatomic, strong) NSArray *imgs; //Main image
@property (nonatomic, strong) NSDictionary *video; //Video Object
@property (nonatomic, assign) NSInteger adFormat; //Ad type
@property (nonatomic, strong) NSString *link; //click through url
@property (nonatomic, assign) BOOL iswv; //Open link with webview, 0:No,1:Yes
@property (nonatomic, strong) NSArray *clktks; //click track urls
@property (nonatomic, strong) NSArray *imptks; //impression track urls
@property (nonatomic, strong) NSDictionary *app; //App information
@property (nonatomic, strong) NSString *descn; //Description
@property (nonatomic, strong) NSArray *resources; //List of resources to be loaded
@property (nonatomic, strong) NSString *ps;
@property (nonatomic, strong) NSDictionary *adMark; //AdMark, no need to display admark if this field is empty
@property (nonatomic, assign) NSInteger expire; //campaign expire time in seconds
@property (nonatomic, assign) NSInteger rt; //Retargeting flag
@property (nonatomic, strong) NSDictionary *ska; //ios 14 SKAdNetwork


- (instancetype)initWithCampaignData:(NSDictionary*)cData;

@end

NS_ASSUME_NONNULL_END
