//
//  OperationFuncViewController.m
//  gcd
//
//  Created by lxw on 2020/4/30.
//  Copyright © 2020 lxw. All rights reserved.
//

/*
 link:https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationObjects/OperationObjects.html#//apple_ref/doc/uid/TP40008091-CH101-SW8
 */

#import "OperationFuncViewController.h"
#import "DispatchQueueManager.h"
#import "LXOperation.h"

@interface OperationFuncViewController ()<LXOperationDelegate>
@property (nonatomic, strong) UIButton *btnStart;
@property (nonatomic, strong) UIButton *btnCanceled;
@property (nonatomic, strong) UIButton *btnResume;
@property (nonatomic, strong) UIButton *btnSuspend;
@property (nonatomic, strong) LXOperation *operation;
@property (nonatomic, copy) dispatch_queue_t queueAnalysis;
@property (nonatomic, assign) BOOL isSuspended;
@property (nonatomic, assign) BOOL analysisComplete;
@property (nonatomic, strong) NSOperationQueue *OPQueue;
@end

@implementation OperationFuncViewController
- (dispatch_queue_t)queueAnalysis {
    if (!_queueAnalysis) {
        const char *queueName = [[NSString stringWithFormat:@"zspace.album.%@", @"thisOne"] UTF8String];
        _queueAnalysis = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
    }
    return _queueAnalysis;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnStart = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btnStart setTitle:@"start" forState:UIControlStateNormal];
    [_btnStart addTarget:self action:@selector(operationStart:) forControlEvents:UIControlEventTouchUpInside];
    [_btnStart setFrame:CGRectMake(10, 100, 80, 30)];
    [_btnStart.layer setBorderColor:[UIColor redColor].CGColor];
    [self.view addSubview:_btnStart];
    
    _btnCanceled = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btnCanceled setTitle:@"cancel" forState:UIControlStateNormal];
    [_btnCanceled addTarget:self action:@selector(operationCanceled:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCanceled setFrame:CGRectMake(100, 100, 80, 30)];
    [_btnCanceled.layer setBorderColor:[UIColor orangeColor].CGColor];
    [self.view addSubview:_btnCanceled];
    
    
    _btnResume = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btnResume setTitle:@"resume" forState:UIControlStateNormal];
    [_btnResume addTarget:self action:@selector(resumePhotoTasksAnalysis) forControlEvents:UIControlEventTouchUpInside];
    [_btnResume setFrame:CGRectMake(10, 200, 80, 30)];
    [_btnResume.layer setBorderColor:[UIColor redColor].CGColor];
    [self.view addSubview:_btnResume];
    
    _btnSuspend = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btnSuspend setTitle:@"suspend" forState:UIControlStateNormal];
    [_btnSuspend addTarget:self action:@selector(suspendPhotoTasksAnalysis) forControlEvents:UIControlEventTouchUpInside];
    [_btnSuspend setFrame:CGRectMake(100, 200, 80, 30)];
    [_btnSuspend.layer setBorderColor:[UIColor orangeColor].CGColor];
    [self.view addSubview:_btnSuspend];

    
    
    // Do any additional setup after loading the view.
//    [self invocationOperation];
    
//    [self blockOperation];
    
//    [self nonConcurrentOperation];
    
//    [self cancelOperationTest];
    
//    [self blockCancelTest];
    
//    [self dispatchQueueloopCodeTest];
    
//    [self operationQueue];
    
    [self conOperationQueue];

    dispatch_queue_attr_t attr = DISPATCH_QUEUE_CONCURRENT;
    dispatch_queue_attr_t attr2 = DISPATCH_QUEUE_SERIAL;
    dispatch_queue_attr_t attr3 = DISPATCH_QUEUE_CONCURRENT;
    NSLog(@"%@",attr);
    NSLog(@"%@",attr2);
    NSLog(@"%@",attr3);
    NSLog(@"%@",NSStringFromClass(attr.class));
    NSLog(@"%@",NSStringFromClass(attr2.class));
    NSLog(@"%@",NSStringFromClass(attr3.class));
    if (attr2 == DISPATCH_QUEUE_SERIAL) {
        NSLog(@"serial");
    }
    if (attr == DISPATCH_QUEUE_CONCURRENT) {
        NSLog(@"concurrent");
    }
    if (attr == DISPATCH_QUEUE_SERIAL) {
        NSLog(@"serial");
    }
    if (attr2 == DISPATCH_QUEUE_CONCURRENT) {
        NSLog(@"concurrent");
    }
    NSLog(@"");

}

- (void)operationCanceled:(UIButton *)btn {
//    [self.operation cancel];
    if (!self.operation.isCancelled) {
        [self.operation cancel];
        NSLog(@"self.OPQueue.operationCount = %ld",self.OPQueue.operationCount);
        return;
    }
    [self.OPQueue cancelAllOperations];
    NSLog(@"self.OPQueue.operationCount = %ld",self.OPQueue.operationCount);
    NSLog(@"");
}

