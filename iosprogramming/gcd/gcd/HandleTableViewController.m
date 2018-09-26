//
//  HandleTableViewController.m
//  gcd
//
//  Created by lxw on 2018/9/25.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "HandleTableViewController.h"
#import "FuncViewController.h"

@interface HandleTableViewController ()

@end

@implementation HandleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FuncViewController *funcVC = segue.destinationViewController;
    funcVC.title = @"gcd-func";
    if ([segue.identifier isEqualToString:@"sync-concurrent"]) {
        funcVC.type = GCDFuncSYNC_CONCURRENT;
    } else if ([segue.identifier isEqualToString:@"async-concurrent"]) {
        funcVC.type = GCDFuncASYNC_CONCURRENT;
    }else if ([segue.identifier isEqualToString:@"sync-serial"]) {
        funcVC.type = GCDFuncSYNC_SERIAL;
    }else if ([segue.identifier isEqualToString:@"async-serial"]) {
        funcVC.type = GCDFuncASYNC_SERIAL;
    }else if ([segue.identifier isEqualToString:@"sync-main_queue"]) {
        funcVC.type = GCDFuncSYNC_MAIN_QUEUE;
    }else if ([segue.identifier isEqualToString:@"async-main_queue"]) {
        funcVC.type = GCDFuncASYNC_MAIN_QUEUE;
    }
    
    else if ([segue.identifier isEqualToString:@"communication"]) {
        funcVC.type = GCDFuncCommunication;
    } else if ([segue.identifier isEqualToString:@"barrier_async"]) {
        funcVC.type = GCDFunc_BARRIER_ASYNC;
    } else if ([segue.identifier isEqualToString:@"dispatch_after"]) {
        funcVC.type = GCDFunc_AFTER;
    } else if ([segue.identifier isEqualToString:@"dispatch_once"]) {
        funcVC.type = GCDFunc_ONCE;
    } else if ([segue.identifier isEqualToString:@"dispatch_aplly"]) {
        funcVC.type = GCDFunc_APPLY;
    }
    
    else if ([segue.identifier isEqualToString:@"dispatch_group_notify"]) {
        funcVC.type = GCDFunc_GROUP_NOTIFY;
    } else if ([segue.identifier isEqualToString:@"dispatch_wait"]) {
        funcVC.type = GCDFunc_GROUP_WAIT;
    } else if ([segue.identifier isEqualToString:@"dispatch_enter_leave"]) {
        funcVC.type = GCDFunc_GROUP_ENTER_LEAVE;
    }
    
    else if ([segue.identifier isEqualToString:@"semaphore_sync"]) {
        funcVC.type = GCDFunc_SEMAPHORE_SYNC;
    } else if ([segue.identifier isEqualToString:@"semaphore_thread_safe"]) {
        funcVC.type = GCDFunc_SEMAPHORE_THREAD_SAFE;
    }
    
    else if ([segue.identifier isEqualToString:@"cancel_block"]) {
        funcVC.type = GCDFunc_CANCEL_BLOCK;
    }
    funcVC.title = segue.identifier;
}















@end
