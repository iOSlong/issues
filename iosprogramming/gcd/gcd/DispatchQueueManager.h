//
//  DispatchQueueManager.h
//  gcd
//
//  Created by lxw on 2018/9/26.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef dispatch_block_t DispatchTask;

typedef NS_ENUM(NSUInteger, DispatchQueueMode) {
    DispatchQueueModeMainQueue      = 1,
    DispatchQueueModeDefault        = 2,
    DispatchQueueModeSerial         = 3,
    DispatchQueueModeConcurrent     = 4,
    DispatchQueueModeYYQueuePool    = 5
};

@interface DispatchQueueManager : NSObject

//- (instancetype)init UNAVAILABLE_ATTRIBUTE;
//+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

//TODO: 先定义使用API ，如果其中需要序列线程池，可以用YYDispatchQueuePool。
+ (instancetype)shared;
- (void)addAsync:(DispatchTask)task model:(DispatchQueueMode)queueMode;
- (void)async:(DispatchTask)task model:(DispatchQueueMode)queueMode;
- (void)sync:(DispatchTask)task model:(DispatchQueueMode)queueMode;
- (void)dispatch:(DispatchTask)task after:(int64_t)delayInSeconds model:(DispatchQueueMode)queueMode;
- (void)groupAsync:(DispatchTask)task mode:(DispatchQueueMode)asyncQueue notiTask:(DispatchTask)task mode:(DispatchQueueMode)notiQueue;
- (void)groupNotiTask:(DispatchTask)task mode:(DispatchQueueMode)notiMode;
- (void)groupEnterAsync:(DispatchTask)task mode:(DispatchQueueMode)mode;
- (void)natomicTask:(DispatchTask)task;

//@property (nonatomic, copy) DispatchQueueManager *(^ sas)(CGFloat num);


@end
