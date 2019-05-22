//
//  FuncViewController.m
//  gcd
//
//  Created by lxw on 2018/9/25.
//  Copyright © 2018年 lxw. All rights reserved.
//
// 参考文档： https://juejin.im/post/5a90de68f265da4e9b592b40

#import "DispatchFuncViewController.h"
#import "DispatchQueueManager.h"
#import "AppTaskCoordinator.h"

#define Dispatch_native 0

@interface DispatchFuncViewController ()
@property (nonatomic, assign) NSInteger ticketSurplusCount;
@property (nonatomic, strong) dispatch_semaphore_t semaphoreLock;
@property (nonatomic, strong) AppTaskCoordinator *taskCoordinator;
@end

@implementation DispatchFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIActivityIndicatorView *actIV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actIV.backgroundColor = [UIColor redColor];
    actIV.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:actIV];
    [actIV startAnimating];
    
    int context = 10;
    dispatch_async_f(dispatch_get_global_queue(0, 0), &context, test);
    
}
void test(void*context)
{
    int *c = context;
    NSLog(@"%d", *c);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    switch (self.type) {
        case GCDFuncSYNC_CONCURRENT:
            [self dispatch_sync_concurrent];
            break;
        case GCDFuncASYNC_CONCURRENT:
            [self dispatch_async_concurrent];
            break;
        case GCDFuncSYNC_SERIAL:
            [self dispatch_sync_serial];
            break;
        case GCDFuncASYNC_SERIAL:
            [self dispatch_async_serial];
            break;
        case GCDFuncSYNC_MAIN_QUEUE:
#if 0
            [self dispatch_sync_main];
#else
            [NSThread detachNewThreadSelector:@selector(dispatch_sync_main) toTarget:self withObject:nil];
#endif
            
            /*
             #if 1:
             Xcode9奔溃信息。 Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
             在主线程中使用同步执行 + 主队列，追加到主线程的任务1、任务2、任务3都不再执行了，而且syncMain---end也没有打印，在XCode 9上还会报崩溃。这是为什么呢？
             
             这是因为我们在主线程中执行syncMain方法，相当于把syncMain任务放到了主线程的队列中。而同步执行会等待当前队列中的任务执行完毕，才会接着执行。那么当我们把任务1追加到主队列中，任务1就在等待主线程处理完syncMain任务。而syncMain任务需要等待任务1执行完毕，才能接着执行。
             那么，现在的情况就是syncMain任务和任务1都在等对方执行完毕。这样大家互相等待，所以就卡住了，所以我们的任务执行不了，而且syncMain---end也没有打印。
             */
            break;
        case GCDFuncASYNC_MAIN_QUEUE:
            [self dispatch_async_main];
            break;
            
        case GCDFuncCommunication:
            [self dispatch_communication];
            break;
        case GCDFunc_BARRIER_ASYNC:
            [self dispatch_barrier_async];
            break;
        case GCDFunc_AFTER:
            [self dispatch_after];
            break;
        case GCDFunc_ONCE:
            [self dispatch_oncefunc];
            break;
        case GCDFunc_APPLY:
            [self dispatch_apply];
            break;
            
        case GCDFunc_GROUP_NOTIFY:
            [self dispatch_group_notify];
            break;
        case GCDFunc_GROUP_WAIT:
            [self dispatch_group_wait];
            break;
        case GCDFunc_GROUP_ENTER_LEAVE:
            [self dispatch_enter_leave];
            break;
            
        case GCDFunc_SEMAPHORE_SYNC:
            [self dispatch_semaphore_sync];
            break;
        case GCDFunc_SEMAPHORE_THREAD_SAFE:
            [self dispatch_semaphore_thread_safe];
            break;
        case GCDFunc_CANCEL_BLOCK:
            [self dispatch_cancel_block];
            break;
            case GCDFunc_APP_TASK_SINGLE:
            [self appTaskcoordinator_single];
            break;
            case GCDFunc_APP_TASK_COMBIN:
            [self appTaskcoordinator_combine];
            break;
        default:
            break;
    }
}

