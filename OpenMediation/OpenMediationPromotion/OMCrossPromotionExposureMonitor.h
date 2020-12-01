// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionExposureMonitor : NSObject
@property (nonatomic, strong) NSMapTable *monitoredViewMap;//key observer ,value view
+ (instancetype)sharedInstance;
- (void)addObserver:(NSObject*)observer forView:(UIView*)view;
- (void)removeObserver:(NSObject*)observer;
@end

NS_ASSUME_NONNULL_END
