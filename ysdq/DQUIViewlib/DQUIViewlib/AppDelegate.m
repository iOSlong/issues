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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[BLStopwatch sharedStopwatch] splitWithDescription:@"didFinishLaunchBegin"];
    [[BLStopwatch sharedStopwatch] splitWithType:BLStopwatchSplitTypeContinuous description:WATCH_FINISHLAUNCH0];
    
    UIImageView *imagev;
    
    [imagev setImage:nil];
    
    [WatchInfo logParse:nil];
    
    NSDictionary *dict0 = @{@"key":@"value"};
    NSString *one = [dict0 objectForKey:@"key"];
    NSString *on1 = [dict0 objectForKey:@"key2"];
    NSString *one2 = dict0[@"key"];
    NSString *one3 = dict0[@"key2"];


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
