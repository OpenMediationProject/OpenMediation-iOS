// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionCampaignModel.h"
#import "OMToolUmbrella.h"

@implementation OMCrossPromotionCampaignModel

- (instancetype)initWithCampaignData:(NSDictionary*)cData {
    if (self = [super init]) {
        if(cData) {
            _cid = OM_SAFE_STRING(cData[@"cid"]);
            _crid = OM_SAFE_STRING(cData[@"crid"]);
            _title = OM_SAFE_STRING(cData[@"title"]);
            _adFormat = (1<<[[cData objectForKey:@"adtype"]integerValue]);
            _link = OM_SAFE_STRING(cData[@"link"]);
            _iswv = [cData[@"iswv"]boolValue];
            _descn = OM_SAFE_STRING(cData[@"descn"]);
            _ps = OM_SAFE_STRING(cData[@"ps"]);
            _expire = [cData[@"expire"]integerValue];
            _rt = [cData[@"rt"]integerValue];
            
            _imgs = [NSArray array];
            if (cData[@"imgs"] && [cData[@"imgs"] isKindOfClass:[NSArray class]]) {
                _imgs = cData[@"imgs"];
            }
            
            _video = [NSDictionary dictionary];
            if (cData[@"video"] && [cData[@"video"] isKindOfClass:[NSDictionary class]]) {
                _video = cData[@"video"];
            }
            
            _clktks = [NSArray array];
            if (cData[@"clktks"] && [cData[@"clktks"] isKindOfClass:[NSArray class]]) {
                _clktks = cData[@"clktks"];
            }
            
            _imptks = [NSArray array];
            if (cData[@"imptks"] && [cData[@"imptks"] isKindOfClass:[NSArray class]]) {
                _imptks = cData[@"imptks"];
            }
            
            _app = [NSDictionary dictionary];
            if (cData[@"app"] && [cData[@"app"] isKindOfClass:[NSDictionary class]]) {
                _app = cData[@"app"];
            }
            
            _resources = [NSArray array];
            if(cData[@"resources"] && [cData[@"resources"] isKindOfClass:[NSArray class]]) {
                _resources = cData[@"resources"];
            }
            
            _adMark = [NSDictionary dictionary];
            if (cData[@"mk"] && [cData[@"mk"] isKindOfClass:[NSDictionary class]]) {
                _adMark = cData[@"mk"];
            }
                        
            _ska = cData[@"ska"];
            if (_ska && [_ska objectForKey:@"adNetworkNonce"]) {
                NSMutableDictionary * ska = [NSMutableDictionary dictionaryWithDictionary:_ska];
                [ska setObject:[[NSUUID alloc] initWithUUIDString:[_ska objectForKey:@"adNetworkNonce"]] forKey:@"adNetworkNonce"];
                _ska = [ska copy];
            }
            _originData = cData;
        }
    }
    return self;
}

@end
