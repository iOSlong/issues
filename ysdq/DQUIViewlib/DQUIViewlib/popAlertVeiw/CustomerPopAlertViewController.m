//
//  CustomerPopAlertViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/22.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "CustomerPopAlertViewController.h"

@interface CustomerPopAlertViewController ()

@end

@implementation CustomerPopAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
