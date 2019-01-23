//
//  AppDelegate.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AppDelegate.h"
#import "DQNavigationController.h"
#import "NavigationControllerListViewController.h"
#import "WatchInfo.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void)setupRunloopObserver
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        
        CFRunLoopObserverRef enterObserver;
        enterObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                kCFRunLoopEntry | kCFRunLoopExit,
                                                true,
                                                -0x7FFFFFFF,
                                                BBRunloopObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, enterObserver, kCFRunLoopCommonModes);
        CFRelease(enterObserver);
    });
}

static void BBRunloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            NSLog(@"enter runloop...");
        }
            break;
        case kCFRunLoopExit: {
            NSLog(@"leave runloop...");
        }
            break;
        default: break;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[BLStopwatch sharedStopwatch] splitWithDescription:@"didFinishLaunchBegin"];
    [[BLStopwatch sharedStopwatch] splitWithType:BLStopwatchSplitTypeContinuous description:WATCH_FINISHLAUNCH0];
    
    [self setupPushNotifications:application];
//    [WatchInfo logParse:nil];
    

//    NSArray *infos =  [WatchInfo readAllWatchInfo];
#if CUSTOM_BAR_STYLE
    NavigationControllerListViewController *listVC = [NavigationControllerListViewController new];
    DQNavigationController *navNV = [[DQNavigationController alloc] initWithRootViewController:listVC];
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = @[navNV];
    self.window.rootViewController = tabVC;
#else
    UINavigationBar *bar = [UINavigationBar appearance];
#endif
    
    //设置显示的颜色
//    bar.barTintColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0];
//    [[BLStopwatch sharedStopwatch] splitWithDescription:@"didFinishLaunchOver"];
    [[BLStopwatch sharedStopwatch] splitWithType:BLStopwatchSplitTypeContinuous description:WATCH_FINISHLAUNCH1];
    return YES;
}

- (void)setupPushNotifications:(UIApplication*)application {
#if TARGET_IPHONE_SIMULATOR
    return;
#else // if TARGET_IPHONE_SIMULATOR
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            // iOS 10
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [application registerForRemoteNotifications];
            center.delegate = self;
        } else  if(@available(iOS 8.0, *)){
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil]];
            [application registerForRemoteNotifications];
        }else{
            [application registerForRemoteNotifications];
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert categories:nil]];
        }
        
            //上报推送通知权限是否开启。
        [self appRemoteNotificationAuthorization:^(BOOL granted) {
            NSLog(@"");
        }];
#endif   // if TARGET_IPHONE_SIMULATOR
    }
}
- (void)appRemoteNotificationAuthorization:(void (^)(BOOL))complete {
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError *error) {
            if (complete) {
                complete(granted);
            }
        }];
    } else  if(@available(iOS 8.0, *)){
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (complete) {
            complete(setting.types != UIUserNotificationTypeNone);
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
