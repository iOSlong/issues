//
//  WatchInfo.m
//  DQUIViewlib
//
//  Created by lxw on 2018/8/22.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "WatchInfo.h"

@implementation AppendItem
- (instancetype)initWith:(NSDictionary<NSString *,NSNumber *> *)info {
    self = [super init];
    if (self) {
        _time = info.allValues.firstObject.doubleValue;
        _desc = info.allKeys.firstObject;
    }
    return self;
}
- (instancetype)initWithTime:(CFTimeInterval)time msg:(NSString *)message {
    self = [super init];
    if (self) {
        _time = time;
        _desc = message;
    }
    return self;
}

@end

#pragma mark - WatchInfo
@implementation WatchInfo

+ (NSString *)documentPath {
    NSArray  *directoryArr      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = directoryArr.firstObject;
    return documentDirectory;
}

+ (LKDBHelper *)getUsingLKDBHelper {
    static id db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dbPath = [[WatchInfo documentPath] stringByAppendingString:@"databases"];
        dbPath = [dbPath stringByAppendingString:@"WatchInfo.db"];
        db = [[LKDBHelper alloc] initWithDBPath:dbPath];
    });
    return db;
}

+ (NSString *)getTableName {
    return @"watchInfo";
}

+ (NSDate *)watchDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSArray *)readAllWatchInfo {
    NSArray<WatchInfo *> *infos = [WatchInfo searchWithSQL:@"select * from @t order by launchTimes ASC"];//! 逆序 DESC
    
    [self formatInfos:infos];
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (WatchInfo *info in infos) {
        [muArr addObject:[info toJSONString]];
    }
    BOOL suc = [muArr writeToFile:[[WatchInfo documentPath] stringByAppendingPathComponent:@"infoFiles"] atomically:YES];
    if (suc) {
        NSLog(@"");
    }
    return muArr;
}

+ (void)formatInfos:(NSArray<WatchInfo *> *)infos {
    NSMutableString *formatString = [NSMutableString string];
    for (AppendItem *item in [infos firstObject].appendItems) {
        [formatString appendFormat:@"%@ \b",item.desc];
    }
    [formatString appendString:@"\n"];
//    [formatString appendString:@"ORDER \b FL0 \b FL1 \b  VDL0 \b VDL1 \b  VDAP \n"];
    for (int i = 1; i <= infos.count; i ++) {
        WatchInfo *info = infos[i - 1];
        NSMutableString *rowString = [NSMutableString stringWithFormat:@"%d \b",i];
        [rowString appendString:[info rowFormatString]];
        [rowString appendString:@"\n"];
        [formatString appendString:rowString];
    }
    NSError *error = nil;
    [formatString writeToFile:[[WatchInfo documentPath] stringByAppendingPathComponent:@"infotext"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    NSLog(@"\n%@",formatString);
}

+ (void)clearAllWatchInfo {
    [WatchInfo deleteWithWhere:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _appendItems = (NSMutableArray<AppendItem> *)[NSMutableArray array];
    }
    return self;
}

- (BOOL)isSaveValidLaunch {
    for (AppendItem *item in self.appendItems) {
        if ([item.desc containsString:WATCH_FINISHLAUNCH0]) {
            return YES;
        }
    }
    return NO;
}

- (CFTimeInterval)timeDock:(NSString *)dock {
    for (AppendItem *item in self.appendItems) {
        if ([item.desc containsString:dock]) {
            return item.time;
        }
    }
    return 0.0;
}
- (NSString *)rowFormatString {
    //@"FL1"  @"VDL0"  @"VDL1"  @"VDAP"
    CFTimeInterval FL0  = [self timeDock:WATCH_FINISHLAUNCH0];
    CFTimeInterval FL1  = [self timeDock:WATCH_FINISHLAUNCH1];
    CFTimeInterval VDL0 = [self timeDock:WATCH_VIEWDIDLOAD0];
    CFTimeInterval VDL1 = [self timeDock:WATCH_VIEWDIDLOAD1];
    CFTimeInterval VDAP = [self timeDock:WATCH_VIEWDIDAPPEAR];
    return [NSString stringWithFormat:@"%.4f \t %.4f \t %.4f \t %.4f \t %.4f ",FL0,FL1,VDL0,VDL1,VDAP];
}

@end