- (void)operationStart:(UIButton *)btn {
//    [self.operation start];
//    [[DispatchQueueManager shared] async:^{
//        [self.operation start];
//        NSLog(@"");
//    } model:DispatchQueueModeSerial];

    NSLog(@"");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"self.OPQueue.operationCount = %ld",self.OPQueue.operationCount);
    NSLog(@"");
}
- (BOOL)suspendPhotoTasksAnalysis {
    if (!self.analysisComplete && self.isSuspended == NO) {
        dispatch_suspend(self.queueAnalysis);
        self.isSuspended = YES;
        return YES;
    }
    return NO;
}

- (BOOL)resumePhotoTasksAnalysis {
    if (!self.analysisComplete && self.isSuspended == YES) {
        dispatch_resume(self.queueAnalysis);
        self.isSuspended = NO;
        return YES;
    }
    return NO;
}

#pragma mark LXOperationDelegate
- (void)albumAnalyzeDidCompletionOperation:(LXOperation *)operation {
    NSLog(@"self.OPQueue.operationCount = %ld",self.OPQueue.operationCount);
    for (LXOperation *op  in self.OPQueue.operations) {
        if (op == operation) {
            NSLog(@"queue i n %@",operation);
        }
    }
}

- (void)operationWithObject:(id)object {
    NSLog(@"%@, | obj=%@", [NSThread currentThread],object);
}

#pragma mark -NSInvocationOperation
- (void)invocationOperation {
    NSInvocationOperation *invocationOP = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationWithObject:) object:@"something"];
    
    
    NSInvocation *invocation = [NSInvocation new];
    [invocation performSelector:@selector(operationWithObject:) withObject:@"invocation2"];
    NSInvocationOperation *invocationOP2 = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    [invocationOP2 start];

    [[DispatchQueueManager shared] async:^{
        [invocationOP start];
    } model:DispatchQueueModeSerial];
}

#pragma mark -NSBlockOperation
- (void)blockOperation {
    NSBlockOperation *blockOP = [NSBlockOperation blockOperationWithBlock:^{
        [self operationWithObject:@"blockOP"];
    }];
    [blockOP addExecutionBlock:^{
        [self operationWithObject:@"add blockOP"];
    }];
    [[DispatchQueueManager shared] async:^{
        [blockOP addExecutionBlock:^{
            [self operationWithObject:@"add blockOP mainQueue"];
        }];
        [blockOP start];
    } model:DispatchQueueModeMainQueue];

}

- (void)nonConcurrentOperation{
//            NonConcurrentOperation *operation = [[NonConcurrentOperation alloc] initWithData:@"NonConcurrent"];
    NonConcurrentOperation *operation = [[NonConcurrentOperation alloc] initWithBlock:^{
        for (int i = 0; i < 30; i ++) {
            NSLog(@"%@| %d",[NSThread currentThread],i);
            sleep(2);
        }
    }];
    operation.completionBlock = ^{
        NSLog(@"completionBlock");
    };
    [[DispatchQueueManager shared] async:^{
        [operation start];
    } model:DispatchQueueModeSerial];
    self.operation = operation;
}

- (void)cancelOperationTest {
    NonConcurrentOperation *operation = [[NonConcurrentOperation alloc] initWithBlock:^{
        for (int i = 0; i < 30; i ++) {
            NSLog(@"%@| %d",[NSThread currentThread],i);
            sleep(2);
        }
    }];
    operation.completionBlock = ^{
        NSLog(@"completionBlock");
    };
    self.operation = operation;
}


- (void)blockCancelTest {
    dispatch_async(self.queueAnalysis, ^{
        for (int i = 0; i < 30; i ++) {
            NSLog(@"%@| %d",[NSThread currentThread],i);
            sleep(2);
        }
        self.analysisComplete = YES;
        NSLog(@"completionBlock");
    });
    
    char *context =  dispatch_get_context(self.queueAnalysis);
    NSLog(@"%s",context);

}

- (void)dispatchQueueloopCodeTest {
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t queue2 = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);
//    NSInteger count = 20;
//    dispatch_async(queue1, ^{
//        dispatch_apply(count, queue2, ^(size_t i) {
//            NSLog(@"%@| %zu",[NSThread currentThread],i);
//            sleep(2);
//        });
//    });
    
    
    NSInteger count = 20;
    int stride = 6;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     
    dispatch_async(queue1, ^{
        dispatch_apply(count / stride, queue, ^(size_t idx){
            size_t j = idx * stride;
            size_t j_stop = j + stride;
            do {
                sleep(1);
                NSLog(@"%@| %zu",[NSThread currentThread],j++);
            }while (j < j_stop);
        });
         
        size_t i;
        for (i = count - (count % stride); i < count; i++){
            sleep(1);
            NSLog(@"-------%@| %zu",[NSThread currentThread],i);
        }
    });

}


