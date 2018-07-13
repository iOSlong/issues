//
//  SingleViewLibTableViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/13.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "SingleViewLibTableViewController.h"
#import "BaseViewController.h"

@interface SingleViewLibTableViewController ()

@end

@implementation SingleViewLibTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BaseViewController *desVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Bracelet"]) {
        desVC.viewType = ViewTypeBracelet;
    }else if ([segue.identifier isEqualToString:@"GradientAnimation"]) {
        desVC.viewType = ViewTypeGradientAnimation;
    }else if ([segue.identifier isEqualToString:@"GradientLayer"]) {
        desVC.viewType = ViewTypeGradientLayer;
    }
}

@end
