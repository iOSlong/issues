//
//  AppTaskCoordinator.h
//  gcd
//
//  Created by lxw on 2018/10/9.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DispatchQueueManager.h"

typedef void(^AppendBlock)(void);


@interface AppTaskCoordinator : NSObject
@property (nonatomic, copy) AppTaskCoordinator *(^proBlock)(int index, DispatchQueueMode mode);

- (instancetype)concurrentQueueTask:(AppendBlock)block;
- (instancetype)autoQueuePoolTask:(AppendBlock)block;
- (instancetype)mainQueueTask:(AppendBlock)block;
- (instancetype)mainTask:(AppendBlock)block;
- (instancetype)appendTask:(AppendBlock)block mode:(DispatchQueueMode)mode;

@end
