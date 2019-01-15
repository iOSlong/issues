//
//  WatchInfo.h
//  DQUIViewlib
//
//  Created by lxw on 2018/8/22.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>


/* 通过切换value值，会将运行数据存储在不同的表中，方便模式对比。
 value 1: 使用了appDelegateCoordinator整管app
 value 0: 对比项，原始模式状态。
*/

#define APP_TBC_MODE_VALUE (1)

#define BZXDB_Dir       @ "DQNewDatabases"          //数据库目录名



#define WATCH_FINISHLAUNCH0     @"AFL0"
#define WATCH_FINISHLAUNCH1     @"AFL1"
#define WATCH_FEACHSERVER0      @"NET0"
#define WATCH_FEACHSERVER1      @"NET1"
#define WATCH_FEACHSERVER2      @"NET2"
#define WATCH_FEACHSERVER3      @"NET3"
#define WATCH_VIEWDIDLOAD0      @"VDL0"
#define WATCH_VIEWDIDLOAD1      @"VDL1"
#define WATCH_VIEWDIDAPPEAR     @"VDAP"

#define WATCH_LAUNCHADSERVER    @"AD_0" //请求广告
#define WATCH_LAUNCHTIMESTAR    @"AD_1" //广告倒计时开始。（认为是判断用户初始体验应用完成启动的时间点。）


@protocol AppendItem<NSObject>
@end

@interface AppendItem : JSONModel
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) CFTimeInterval time;
- (instancetype)initWithTime:(CFTimeInterval)time msg:(NSString *)message;
- (instancetype)initWith:(NSDictionary<NSString *, NSNumber *> *)info;
@end


@interface WatchInfo : JSONModel
@property (nonatomic, assign) NSInteger     launchTimes;//标记启动次数。
@property (nonatomic, strong) NSMutableArray<AppendItem> *appendItems;
+ (NSDate *)watchDate;
+ (void)clearAllWatchInfo;
+ (NSArray *)readAllWatchInfo;
- (BOOL)isSaveValidLaunch;

@end