#pragma mark - APPTaskCoordinator
- (void)appTaskcoordinator_single {
    if (!_taskCoordinator) {
        AppTaskCoordinator *taskCoordinator = [AppTaskCoordinator new];
        _taskCoordinator = taskCoordinator;
    }
    /*链式调用示例 1*/
    __weak __typeof(_taskCoordinator)weakTask = _taskCoordinator;
    [_taskCoordinator setProBlock:^AppTaskCoordinator *(int index, DispatchQueueMode mode) {
        __strong __typeof(weakTask)strongTask = weakTask;
        NSLog(@"excute : %d:  thread:---%@", index, [NSThread currentThread]);
        return strongTask;
    }];
    _taskCoordinator.proBlock(4, DispatchQueueModeSerial).proBlock(5, DispatchQueueModeYYQueuePool).proBlock(6, DispatchQueueModeMainQueue).proBlock(7, DispatchQueueModeConcurrent).proBlock(8, DispatchQueueModeDefault);
}
- (void)appTaskcoordinator_combine {
    if (!_taskCoordinator) {
        AppTaskCoordinator *taskCoordinator = [AppTaskCoordinator new];
        _taskCoordinator = taskCoordinator;
    }
    /*链式调用示例 2*/
    [[[[[_taskCoordinator autoQueuePoolTask:^{
        sleep(2.0);
        NSLog(@"autoQueuePoolTask  thread:---%@",[NSThread currentThread]);
    }] concurrentQueueTask:^{
        sleep(1.5);
        NSLog(@"concurrentQueueTask  thread:---%@",[NSThread currentThread]);
    }] mainQueueTask:^{
        NSLog(@"mainQueueTask  thread:---%@",[NSThread currentThread]);
    }] appendTask:^{
        sleep(1.0);
        NSLog(@"appendTask  thread:---%@",[NSThread currentThread]);
    } mode:DispatchQueueModeSerial] mainTask:^{
        NSLog(@"mainTask  thread:---%@",[NSThread currentThread]);
    }];
    
    
    /*链式调用示例 3 - 测试堆栈调用顺序*/
    [[[_taskCoordinator mainTask:^{
        NSLog(@"mainTask 100");
    }] mainTask:^{
        NSLog(@"mainTask 200");
    }] mainTask:^{
        NSLog(@"mainTask 300");
    }];
}



void excuteTask(int task) {
    for (int i = 0; i < 2; ++i) {
        [NSThread sleepForTimeInterval:2];                      // 模拟耗时操作
        NSLog(@"%d---%@",task, [NSThread currentThread]);       // 打印当前线程
    }
}

void queueTasks(int taskNumberBegin, int taskNumberEnd, dispatch_queue_t queue, dispatch_group_t group, Dispatch_type type) {
    assert(taskNumberEnd >= taskNumberBegin);
    for (int task = taskNumberBegin; task <= taskNumberEnd; task ++) {
        switch (type) {
            case Dispatch_type_sync:
                dispatch_sync(queue, ^{
                    excuteTask(task);
                });
                break;
            case Dispatch_type_async:
                dispatch_async(queue, ^{
                    excuteTask(task);
                });
                break;
            case Dispatch_type_group_async:
                dispatch_group_async(group, queue, ^{
                    excuteTask(task);
                });
                break;
            default:
                excuteTask(task);
                break;
        }
    }
}

void syncQueueTasks(dispatch_queue_t queue, int taskNum) {
    queueTasks(1, taskNum, queue, nil, Dispatch_type_sync);
}

void asyncQueueTasks(dispatch_queue_t queue, int taskNum) {
    queueTasks(1, taskNum, queue, nil, Dispatch_type_async);
    
}
#pragma mark -
#pragma mark 1. sync-concurrent
/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 
 >> 所有任务都是在当前线程（主线程）中执行的，没有开启新的线程（同步执行不具备开启新线程的能力）。
 >> 所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行的（同步任务需要等待队列的任务执行结束）。
 >> 任务按顺序执行的。按顺序执行的原因：虽然并发队列可以开启多个线程，并且同时执行多个任务。但是因为本身不能创建新线程，只有当前线程这一个线程（同步任务不具备开启新线程的能力），所以也就不存在并发。而且当前线程只有等待当前队列中正在执行的任务执行完毕之后，才能继续接着执行下面的操作（同步任务需要等待队列的任务执行结束）。所以任务只能一个接一个按顺序执行，不能同时被执行。
 
 */
