//
//  LXOperation.m
//  gcd
//
//  Created by lxw on 2020/4/30.
//  Copyright © 2020 lxw. All rights reserved.
//

#import "LXOperation.h"
#import "DispatchQueueManager.h"

@implementation LXOperation

@end


@interface NonConcurrentOperation ()
@property (nonatomic, copy) dispatch_block_t opBlock;
@end

@implementation NonConcurrentOperation
- (instancetype)initWithData:(id)data {
    self = [super init];
    if (self) {
        _myData = data;
    }
    return self;
}
- (instancetype)initWithBlock:(void (^)(void))block {
    self = [super init];
       if (self) {
           _opBlock = block;
       }
       return self;
}
- (void)main {
    @try {
        __block BOOL isDone = NO;
        while (![self isCancelled] && !isDone) {
            if (_opBlock) {
                _opBlock();
                isDone = YES;
            }else{
                for (int i = 0; i < 20; i ++) {
                    sleep(1);
                    NSLog(@"%@| %@_%d",[NSThread currentThread],self->_myData,i);
                }
                isDone = YES;
            }
        }
    } @catch (NSException *exception) {

    }
}
@end


@interface ConcurrentOperation ()
@property (nonatomic, strong) id album;
@property (nonatomic, strong) NSMutableArray *photoTasks;
@end
@implementation ConcurrentOperation
- (instancetype)initWithAlbum:(id)album {
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
        _album = album;
        _photoTasks = [NSMutableArray array];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
    }
    return self;
}
- (BOOL)isConcurrent {
    return YES;
}
- (BOOL)isExecuting {
    return executing;
}
- (BOOL)isFinished {
    return finished;
}
- (void)start {
    // Always check for cancellation before launching the task.
    if ([self isCancelled]) {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
   @try {
       // Do the main work of the operation here.
       if (![self isCancelled]) {
           
           
           [self mainOperationWithApply];
           
//           for (int i = 0; i < 20; i ++) {
//               // user cancelled this operation
//               if ([self isCancelled]) {
//                   break;
//               }
//               NSLog(@"%@| %@:%d",[NSThread currentThread],_album,i);
//               [_photoTasks addObject:[NSString stringWithFormat:@"%@| %@:%d",[NSThread currentThread],_album,i]];
//               sleep(1);
//           }
       }
       [self completeOperation];
   }
   @catch(...) {
      // Do not rethrow exceptions.
   }
}

- (void)mainOperationWithApply {
    NSInteger count = 30;
    int stride = 5;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(count / stride, queue, ^(size_t idx){
        size_t j = idx * stride;
        size_t j_stop = j + stride;
        do {
            if ([self isCancelled])  break;
            NSLog(@"%@| block %zu",[NSThread currentThread],j++);
            [_photoTasks addObject:[NSString stringWithFormat:@"%@| %@:%zu",[NSThread currentThread],_album,j]];
            sleep(1);
        }while (j < j_stop);
    });
    
    size_t i;
    for (i = count - (count % stride); i < count; i++){
        if ([self isCancelled])  break;
        NSLog(@"%@| %@:%zu",[NSThread currentThread],_album,i);
        [_photoTasks addObject:[NSString stringWithFormat:@"%@| %@:%zu",[NSThread currentThread],_album,i]];
        sleep(1);
    }
}



- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    NSLog(@"");
    if ([self.delegate respondsToSelector:@selector(albumAnalyzeDidCompletionOperation:)]) {
        [self.delegate albumAnalyzeDidCompletionOperation:self];
    }
}

@end
