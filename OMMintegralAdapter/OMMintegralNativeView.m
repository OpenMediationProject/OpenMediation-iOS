// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralNativeView.h"
#import "OMMintegralNative.h"

@implementation OMMintegralNativeView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setMediaViewWithFrame:(CGRect)frame {
    Class mtgViewClass = NSClassFromString(@"MTGMediaView");
    if (mtgViewClass) {
        _mediaView = [[mtgViewClass alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
}

-(void)setNativeAd:(OMMintegralNativeAd *)nativeAd {
    _nativeAd = nativeAd;
    MTGCampaign *campaign = nativeAd.adObject;
    if (nativeAd.mtgManager) {
        MTGNativeAdManager *manager = nativeAd.mtgManager;
        [manager setVideoViewSize:_mediaView.frame.size];
        _mediaView.delegate = (id<MTGMediaViewDelegate>)manager.delegate;
        [_mediaView setMediaSourceWithCampaign:campaign unitId:manager.currentUnitId];
        [self initMTGManager:manager withCampaign:campaign];
    }else if (nativeAd.mtgBidManager){
        MTGBidNativeAdManager *manager = nativeAd.mtgBidManager;
        [manager setVideoViewSize:_mediaView.frame.size];
        _mediaView.delegate = (id<MTGMediaViewDelegate>)manager.delegate;
        [_mediaView setMediaSourceWithCampaign:campaign unitId:manager.currentUnitId];
        [self initMTGManager:manager withCampaign:campaign];
    }
}

- (void)initMTGManager:(id)manager withCampaign:(MTGCampaign*)campaign {
    if (campaign.imageUrl && [campaign.imageUrl length]>0) {
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:_mediaView.bounds];
        NSURL *imageURL = [NSURL URLWithString:campaign.imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                bgView.image = [UIImage imageWithData:imageData];
            });
        });
        [_mediaView insertSubview:bgView atIndex:0];
    }
    [_adChoicesView removeFromSuperview];
    Class mtgAdChoiceClass = NSClassFromString(@"MTGAdChoicesView");
    CGSize adChoiceIconSize = campaign.adChoiceIconSize;
    if(mtgAdChoiceClass && adChoiceIconSize.width>0 && adChoiceIconSize.height>0) {
        _adChoicesView = [[mtgAdChoiceClass alloc]initWithFrame:CGRectMake(self.frame.size.width-adChoiceIconSize.width-3, 3, adChoiceIconSize.width, adChoiceIconSize.height)];
        _adChoicesView.campaign = campaign;
        [self addSubview:_adChoicesView];
    }
    if (manager && [manager respondsToSelector:@selector(registerViewForInteraction:withCampaign:)]) {
        [manager registerViewForInteraction:self withCampaign:campaign];
    }
}

@end
