//
//  FuncViewController.h
//  gcd
//
//  Created by lxw on 2018/9/25.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GCDFunc) {
    GCDFuncSYNC_CONCURRENT          = 1,
    GCDFuncASYNC_CONCURRENT         = 2,
    GCDFuncSYNC_SERIAL              = 3,
    GCDFuncASYNC_SERIAL             = 4,
    GCDFuncSYNC_MAIN_QUEUE          = 5,
    GCDFuncASYNC_MAIN_QUEUE         = 6,
    
    GCDFuncCommunication            = 8,
    GCDFunc_BARRIER_ASYNC           = 9,
    GCDFunc_AFTER                   = 10,
    GCDFunc_ONCE                    = 11,
    GCDFunc_APPLY                   = 12,
    
    GCDFunc_GROUP_NOTIFY            = 13,
    GCDFunc_GROUP_WAIT              = 14,
    GCDFunc_GROUP_ENTER_LEAVE       = 15,
    
    GCDFunc_SEMAPHORE_SYNC          = 16,
    GCDFunc_SEMAPHORE_THREAD_SAFE   = 17,
    
    GCDFunc_CANCEL_BLOCK            = 18
};


typedef NS_ENUM(NSUInteger, Dispatch_type) {
    Dispatch_type_sync,
    Dispatch_type_async,
    Dispatch_type_group_async,
};

@interface DispatchFuncViewController : UIViewController
@property (nonatomic, assign) GCDFunc type;
@end
