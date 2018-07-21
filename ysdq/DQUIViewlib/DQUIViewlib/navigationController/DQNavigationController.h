//
//  DQUINavigationController.h
//  DQUIViewlib
//
//  Created by lxw on 2018/7/18.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBar.h"

@interface DQNavigationController : UINavigationController
@property (nonatomic, strong) CustomNavigationBar *navBar;

- (void)refreshChildViewControllersFrame;

@end
