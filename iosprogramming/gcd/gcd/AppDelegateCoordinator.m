//
//  AppDelegateCoordinator.m
//  Le123PhoneClient
//
//  Created by lxw on 2018/10/8.
//  Copyright © 2018年 Ying Shi Da Quan. All rights reserved.
//

#import "AppDelegateCoordinator.h"
#import <YYDispatchQueuePool/YYDispatchQueuePool.h>

@implementation BZXAppQueueManager

static dispatch_group_t _holdGroup;
static dispatch_semaphore_t _semaphore;

#pragma mark - private
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static BZXAppQueueManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[BZXAppQueueManager alloc] init];
        _holdGroup = dispatch_group_create();
        _semaphore = dispatch_semaphore_create(1);
    });
    return manager;
}

- (dispatch_queue_t)addQueueModel:(AppQueueMode)mode {
    switch (mode) {
        case AppQueueModeMainQueue:{
            dispatch_queue_t queue = dispatch_get_main_queue();
            return queue;
        } break;
        case AppQueueModeConcurrent: {
            static dispatch_queue_t queue;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                queue = dispatch_queue_create("sas.queue", DISPATCH_QUEUE_CONCURRENT);
            });
            return queue;
        } break;
        case AppQueueModeSerial:{
            static dispatch_queue_t queue;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                queue = dispatch_queue_create("sas.queue", DISPATCH_QUEUE_SERIAL);
            });
            return queue;
        } break;
        case AppQueueModeYYQueuePool:{
            static dispatch_queue_t queue;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                queue = [[[YYDispatchQueuePool alloc] initWithName:@"sas.queue" queueCount:1 qos:NSQualityOfServiceBackground] queue];
            });
            return queue;
        } break;
        default:{
            static dispatch_queue_t queue;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            });
            return queue;
        }
            break;
    }
}

- (dispatch_queue_t)queueModel:(AppQueueMode)mode {
    dispatch_queue_t queue;
    switch (mode) {
        case AppQueueModeMainQueue:
            queue = dispatch_get_main_queue();
            break;
        case AppQueueModeConcurrent:
            queue = dispatch_queue_create("sas.queue", DISPATCH_QUEUE_CONCURRENT);
            break;
        case AppQueueModeSerial:
            queue = dispatch_queue_create("sas.queue", DISPATCH_QUEUE_SERIAL);
            break;
        case AppQueueModeYYQueuePool:
            queue = [[[YYDispatchQueuePool alloc] initWithName:@"sas.queue" queueCount:1 qos:NSQualityOfServiceBackground] queue];
        default:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            break;
    }
    return queue;
}

- (void)sync:(AppQueueTask)task model:(AppQueueMode)queueMode {
    dispatch_sync([self queueModel:queueMode], task);
}

- (void)async:(AppQueueTask)task model:(AppQueueMode)queueMode {
    dispatch_async([self queueModel:queueMode], task);
}

- (void)addAsync:(AppQueueTask)task model:(AppQueueMode)queueMode {
    dispatch_async([self addQueueModel:queueMode], task);
}

- (void)groupAsync:(AppQueueTask)task mode:(AppQueueMode)asyncQueue notiTask:(AppQueueTask)notiTask mode:(AppQueueMode)notiQueue {
    dispatch_group_async(_holdGroup, [self queueModel:asyncQueue], task);
    dispatch_group_notify(_holdGroup, [self queueModel:notiQueue], notiTask);
}

- (void)groupNotiTask:(AppQueueTask)task mode:(AppQueueMode)notiMode {
    dispatch_group_notify(_holdGroup, [self queueModel:notiMode], task);
}

- (void)groupEnterAsync:(AppQueueTask)task mode:(AppQueueMode)mode {
    dispatch_group_enter(_holdGroup);
    dispatch_async([self queueModel:mode], ^{
        task();
        dispatch_group_leave(_holdGroup);
    });
}


#pragma mark - publick
+ (void)queueAddAsync:(AppQueueTask)task model:(AppQueueMode)queueMode {
    [[[self class] shared] addAsync:task model:queueMode];
}

+ (void)queueAsync:(AppQueueTask)task model:(AppQueueMode)queueMode {
    [[[self class] shared] async:task model:queueMode];
}

+ (void)queueSync:(AppQueueTask)task model:(AppQueueMode)queueMode {
    [[[self class] shared] sync:task model:queueMode];
}
+ (void)groupAsync:(AppQueueTask)task mode:(AppQueueMode)asyncQueue notiTask:(AppQueueTask)notiTask mode:(AppQueueMode)notiQueue {
    [[[self class] shared] groupAsync:task mode:asyncQueue notiTask:notiTask mode:notiQueue];
}

+ (void)groupNotiTask:(AppQueueTask)task mode:(AppQueueMode)notiMode {
    [[[self class] shared] groupNotiTask:task mode:notiMode];
}

+ (void)groupEnterAsync:(AppQueueTask)task mode:(AppQueueMode)mode {
    [[[self class] shared] groupEnterAsync:task mode:mode];
}

+ (void)natomicTask:(AppQueueTask)task {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    task();
    dispatch_semaphore_signal(_semaphore);
}
@end



@implementation BZXAppDelegateCoordinator
- (instancetype)concurrentQueueTask:(AppendBlock)block {
    [BZXAppQueueManager queueAsync:^{
        if (block) {
            block();
        }
    } model:AppQueueModeConcurrent];
    return self;
}

- (instancetype)autoQueuePoolTask:(AppendBlock)block {
    [BZXAppQueueManager queueAsync:^{
        if (block) {
            block();
        }
    } model:AppQueueModeYYQueuePool];
    return self;
}

- (instancetype)mainQueueTask:(AppendBlock)block {
    [BZXAppQueueManager queueAsync:^{
        if (block) {
            block();
        }
    } model:AppQueueModeMainQueue];
    return self;
}

- (instancetype)mainTask:(AppendBlock)block {
    if (block) {
        block();
    }
    return self;
}

- (instancetype)appendTask:(AppendBlock)block mode:(AppQueueMode)mode {
    [BZXAppQueueManager queueAddAsync:^{
        if (block) {
            block();
        }
    } model:mode];
    return self;
}

- (id (^)(AppQueueMode mode))proAsyncBlock {
    return ^(AppQueueMode mode) {
        [BZXAppQueueManager queueAddAsync:^{
            if (_proAsyncBlock) {
                _proAsyncBlock(mode);
            }
        } model:mode];
        return self;
    };
}

@end