- (void)dispatch_sync_concurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
   
    dispatch_queue_t queue = dispatch_queue_create("net.my.testQueue", DISPATCH_QUEUE_CONCURRENT);
    syncQueueTasks(queue, 3);
    
    
    for (int i = 4; i <= 6; i++) {
        [[DispatchQueueManager shared] sync:^{
            excuteTask(i);
        } model:DispatchQueueModeConcurrent];
    }
    
    NSLog(@"syncConcurrent---end");
}
#pragma mark 2. async-concurrent
/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 * 补充：每追加一次任务dispatch_async，都会开辟一个新线程，所以不宜多此追加任务，减少创建线程开销。
 【异步执行(具备开启新线程能力，不做等待，可以继续执行任务) + 并发队列(可开启多个线程，同时执行多个任务)】
 */
- (void)dispatch_async_concurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.my.testQueue", DISPATCH_QUEUE_CONCURRENT);
    asyncQueueTasks(queue,3);
    
    
    for (int i = 4; i <= 6; i++) {
        [[DispatchQueueManager shared] async:^{
            excuteTask(i);
        } model:DispatchQueueModeConcurrent];
    }
    
    NSLog(@"asyncConcurrent---end");
}
#pragma mark 3. sync-serial
/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 * 补充：【同步执行(不具备开启新线程能力) + 串行队列(每次只有一个任务被执行，任务一个接一个按顺序执行)】
 */
- (void)dispatch_sync_serial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.my.testQueue", DISPATCH_QUEUE_SERIAL);
    syncQueueTasks(queue, 5);
    
    
    for (int i = 4; i <= 6; i++) {
        [[DispatchQueueManager shared] sync:^{
            excuteTask(i);
        } model:DispatchQueueModeSerial];
    }
    

    
    NSLog(@"syncSerial---end");
}

#pragma mark 4. async-serial
/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 * 补充：只开启一个新线程，后续添加任务都在此新线程所在串型队列中顺序执行【异步执行(具备开启新线程能力) + 串行队列(只开启一个线程)】。
 */
- (void)dispatch_async_serial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    
#if Dispatch_native
    dispatch_queue_t queue = dispatch_queue_create("net.my.testQueue", DISPATCH_QUEUE_SERIAL);
    
    asyncQueueTasks(queue, 5);
    
//    DispatchQueueModeYYQueuePool

#else
    for (int i = 6; i <= 10; i++) {
        [[DispatchQueueManager shared] addAsync:^{
            excuteTask(i);
            [self mainQueue:i];
        } model:DispatchQueueModeSerial];

//        [[DispatchQueueManager shared] async:^{
//            excuteTask(i);
//        } model:DispatchQueueModeSerial];
    }
#endif
    
    NSLog(@"asyncSerial---end");
}

- (void)mainQueue:(int)task  {
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100 + arc4random()%50, 100 + arc4random()%50, 10 + arc4random()%10, 10+arc4random()%10)];
        NSArray *colors =  @[UIColor.redColor,UIColor.blueColor,UIColor.greenColor];
        view.backgroundColor = [colors objectAtIndex:arc4random()%3];
        [self.view addSubview:view];
        NSLog(@"%d---%@",task, [NSThread currentThread]);       // 打印当前线程
    });
}

#pragma mark 5. sync-main_queue
/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 * [主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行]
 */
- (void)dispatch_sync_main {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();

    syncQueueTasks(queue, 3);

    for (int i = 7; i <= 10; i++) {
        [[DispatchQueueManager shared] sync:^{
            excuteTask(i);
        } model:DispatchQueueModeMainQueue];
    }
    
    NSLog(@"syncMain---end");
}
#pragma mark 6. async-main_queue
/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)dispatch_async_main {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    asyncQueueTasks(queue, 4);
    
    
    for (int i = 7; i <= 10; i++) {
        [[DispatchQueueManager shared] async:^{
            excuteTask(i);
        } model:DispatchQueueModeMainQueue];
    }

    NSLog(@"asyncMain---end");
}

