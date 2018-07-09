//
//  HouseViewController.m
//  VCAnimationTransition
//
//  Created by lxw on 2018/7/4.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "HouseViewController.h"
#import "PresentAnimationController.h"

@interface HouseViewController ()
@property(nonatomic,strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@end

@implementation HouseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.layer.borderColor = [UIColor redColor].CGColor;
    self.viewIfLoaded.layer.borderWidth = 5;
    
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    
    UIButton *buttonPush1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonPush1 setTitle:@"back" forState:UIControlStateNormal];
    [buttonPush1 setFrame:CGRectMake(150, 70 + 60, 200, 30)];
    buttonPush1.layer.borderColor   = [UIColor blueColor].CGColor;
    buttonPush1.layer.borderWidth   = 2;
    buttonPush1.layer.cornerRadius  = 5;
    [buttonPush1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buttonPush1];
    self.buttonBack = buttonPush1;
    
    
    
    UIButton *buttonP = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonP setTitle:@"present One" forState:UIControlStateNormal];
    [buttonP setFrame:CGRectMake(150, 170 + 60, 200, 30)];
    buttonP.layer.borderColor   = [UIColor blueColor].CGColor;
    buttonP.layer.borderWidth   = 2;
    buttonP.layer.cornerRadius  = 5;
    buttonP.tag = 10;
    [buttonP addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buttonP];

}
- (void)buttonClicked:(UIButton *)btn {
    if (btn.tag == 10) {
        HouseViewController *houseVC = [HouseViewController new];
        houseVC.hidesBottomBarWhenPushed = YES;
        houseVC.appearType = AppearTypePresent;
        houseVC.view.backgroundColor = [UIColor colorWithRed:0.01 * (arc4random()%255) green:0.01 * (arc4random()%255) blue:0.01 * (arc4random()%255) alpha:1];
        houseVC.transitioningDelegate = [PresentViewControllerTransitioningDelegator transitionDelegatorfromVC:self ToVC:houseVC];

        [self presentViewController:houseVC animated:YES completion:nil];
        return;
    }
    switch (self.appearType) {
        case AppearTypePush:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            case AppearTypePushInNav:
            [self.navigationController popoverPresentationController];
            break;
            case AppearTypePresent:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            case AppearTypePresentInNav:
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}



@end
