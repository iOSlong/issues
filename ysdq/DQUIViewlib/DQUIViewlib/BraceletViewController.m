//
//  BraceletViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "BraceletViewController.h"
#import "BraceletView.h"

@interface BraceletViewController ()
@property (nonatomic, strong) BraceletView  *braceletView;
@end

@implementation BraceletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.braceletView = [[BraceletView alloc] initWithFrame:[self showFrameBracelet]];
    self.braceletView.backgroundColor = [UIColor yellowColor];
    [self.braceletView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.braceletView setTitle:@"2" forState:UIControlStateNormal];
    [self.braceletView.titleLabel setFont:[UIFont boldSystemFontOfSize:50]];
    [self.view addSubview:self.braceletView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.braceletView setColorShow:[UIColor purpleColor]];
    });
}



@end
