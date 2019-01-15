//
//  AppDelegateCoordinator.h
//  Le123PhoneClient
//
//  Created by lxw on 2018/10/8.
//  Copyright © 2018年 Ying Shi Da Quan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef dispatch_block_t AppQueueTask;

typedef NS_ENUM(NSUInteger, AppQueueMode) {
    AppQueueModeDefault         = 1,    //默认队列：global_queue
    AppQueueModeSerial          = 2,    //串行队列
    AppQueueModeConcurrent      = 3,    //并发队列
    AppQueueModeMainQueue       = 4,    //主线程队列
    AppQueueModeYYQueuePool     = 5,    //YYQueuePool自动队列池。
};

@interface BZXAppQueueManager : NSObject
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
/**
 * 将任务【同步】到指定队列类型执行。
 *
 * @param task 要执行的任务块
 * @param queueMode 队列类型， 注意：如果是在主线程，那么queueMode不要再填写AppQueueModeMainQueue，否则多系统版本中主线程任务互等卡顿直至崩溃。
 * @return void void
 */
+ (void)queueSync:(AppQueueTask)task model:(AppQueueMode)queueMode;
/**
 * 将任务【异步】到指定队列类型执行。
 *
 * @param task 要执行的任务块
 * @param queueMode 队列类型，
 * @return void void
 */
+ (void)queueAsync:(AppQueueTask)task model:(AppQueueMode)queueMode;
/**
 * 将任务【异步添加】到指定队列类型执行。
 *
 * @param task 要执行的任务块
 * @param queueMode 队列类型， 说明：根据队列类型，如果没有将新建队列及对应异步线程，如果已经存在，则是将任务继续添加到指定的已存队列中。
 * @return void void
 */
+ (void)queueAddAsync:(AppQueueTask)task model:(AppQueueMode)queueMode;
/**
 * 任务组【异步执行-线程间通信】，利用固有任务组实现线程间序列执行通知交互
 *
 * @param task 首先异步执行的任务块
 * @param asyncQueue 队里类型
 * @param notiTask 异步任务完成后将执行的任务快
 * @param notiQueue 队里类型
 * @return void<##>
 */
+ (void)groupAsync:(AppQueueTask)task mode:(AppQueueMode)asyncQueue notiTask:(AppQueueTask)notiTask mode:(AppQueueMode)notiQueue;
/**
 * 对固有任务组添加新的通知任务（当 固有group中任务执行完毕或group中无任务，将执行task任务）
 *
 * @param task group所有任务完成后要执行的任务块
 * @param notiMode 任务块执行所在 队里类型
 * @return void
 */
+ (void)groupNotiTask:(AppQueueTask)task mode:(AppQueueMode)notiMode;
/**
 * 对固有任务组添加新的group任务
 *
 * @param task 添加group中执行的任务块
 * @param mode 任务块执行所在 队里类型
 * @return void
 */
+ (void)groupEnterAsync:(AppQueueTask)task mode:(AppQueueMode)mode;
/**
 * 执行任务块【线程安全】
 *
 * @param task 任务块
 * @param
 * @return void
 */
+ (void)natomicTask:(AppQueueTask)task;
@end

#pragma mark -
#pragma mark - BZXAppDelegateCoordinator

typedef void(^AppendBlock)(void);

@interface BZXAppDelegateCoordinator : NSObject

/**
 * 【并发异步执行】添加的任务。会开启新线程，并将任务在新县城的并发队列中执行。
 *
 * @param block 添加的任务块，建议优先级最低的任务可以搁置到这个任务块中。
 * @param
 * @return BZXAppDelegateCoordinator 方便与链式调用书写格式，继续末尾函数调用代码添加。
 */
- (instancetype)concurrentQueueTask:(AppendBlock)block;
/**
 * 将任务添加到【自动队列池 - YYQueuePool】中，YYQueuePool使用了cpu自动判断派发队列的方式提高cpu使用率。
 *
 * @param block 添加的任务块，建议无优先级要求的任务可以搁置到这个任务队列中。
 * @param
 * @return BZXAppDelegateCoordinator 方便与链式调用书写格式，继续末尾函数调用代码添加。
 */
- (instancetype)autoQueuePoolTask:(AppendBlock)block;
/**
 * 将任务异步添加到【主线程队列 - main_queue】中进行执行
 *
 * @param block 添加的任务块，建议将需要在主线程执行的优先级相对较低无须立即执行的任务添加到此任务块中。
 * @param
 * @return BZXAppDelegateCoordinator
 */
- (instancetype)mainQueueTask:(AppendBlock)block;
/**
 * 添加执行任务【无线程切换】
 *
 * @param block 添加的任务块，统一代码块。
 * @param
 * @return BZXAppDelegateCoordinator
 */
- (instancetype)mainTask:(AppendBlock)block;
/**
 * 将任务【异步添加】到指定队列类型执行。
 *
 * @param block 执行任务块
 * @param mode 队列模式枚举
 * @return BZXAppDelegateCoordinator<##>
 */
- (instancetype)appendTask:(AppendBlock)block mode:(AppQueueMode)mode;

@property (nonatomic, copy) id (^proAsyncBlock)(AppQueueMode mode);

@end