#pragma mark -
#pragma mark 7. communication
/**
 * 线程间通信
 * 可以看到在其他线程中先执行任务，执行完了之后回到主线程执行主线程的相应操作。
 */
- (void)dispatch_communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}

#pragma mark 8. barrier_async
/**
 * 栅栏方法 dispatch_barrier_async
 * 在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作。
 */
- (void)dispatch_barrier_async {
    dispatch_queue_t queue = dispatch_queue_create("net.my.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    asyncQueueTasks(queue, 2);
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    asyncQueueTasks(queue, 4);
}

#pragma mark 9. dispatch_after
/**
 * 延时执行方法 dispatch_after
 */
- (void)dispatch_after {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    queue = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after1---%@",[NSThread currentThread]);  // 打印当前线程
    });
    
    [[DispatchQueueManager shared] dispatch:^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after2---%@",[NSThread currentThread]);  // 打印当前线程
    } after:2 model:DispatchQueueModeDefault];
}
#pragma mark 10. dispatch_once
/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)dispatch_oncefunc {
//    for (int i = 0; i < 10; i ++) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            // 只执行1次的代码(这里面默认是线程安全的)
//            NSLog(@"1. only once execute！");
//        });
//
//        [DispatchQueueManager  dispatchOnce:^{
//            NSLog(@"2. only once execute！");
//        }];
//    }
    NSInteger modes[5] = {DispatchQueueModeMainQueue,DispatchQueueModeSerial,DispatchQueueModeConcurrent,DispatchQueueModeDefault,DispatchQueueModeYYQueuePool};
    for (int j = 0; j < 3; j ++ ) {
        for (int i = 0; i < 5; i ++) {
            [[DispatchQueueManager shared] async:^{
                NSLog(@"%d ---%@",i,[NSThread currentThread]);  // 打印当前线程
            } model:modes[i]];
        }
    }
}
#pragma mark 11. dispatch_aplly
/**
 * 快速迭代方法 dispatch_apply
 * 通常我们会用 for 循环遍历，但是 GCD 给我们提供了快速迭代的函数dispatch_apply。dispatch_apply按照指定的次数将指定的任务追加到指定的队列中，并等待全部队列执行结束。
 * 补充：新建多个线程异步并发执行，线程开销大。
 */
- (void)dispatch_apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //我们可以利用异步队列同时遍历。比如说遍历 0~5 这6个数字，for 循环的做法是每次取出一个元素，逐个遍历。dispatch_apply可以同时遍历多个数字。
    queue = dispatch_queue_create("net.my.testQueue1", DISPATCH_QUEUE_CONCURRENT);
    
//    queue = dispatch_get_main_queue();
    /*
     如果使用上面dispatch_get_main_queue()将会导致崩溃。
     特点:1. 如果想要在主线程操作，可以使用谈价队列等待的方式，DISPATCH_QUEUE_SERIAL
     补充:2. 如果过使用apply，那么不利用异步线程就显得多余了，所以最好还是利用开辟新线程时候使用。
     */
    queue = dispatch_queue_create("net.my.testQueue1", DISPATCH_QUEUE_SERIAL);

    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

#pragma mark -
#pragma mark 12. dispatch_group_notify

void dosomething() {
    queueTasks(1, 2, dispatch_get_main_queue(), nil, Dispatch_type_async);
}

- (void)dosomething {
    queueTasks(10, 11, dispatch_get_main_queue(), nil, Dispatch_type_async);
}

void notiFunc(void *context) {
    int *c = context;
    NSLog(@"%d, %s", *c, context);
    excuteTask(15);
    NSLog(@"group---end");
}


/**
 * 队列组 dispatch_group_notify
 */
- (void)dispatch_group_notify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
#if 1 //native
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_queue_t queue1 = dispatch_get_main_queue();
    
    queueTasks(1, 2, global_queue, group, Dispatch_type_group_async);
    
