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

@interface OperationFuncViewController ()

@end

@implementation OperationFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self invocationOperation];
    
//    [self blockOperation];
    
    [self nonConcurrentOperation];
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
        //    NonConcurrentOperation *operation = [[NonConcurrentOperation alloc] initWithData:@"NonConcurrent"];
    NonConcurrentOperation *operation = [[NonConcurrentOperation alloc] initWithBlock:^{
        for (int i = 0; i < 10; i ++) {
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
}


@end
