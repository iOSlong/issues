//
//  BaseViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomNavigationBar.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor redColor]}];

    

    [self.view showBorderLine];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor purpleColor];
}
- (CGRect)showFrameBracelet {
    return CGRectMake(100, 100, 100, 100);
}



@end
