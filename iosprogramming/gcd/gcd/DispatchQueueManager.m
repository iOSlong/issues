//
//  DispatchQueueManager.m
//  gcd
//
//  Created by lxw on 2018/9/26.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "DispatchQueueManager.h"
#import <YYDispatchQueuePool/YYDispatchQueuePool.h>

typedef struct {
    const char *name;
    void **queues;
    uint32_t queueCount;
    int32_t counter;
} DispatchContext;


@implementation DispatchQueueManager {
@public
    DispatchContext *_context;
}


// 也可以使用单列的方式，得到一个唯一使用的group。
static dispatch_group_t _holdGroup;

static dispatch_semaphore_t _semaphore;

- (instancetype)initWithContext:(DispatchContext *)context {
    self = [super init];
    if (!context) return nil;
    self->_context = context;
    return self;
}


+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static DispatchQueueManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[DispatchQueueManager alloc] init];
        _holdGroup = dispatch_group_create();
        _semaphore = dispatch_semaphore_create(1);
    });
    return manager;
}

- (void)dismiss {
    
}

- (dispatch_queue_t)addQueueModel:(DispatchQueueMode)mode {
    switch (mode) {
        case DispatchQueueModeMainQueue:{
            dispatch_queue_t queue = dispatch_get_main_queue();
            return queue;
        } break;
        case DispatchQueueModeConcurrent: {
            static dispatch_queue_t queue;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                queue = dispatch_queue_create("sas.queue", DISPATCH_QUEUE_CONCURRENT);
            });
            return queue;
        } break;
        case DispatchQueueModeSerial:{
            static dispatch_queue_t queue;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                queue = dispatch_queue_create("sas.queue", DISPATCH_QUEUE_SERIAL);
            });
            return queue;
        } break;
        case DispatchQueueModeYYQueuePool:{
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

- (dispatch_queue_t)queueModel:(DispatchQueueMode)mode {
    dispatch_queue_t queue;
    switch (mode) {
            case DispatchQueueModeMainQueue:
            queue = dispatch_get_main_queue();
            break;
        case DispatchQueueModeConcurrent:
            queue = dispatch_queue_create("sas.queue", DISPATCH_QUEUE_CONCURRENT);
            break;
        case DispatchQueueModeSerial:
            queue = dispatch_queue_create("sas.queue", DISPATCH_QUEUE_SERIAL);
            break;
        case DispatchQueueModeYYQueuePool:
            queue = [[[YYDispatchQueuePool alloc] initWithName:@"sas.queue" queueCount:1 qos:NSQualityOfServiceBackground] queue];
        default:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            break;
    }
    return queue;
}

- (void)addAsync:(DispatchTask)task model:(DispatchQueueMode)queueMode {
    dispatch_async([self addQueueModel:queueMode], task);
}

- (void)async:(DispatchTask)task model:(DispatchQueueMode)queueMode {
    dispatch_async([self queueModel:queueMode], task);
}

- (void)sync:(DispatchTask)task model:(DispatchQueueMode)queueMode {
    dispatch_sync([self queueModel:queueMode], task);
}

- (void)dispatch:(DispatchTask)task after:(int64_t)delayInSeconds model:(DispatchQueueMode)queueMode {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), [self queueModel:queueMode], task);
}

- (void)groupAsync:(DispatchTask)task mode:(DispatchQueueMode)asyncQueue notiTask:(DispatchTask)notiTask mode:(DispatchQueueMode)notiQueue {
    dispatch_group_async(_holdGroup, [self queueModel:asyncQueue], task);
    dispatch_group_notify(_holdGroup, [self queueModel:notiQueue], notiTask);
}

- (void)groupNotiTask:(DispatchTask)task mode:(DispatchQueueMode)notiMode {
    dispatch_group_notify(_holdGroup, [self queueModel:notiMode], task);
}

- (void)groupEnterAsync:(DispatchTask)task mode:(DispatchQueueMode)mode {
    dispatch_group_enter(_holdGroup);
    dispatch_async([self queueModel:mode], ^{
        task();
        dispatch_group_leave(_holdGroup);
    });
}

- (void)natomicTask:(DispatchTask)task {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    task();
    dispatch_semaphore_signal(_semaphore);
}








@end
