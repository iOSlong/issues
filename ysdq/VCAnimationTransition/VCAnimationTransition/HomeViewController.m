//
//  HomeViewController.m
//  VCAnimationTransition
//
//  Created by lxw on 2018/7/4.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "HomeViewController.h"
#import "HouseViewController.h"
#import "HouseNavigationController.h"
#import "PresentAnimationController.h"

@interface HomeViewController ()
@property (nonatomic, strong) HouseViewController *houseVC;
@property (nonatomic, strong) HouseNavigationController *houseNav;
@end

@implementation HomeViewController

- (HouseViewController *)houseVC {
    if (!_houseVC) {
        _houseVC = [HouseViewController new];
    }
    return _houseVC;
}

- (HouseNavigationController *)houseNav {
    if (!_houseNav) {
        _houseNav = [[HouseNavigationController alloc] initWithRootViewController:self.houseVC];
    }
    return _houseNav;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *actions = @[@"push houseNav", @"push houseVC", @"present houseNav", @"present houseVC"];
    for (int i = 0; i < actions.count; i++) {
        UIButton *buttonPush1 = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonPush1 setTitle:actions[i] forState:UIControlStateNormal];
        [buttonPush1 setFrame:CGRectMake(100, 150 + i * 60, 200, 30)];
        buttonPush1.layer.borderColor   = [UIColor blueColor].CGColor;
        buttonPush1.layer.borderWidth   = 2;
        buttonPush1.layer.cornerRadius  = 5;
        buttonPush1.tag = i;
        [buttonPush1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonPush1];
    }
}

- (void)buttonClicked:(UIButton *)btn {
    self.buttonAction = btn;
    SEL sels[4] = {@selector(pushHouseNav),@selector(pushHouseVC),@selector(presentHouseNav),@selector(presentHouseVC)};
    SEL actionSel = sels[btn.tag];
    [self performSelector:actionSel];
}
- (void)pushHouseNav {
    self.houseVC.appearType = AppearTypePushInNav;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Can't do this" message:@"navigation can't child navigaitonController" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)pushHouseVC {
    self.houseVC = [HouseViewController new];
    self.houseVC.appearType = AppearTypePush;
    self.houseVC.hidesBottomBarWhenPushed = YES;
    /*! 支持转场动画(包括自定义转场动画)，animated必须为YES*/
    [self.navigationController pushViewController:self.houseVC animated:YES];
}
- (void)presentHouseNav {
    self.houseVC.appearType = AppearTypePresentInNav;
    self.houseNav.transitioningDelegate = [PresentViewControllerTransitioningDelegator transitionDelegatorfromVC:self ToVC:self.houseNav];
    [self presentViewController:self.houseNav animated:YES completion:nil];
}
- (void)presentHouseVC {
    self.houseVC = [HouseViewController new];
    self.houseVC.hidesBottomBarWhenPushed = YES;
    self.houseVC.appearType = AppearTypePresent;
    self.houseVC.transitioningDelegate = [PresentViewControllerTransitioningDelegator transitionDelegatorfromVC:self ToVC:self.houseVC];
    [self presentViewController:self.houseVC animated:YES completion:nil];
}
@end
