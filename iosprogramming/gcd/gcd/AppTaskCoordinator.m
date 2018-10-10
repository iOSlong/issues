//
//  AppTaskCoordinator.m
//  gcd
//
//  Created by lxw on 2018/10/9.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AppTaskCoordinator.h"

@implementation AppTaskCoordinator {
    AppTaskCoordinator *(^_proBlock)(int index,DispatchQueueMode mode);
}
- (instancetype)concurrentQueueTask:(AppendBlock)block {
    [[DispatchQueueManager shared] async:^{
        if (block) {
            block();
        }
    } model:DispatchQueueModeConcurrent];
    return self;
}

- (instancetype)autoQueuePoolTask:(AppendBlock)block {
    [[DispatchQueueManager shared] async:^{
        if (block) {
            block();
        }
    } model:DispatchQueueModeYYQueuePool];
    return self;
}

- (instancetype)mainQueueTask:(AppendBlock)block {
    [[DispatchQueueManager shared] async:^{
        if (block) {
            block();
        }
    } model:DispatchQueueModeMainQueue];
    return self;
}

- (instancetype)mainTask:(AppendBlock)block {
    if (block) {
        block();
    }
    return self;
}

- (instancetype)appendTask:(AppendBlock)block mode:(DispatchQueueMode)mode {
    [[DispatchQueueManager shared] addAsync:^{
        if (block) {
            block();
        }
    } model:mode];
    return self;
}

- (AppTaskCoordinator * (^)(int index,DispatchQueueMode mode))proBlock {
    return ^(int index,DispatchQueueMode mode) {
        [[DispatchQueueManager shared] async:^{
            if (self->_proBlock) {
                self->_proBlock(index,mode);
            }
        } model:mode];
        NSLog(@"task %d:  thread:---%@", index, [NSThread currentThread]);
        return self;
    };
}
- (void)setProBlock:(AppTaskCoordinator *(^)(int, DispatchQueueMode))proBlock {
    _proBlock = proBlock;
}
@end
