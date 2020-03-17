// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMacros_h
#define OMMacros_h

#import <UIKit/UIKit.h>
#import <pthread.h>

#define OM_IS_NULL(obj)             (obj == nil || obj == (id)[NSNull null])
#define OM_IS_NOT_NULL(obj)         (obj != nil && obj != (id)[NSNull null])
#define OM_STR_EMPTY(obj)           ((OM_IS_NULL(obj)) || (![obj isKindOfClass:[NSString class]]) || [obj length] == 0 )
#define OM_DATA_EMPTY(obj)          ((OM_IS_NULL(obj)) || (![obj isKindOfClass:[NSData class]]) || [obj length] == 0 )
#define OM_SAFE_STRING(obj)         ((OM_IS_NOT_NULL(obj))?obj:@"")


#define OM_CLOSE_ICON_WIDTH         (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height)?([UIScreen mainScreen].bounds.size.width/320.0*16.0):([UIScreen mainScreen].bounds.size.height/320*16.0))

static inline void dispatch_sync_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

#endif /* OMMacros_h */
