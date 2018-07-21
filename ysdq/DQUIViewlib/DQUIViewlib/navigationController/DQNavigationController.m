//
//  DQUINavigationController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/18.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "DQNavigationController.h"


@interface DQNavigationController ()<UINavigationBarDelegate>
@property (nonatomic, strong) UIBarButtonItem *backBarItem;
@end

@implementation DQNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize barSize = self.navigationBar.bounds.size;

#if CUSTOM_BAR_STYLE
    
    [self setNavigationBarHidden:YES animated:NO];

    self.navBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, barSize.width, CUSTOM_NAVIGATIONBAR_HEIGHT)];
    [self.navBar showBorderLine];
    self.navBar.delegate = self;
    [self.view addSubview:self.navBar];

    
    /*！ 经过测试，以下代码无效*/
    //    [self.navigationController setValue:self.navBar forKeyPath:@"navigationBar"];

    #else
    
    /*！ 经过测试，以下代码无效*/
//    self.navigationBar.frame = CGRectMake(0, 0, barSize.width, barSize.height + 40);
    self.navigationItem.prompt = @"1";
    
#endif
}



- (UIBarButtonItem *)backBarItem {
    if (!_backBarItem) {
        _backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backBarItemClick:)];
    }
    return _backBarItem;
}

- (void)backBarItemClick:(id)sender {
}

#pragma mark - inherit
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
//    [self.navBar pushNavigationItem:self.navigationItem animated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [super popViewControllerAnimated:animated];
//    [self.navBar popNavigationItemAnimated:YES];
    return [self.childViewControllers firstObject];
}
#pragma mark UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    NSLog(@"%@",navigationBar);
    NSLog(@"%@",item);
    return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    NSLog(@"%@",navigationBar);
    NSLog(@"%@",item);
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    NSLog(@"%@",navigationBar);
    NSLog(@"%@",item);
    return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    NSLog(@"%@",navigationBar);
    NSLog(@"%@",item);
}



#if CUSTOM_BAR_STYLE




//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self refreshChildViewControllersFrame];
//}
//- (void)viewDidLayoutSubviews {
//    [self refreshChildViewControllersFrame];
//}

#pragma mark - private

- (void)navigationTap:(UITapGestureRecognizer *)tapG {
    
    CGPoint tapPoint = [tapG locationInView:tapG.view];
    if (tapPoint.x < 200) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)refreshChildViewControllersFrame {
    for (UIViewController *childVC in self.childViewControllers) {
        CGRect oldFrame = childVC.view.frame;
        CGRect newFrame = CGRectMake(0, CUSTOM_NAVIGATIONBAR_HEIGHT, oldFrame.size.width, oldFrame.size.height - CUSTOM_NAVIGATIONBAR_HEIGHT);
        childVC.view.frame = newFrame;
    }
}
#endif




@end
