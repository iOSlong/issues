//
//  HouseViewController.m
//  VCAnimationTransition
//
//  Created by lxw on 2018/7/4.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "HouseViewController.h"

@interface HouseViewController ()

@end

@implementation HouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *buttonPush1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonPush1 setTitle:@"back" forState:UIControlStateNormal];
    [buttonPush1 setFrame:CGRectMake(150, 70 + 60, 200, 30)];
    buttonPush1.layer.borderColor   = [UIColor blueColor].CGColor;
    buttonPush1.layer.borderWidth   = 2;
    buttonPush1.layer.cornerRadius  = 5;
    [buttonPush1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPush1];

}
- (void)buttonClicked:(UIButton *)btn {
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