//    SEL dosomethingOC = @selector(dosomething);
    
    int  parm = 10;
    dispatch_group_async_f(group, global_queue, nil, dosomething);
//    dispatch_group_async_f(group, global_queue, nil, dosomethingOC);？
    dispatch_group_notify_f(group, queue1, &parm, notiFunc);
    
    
//    dispatch_group_async(group, dispatch_get_main_queue(), ^{
//        queueTasks(1, 4, dispatch_get_main_queue(), nil, Dispatch_type_async);
//    });
    
#if 0
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
//        dispatch_sync(dispatch_get_main_queue(), ^{
            for (int i= 0; i < 2; i++) {
                excuteTask(i);
            }
//        });
    });
    
    //对比wait， 不会阻塞当前线程。
    dispatch_group_notify(group, global_queue, ^{
        excuteTask(15);
        NSLog(@"group---end");
    });
    
    dispatch_group_async(group, global_queue, ^{
        for (int i= 0; i < 2; i++) {
            excuteTask(i);
        }
    });
    
    dispatch_group_notify(group, queue1, ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        dispatch_async(dispatch_get_main_queue(), ^{
            excuteTask(15);
            NSLog(@"group---end");
        });
    });
#endif
    
#else
    NSLog(@"hahahaha");
    [[DispatchQueueManager shared] groupAsync:^{
        for (int i= 0; i < 3; i++) {
            excuteTask(i);
        }
    } mode:DispatchQueueModeDefault notiTask:^{
            for (int i = 0; i < 20; ++i) {
                NSLog(@"%d---%@",i, [NSThread currentThread]);       // 打印当前线程
            }
            NSLog(@"group---end");
    } mode:DispatchQueueModeMainQueue];
    
    
    [[DispatchQueueManager shared] groupNotiTask:^{
        excuteTask(100);
    } mode:DispatchQueueModeConcurrent];
    
#endif
    
    
    //    从dispatch_group_notify相关代码运行输出结果可以看出： 当所有任务都执行完成之后，才执行dispatch_group_notify block 中的任务。
}

#pragma mark 13. dispatch_wait
static dispatch_group_t _group;
/**
 * 队列组 dispatch_group_wait
 */
- (void)dispatch_group_wait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
     _group =  dispatch_group_create();
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    queueTasks(1, 1, global_queue, _group, Dispatch_type_group_async);
    queueTasks(2, 2, global_queue, _group, Dispatch_type_group_async);
    
    NSLog(@"continue ----");
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    [self _group_wait];
    
    NSLog(@"group---end");
}

- (void)_group_wait {
    dispatch_group_wait(_group, DISPATCH_TIME_FOREVER);
    NSLog(@"group---end2");
}

#pragma mark 14. dispatch_enter_leave
/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)dispatch_enter_leave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
#if 1 //native

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    dispatch_sync(queue, ^{
        // 追加任务1
        excuteTask(1);
        dispatch_group_leave(group);
    });
    
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        excuteTask(3);
        NSLog(@"group---end1");
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            // 追加任务2
            excuteTask(4);
            dispatch_group_leave(group);
        });
    });

    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end2");
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        excuteTask(4);
        NSLog(@"group---end1");
    });

#else
    [[DispatchQueueManager shared] groupEnterAsync:^{
        excuteTask(1);
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            excuteTask(1);
        });
    } mode:DispatchQueueModeConcurrent];
    //
    [[DispatchQueueManager shared] groupNotiTask:^{
        excuteTask(3);
        NSLog(@"group---end1");
    } mode:DispatchQueueModeMainQueue];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[DispatchQueueManager shared] groupEnterAsync:^{
            excuteTask(2);
        } mode:DispatchQueueModeConcurrent];
    });
    
    [[DispatchQueueManager shared] groupNotiTask:^{
        excuteTask(4);
        NSLog(@"group---end2");
    } mode:DispatchQueueModeMainQueue];
    
