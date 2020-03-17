// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface OMScene : NSObject

@property(nonatomic, copy)NSString *unitID;
@property(nonatomic, copy)NSString *sceneID;
@property(nonatomic, copy)NSString *sceneName;
@property(nonatomic, assign)BOOL defaultScene;
@property(nonatomic, assign)NSInteger frequencryCap;
@property(nonatomic, assign)NSInteger frequencryUnit;

- (instancetype)initWithUnitID:(NSString *)unitID sceneData:(NSDictionary *)sceneData;

@end

NS_ASSUME_NONNULL_END
