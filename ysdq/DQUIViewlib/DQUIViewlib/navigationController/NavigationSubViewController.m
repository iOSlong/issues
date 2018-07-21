//
//  NavigationSubViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/18.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "NavigationSubViewController.h"
#import "DQNavigationController.h"

@interface NavigationSubViewController ()

@end

@implementation NavigationSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationItem.title = @"子页面导航标题";
    self.navigationItem.prompt = @"子页面内线";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
