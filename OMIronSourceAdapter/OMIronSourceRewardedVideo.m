// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceRewardedVideo.h"

@implementation OMIronSourceRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter
{
    if (self = [super init]) {
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]){
            _pid = [adParameter objectForKey:@"pid"];
            _appID = @"";
            [[OMIronSourceRouter sharedInstance] registerPidDelegate:_pid delegate:self];
        }
    }
    return self;
}

-(void)loadAd
{
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(loadISDemandOnlyRewardedVideo:)]){
        [IronSourceClass loadISDemandOnlyRewardedVideo:_pid];
    }
}

-(BOOL)isReady
{
    BOOL isReady = NO;
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if(IronSourceClass && [IronSourceClass respondsToSelector:@selector(hasISDemandOnlyRewardedVideo:)]){
        isReady = [IronSourceClass hasISDemandOnlyRewardedVideo:_pid];
    }
    return isReady;
}

- (void)show:(UIViewController *)vc
{
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if ([self isReady] && IronSourceClass && [IronSourceClass respondsToSelector:@selector(showISDemandOnlyRewardedVideo:instanceId:)]) {
        [IronSourceClass showISDemandOnlyRewardedVideo:vc instanceId:_pid];
    }
}


- (void)OMIronSourceDidload {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)OMIronSourceDidFailToLoad:(nonnull NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
        NSError *cerror = [[NSError alloc] initWithDomain:@"" code:error.code userInfo:@{@"msg":@"There are no ads to show now"}];
        [_delegate customEvent:self didFailToLoadWithError:cerror];
    }
}

- (void)OMIronSourceDidStart {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]){
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]){
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)OMIronSourceDidClick{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]){
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)OMIronSourceVideoEnd {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]){
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)OMIronSourceDidReceiveReward {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]){
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)OMIronSourceDidFinish {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]){
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)OMIronSourceDidFailToShow:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]){
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}

@end