#endif
    
    /*
     从dispatch_group_enter、dispatch_group_leave相关代码运行结果中可以看出：当所有任务执行完成之后，才执行 dispatch_group_notify 中的任务。这里的dispatch_group_enter、dispatch_group_leave组合，其实等同于dispatch_group_async。
     注意：使用group|enter_leave时候，需要使用async。
     */
}
#pragma mark -
#pragma mark 14. semaphore_sync
/**
 * semaphore 线程同步
 */
- (void)dispatch_semaphore_sync {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %d",number);
}

#pragma mark 15. semaphore_thread_safe
- (void)dispatch_semaphore_thread_safe {
#if 0
    [self initTicketStatusNotSave];
#else
    [self initTicketStatusSave];
#endif
}

/**
 * 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.my.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.my.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}

/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe {
    while (1) {
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            break;
        }
        
    }
}


/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;
    __weak typeof(self) weakSelf = self;

#if Dispatch_native
    // 注意。value = 1,标识为一次只允许一个线程任务进行访问。
    self.semaphoreLock = dispatch_semaphore_create(1);
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.my.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.my.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
    
#else
    
    [[DispatchQueueManager shared] async:^{
        while (1) {
            [[DispatchQueueManager shared] natomicTask:^{
                if (weakSelf.ticketSurplusCount > 0) {  //如果还有票，继续售卖
                    weakSelf.ticketSurplusCount--;
                    NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)weakSelf.ticketSurplusCount, [NSThread currentThread]]);
                    [NSThread sleepForTimeInterval:0.3];
                } else { //如果已卖完，关闭售票窗口
                    NSLog(@"所有火车票均已售完");
                }
            }];
            if (weakSelf.ticketSurplusCount <= 0) {
                break;
            }
        }
    } model:DispatchQueueModeConcurrent];

    [[DispatchQueueManager shared] async:^{
        while (1) {
            [[DispatchQueueManager shared] natomicTask:^{
                if (weakSelf.ticketSurplusCount > 0) {  //如果还有票，继续售卖
                    weakSelf.ticketSurplusCount--;
                    NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)weakSelf.ticketSurplusCount, [NSThread currentThread]]);
                    [NSThread sleepForTimeInterval:0.2];
                } else { //如果已卖完，关闭售票窗口
                    NSLog(@"所有火车票均已售完");
                }
            }];
            if (weakSelf.ticketSurplusCount <= 0) {
                break;
            }
        }
    } model:DispatchQueueModeConcurrent];
#endif
    
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {
#if Dispatch_native
        // 相当于加锁
        dispatch_semaphore_wait(self.semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(self.semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(self.semaphoreLock);
        
#else
        [[DispatchQueueManager shared] natomicTask:^{
            if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
                self.ticketSurplusCount--;
                NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
                [NSThread sleepForTimeInterval:0.2];
            }else{
                NSLog(@"所有火车票均已售完");
            }
        }];
        if (self.ticketSurplusCount <= 0) {
            break;
        }
#endif
    }
}

#pragma mark -
#pragma mark  16. cancel_block
/*
 * 取消操作使将来执行 dispatch block
 * 对已经在执行的 dispatch block 没有任何影响。
 */
- (void)dispatch_cancel_block {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");

    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        NSLog(@"block1 begin ---- %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"block1 end --- %@",[NSThread currentThread]);
    });
    
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        NSLog(@"block2 ----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
//    dispatch_block_cancel(block1);
    //取消执行block2
    dispatch_block_cancel(block2);

    
    
    dispatch_block_t longexcuteblock = dispatch_block_create(0, ^{
        for (int i = 0; i < 200; i ++) {
            for (int j = 0; j < 100; j ++) {
                NSLog(@" block3: %d-%d ------%@", i, j, [NSThread currentThread]);
            }
        }
    });
    
    
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue2, block1);
    dispatch_block_cancel(longexcuteblock);//!生效因为longexcuteblock尚未开始执行
    dispatch_async(queue2, longexcuteblock);
    NSLog(@"time 4 secondes to cancel block!");

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 对已经在执行的 dispatch block 没有任何影响。
        dispatch_block_cancel(longexcuteblock);//!不生效， 因为longexcuteblock已经在执行
    });
    NSLog(@"end!");

}

@end




