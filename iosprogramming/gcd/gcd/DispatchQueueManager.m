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
    });
    return manager;
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

- (void)group:(DispatchTask)task model:(DispatchQueueMode)queueMode {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, [self queueModel:queueMode], task);
}







@end
