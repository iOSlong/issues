/*
 * This file is part of the BLStopwatch package.
 * (c) NewPan <13246884282@163.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Click https://github.com/beiliao-mobile/BLStopwatch
 * or https://juejin.im/user/5941fa488d6d810058c0d4df to contact us.
 */

#import "BLStopwatch.h"
#import "pthread.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BLStopwatchState) {
    BLStopwatchStateInitial = 0,
    BLStopwatchStateRuning,
    BLStopwatchStateStop,
};

@interface BLStopwatch ()

@property (nonatomic) CFTimeInterval startTimeInterval;
@property (nonatomic) CFTimeInterval temporaryTimeInterval;
@property (nonatomic) CFTimeInterval stopTimeInterval;
@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, NSNumber *> *> *mutableSplits;
@property (nonatomic) BLStopwatchState state;
@property (nonatomic) pthread_mutex_t lock;
@property (nonatomic) WatchInfo *watchInfo;
@property (nonatomic) BOOL havShowed;

@end

@implementation BLStopwatch

+ (instancetype)sharedStopwatch {
    static BLStopwatch* stopwatch;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stopwatch = [[BLStopwatch alloc] init];
    });

    return stopwatch;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableSplits  = [NSMutableArray array];
        _watchInfo = [WatchInfo new];
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (NSArray *)splits {
    pthread_mutex_lock(&_lock);
    NSMutableArray<NSDictionary<NSString *, NSNumber *> *> *array = [self.mutableSplits copy];
    pthread_mutex_unlock(&_lock);
    return array;
}

- (NSString *)prettyPrintedSplits {
    NSMutableString *output = [[NSMutableString alloc] init];
    pthread_mutex_lock(&_lock);
    [self.mutableSplits enumerateObjectsUsingBlock:^(NSDictionary<NSString *, NSNumber *> *obj, NSUInteger idx, BOOL *stop) {
        [output appendFormat:@"%@: %.3f\n", obj.allKeys.firstObject, obj.allValues.firstObject.doubleValue];
    }];
    pthread_mutex_unlock(&_lock);

    return [output copy];
}

- (NSTimeInterval)elapseTimeInterval {
    switch (self.state) {
        case BLStopwatchStateInitial:
            return 0;
        case BLStopwatchStateRuning:
            return CACurrentMediaTime() - self.startTimeInterval;
        case BLStopwatchStateStop:
            return self.stopTimeInterval - self.startTimeInterval;
    }
}

- (void)start {
    self.state = BLStopwatchStateRuning;
    self.startTimeInterval = CACurrentMediaTime();
    self.temporaryTimeInterval = self.startTimeInterval;
}

- (void)splitWithDescription:(NSString * _Nullable)description {
    [self splitWithType:BLStopwatchSplitTypeMedian description:description];
}

- (void)splitWithType:(BLStopwatchSplitType)type description:(NSString * _Nullable)description {
    if (self.state != BLStopwatchStateRuning) {
        return;
    }

    //如果事件点重复，保留以一次的。
    if ([self judgeDulpliacteDesc:description]) {
        return;
    }
    
    NSTimeInterval temporaryTimeInterval = CACurrentMediaTime();
    CFTimeInterval splitTimeInterval = type == BLStopwatchSplitTypeMedian ? temporaryTimeInterval - self.temporaryTimeInterval : temporaryTimeInterval - self.startTimeInterval;

    NSInteger count = self.mutableSplits.count + 1;

    NSMutableString *finalDescription = [NSMutableString stringWithFormat:@"#%@", @(count)];
    if (description) {
        [finalDescription appendFormat:@" %@", description];
    }
    
    pthread_mutex_lock(&_lock);
    [self.mutableSplits addObject:@{finalDescription : @(splitTimeInterval)}];
    pthread_mutex_unlock(&_lock);
    self.temporaryTimeInterval = temporaryTimeInterval;
}

- (BOOL)judgeDulpliacteDesc:(NSString *)description {
    for (NSDictionary<NSString *,NSNumber *> *obj in self.mutableSplits) {
        if ([obj.allKeys.firstObject containsString:description]) {
            return YES;
        }
    }
    return NO;
}

- (void)refreshMedianTime {
    self.temporaryTimeInterval = CACurrentMediaTime();
}

- (void)stop {
    self.state = BLStopwatchStateStop;
    self.stopTimeInterval = CACurrentMediaTime();
}

- (void)reset {
    self.state = BLStopwatchStateInitial;
    pthread_mutex_lock(&_lock);
    [self.mutableSplits removeAllObjects];
    pthread_mutex_unlock(&_lock);
    self.startTimeInterval = 0;
    self.stopTimeInterval = 0;
    self.temporaryTimeInterval = 0;
}

- (void)stopAndPresentResultsThenReset {
    if (self.havShowed) {
        return;
    }
    [[BLStopwatch sharedStopwatch] stop];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.intValue >= 9) {
        UIAlertController *alertC = [[UIAlertController alloc] init];
        [alertC setTitle:@"watch 结果"];
        [alertC setMessage:[[BLStopwatch sharedStopwatch] prettyPrintedSplits]];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertC addAction:action];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (UIUserInterfaceIdiomPad ==[[UIDevice currentDevice] userInterfaceIdiom]) {
            alertC.popoverPresentationController.sourceView = window.rootViewController.view;
            [window.rootViewController presentViewController:alertC animated:YES completion:nil];
        } else {
            [window.rootViewController presentViewController:alertC animated:YES completion:nil];
        }
    
    } else {
        [[[UIAlertView alloc] initWithTitle:@"watch 结果"
                                    message:[[BLStopwatch sharedStopwatch] prettyPrintedSplits]
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
    }
    [self saveWatchInfo];
    [[BLStopwatch sharedStopwatch] reset];
    [WatchInfo readAllWatchInfo];// 从这里去导出运行文件记录。
    self.havShowed = YES;
}


#pragma mark - database control
- (NSInteger )readWatchInfoLaunchCount {
    NSArray<WatchInfo *> *infos = [WatchInfo searchWithSQL:@"select * from @t order by launchTimes desc LIMIT 1"];
    WatchInfo *lastOne = infos.lastObject;
    NSInteger launchTimes =  lastOne.launchTimes;
    return launchTimes + 1;
}

/** 保存当前下载信息到本地 */
- (void)saveWatchInfo {
    NSInteger launchTimes = [self readWatchInfoLaunchCount];
    if (launchTimes > 100) { //MARK: 保留一百条记录。
        [WatchInfo clearAllWatchInfo];
        launchTimes = 1;
    }
    self.watchInfo.launchTimes = launchTimes;
    for (NSDictionary *info in self.mutableSplits) {
        AppendItem *aItem  = [[AppendItem alloc] initWith:info];
        [self.watchInfo.appendItems addObject:aItem];
    }
    
    if ([self.watchInfo isSaveValidLaunch]) {
        BOOL suc = [self.watchInfo saveToDB];
        if (suc) {
            [self.watchInfo.appendItems removeAllObjects];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