- (void)operationQueue {
    NonConcurrentOperation *operation = [[NonConcurrentOperation alloc] initWithBlock:^{
            //        for (int i = 0; i < 10; i ++) {
            //            NSLog(@"%@| block %d",[NSThread currentThread],i);
            //            sleep(1);
            //        }
        NSInteger count = 30;
        int stride = 5;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_apply(count / stride, queue, ^(size_t idx){
            size_t j = idx * stride;
            size_t j_stop = j + stride;
            do {
                sleep(1);
                NSLog(@"%@| block %zu",[NSThread currentThread],j++);
            }while (j < j_stop);
        });
        
        size_t i;
        for (i = count - (count % stride); i < count; i++){
            sleep(1);
            NSLog(@"-------%@| %zu",[NSThread currentThread],i);
        }
        
    }];
    operation.completionBlock = ^{
        NSLog(@"operation completionBlock");
    };

    NonConcurrentOperation *operation2 = [[NonConcurrentOperation alloc] initWithData:@"NonConcurrent"];
    operation2.completionBlock = ^{
        NSLog(@"operation2 completionBlock");
    };
    
    
    NonConcurrentOperation *operation3 = [[NonConcurrentOperation alloc] initWithBlock:^{
        for (int i = 0; i < 10; i ++) {
            NSLog(@"%@| block3 %d",[NSThread currentThread],i);
            sleep(1);
        }
    }];
    operation3.completionBlock = ^{
        NSLog(@"operation3 completionBlock");
    };

    NonConcurrentOperation *operation4 = [[NonConcurrentOperation alloc] initWithBlock:^{
          for (int i = 0; i < 10; i ++) {
              NSLog(@"%@| block4 %d",[NSThread currentThread],i);
              sleep(1);
          }
      }];
      operation4.completionBlock = ^{
          NSLog(@"operation4 completionBlock");
      };
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    [queue addOperation:operation];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
    self.OPQueue = queue;
}

- (void)conOperationQueue{
    ConcurrentOperation *conOperation1 = [[ConcurrentOperation alloc] initWithAlbum:@"Main"];
    __weak __typeof(conOperation1)weakOP1 = conOperation1;
    [conOperation1 setCompletionBlock:^{
        __strong __typeof(weakOP1)strongOP = weakOP1;
        NSLog(@"=============conOperation1 completionBlock");
        NSLog(@"photoTasks: %@",strongOP.photoTasks);
    }];
    
    ConcurrentOperation *conOperation2 = [[ConcurrentOperation alloc] initWithAlbum:@"ZSpace"];
    __weak __typeof(conOperation2)weakOP2 = conOperation2;
    [conOperation2 setCompletionBlock:^{
        __strong __typeof(weakOP2)strongOP = weakOP2;
        NSLog(@"conOperation2 completionBlock");
        NSLog(@"photoTasks: %@",strongOP.photoTasks);
    }];

    ConcurrentOperation *conOperation3 = [[ConcurrentOperation alloc] initWithAlbum:@"More"];
    __weak __typeof(conOperation3)weakOP3 = conOperation3;
    [conOperation3 setCompletionBlock:^{
        __strong __typeof(weakOP3)strongOP = weakOP3;
        NSLog(@"conOperation3 completionBlock");
        NSLog(@"photoTasks: %@",strongOP.photoTasks);
    }];

    NSMutableArray *conOArr = [NSMutableArray array];
    for (int i = 0; i < 100 ; i ++) {
        ConcurrentOperation *conOp = [[ConcurrentOperation alloc] initWithAlbum:[NSString stringWithFormat:@"con%d",i]];
        if (i%5 == 0) {
            conOp.queuePriority = NSOperationQueuePriorityVeryHigh;
        }else if (i % 11 == 0){
            conOp.queuePriority = NSOperationQueuePriorityHigh;
        }else if (i % 7 == 0) {
            conOp.queuePriority = NSOperationQueuePriorityNormal;
        }else if (i % 3 == 0) {
            conOp.queuePriority = NSOperationQueuePriorityLow;
        }else if (i % 4 == 0) {
            conOp.queuePriority = NSOperationQueuePriorityVeryLow;
        }
        __weak __typeof(conOp)weakOP = conOp;
        [conOp setCompletionBlock:^{
            __strong __typeof(weakOP)strongOP = weakOP;
            NSLog(@"conOp completionBlock");
            NSLog(@"photoTasks: %@",strongOP.photoTasks);
        }];
        conOp.delegate = self;
        [conOArr addObject:conOp];
    }
    conOperation1.delegate  = self;
    conOperation2.delegate  =self;
    conOperation3.delegate  =self;

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 4;
    [queue addOperation:conOperation1];
    [queue addOperation:conOperation2];
    [queue addOperation:conOperation3];
    [queue addOperations:conOArr waitUntilFinished:NO];
    self.OPQueue = queue;
    self.operation = conOperation1;
    NSLog(@"self.OPQueue.operationCount = %ld",self.OPQueue.operationCount);

//    __weak __typeof(self)weakSelf = self;
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {    __strong __typeof(weakSelf)strongSelf = weakSelf;
//        NSLog(@"%ld",strongSelf.OPQueue.operationCount);
//        NSLog(@"%@",strongSelf.OPQueue.operations);
//    }];
}
@end
