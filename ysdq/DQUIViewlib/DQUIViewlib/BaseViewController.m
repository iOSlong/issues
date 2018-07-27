//
//  BaseViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomNavigationBar.h"

@interface BaseViewController ()<UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL barHiddenMark;
@end

@implementation BaseViewController
- (CGRect)showFrameBracelet {
    return CGRectMake(100, 100, 100, 100);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor redColor]}];

    [self recordNavigationBarHiddenStateOfBaseViewController];


    [self.view showBorderLine];
    self.navigationController.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor purpleColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self tryRecoverNavigationBarHiddenStateOfBaseViewController];
}

- (void)recordNavigationBarHiddenStateOfBaseViewController {
    if (self.navigationController) {
        self.barHiddenMark = self.navigationController.navigationBar.hidden;
    }
}
- (void)tryRecoverNavigationBarHiddenStateOfBaseViewController {
    if (self.navigationController) {
        NSArray *array = self.navigationController.viewControllers;
        if (self == [array lastObject]) {
            NSLog(@"%@",self.title);
        }else{
            NSLog(@"%@",self.title);
        }
    }
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        NSLog(@"OperationPop");
    } else  if(operation==UINavigationControllerOperationPush) {
        NSLog(@"OperationPush");
    } else {
        return nil;
    }
    return nil;
}




@end
