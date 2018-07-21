//
//  SelfNavigationBarViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/17.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "SelfNavigationBarViewController.h"
#import "CustomNavigationBar.h"

@interface SelfNavigationBarViewController ()

@end

@implementation SelfNavigationBarViewController

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self buildTitle];
    }
    return self;
}

- (void)buildTitle {
    self.title = @"测试导航标题";
    self.navigationItem.title = @"navigationItem";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.title = @"测试导航标题";
    if(self.viewType == ViewTypeGradientNavigationBar){
        [self buildTitle];
    }
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    markLabel.backgroundColor = [UIColor yellowColor];
    markLabel.text = @"{100,100,200,100}";
    [self.view addSubview:markLabel];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemClick:)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    [self showCustomerNavigationBar];
}

- (void)buttonItemClick:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)showCustomerNavigationBar {
//    CGSize barSize = self.navigationController.navigationBar.bounds.size;
//
//    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 200, barSize.width - 20 , barSize.height + 50)];
//    bar.backgroundColor = [UIColor redColor];
//    [self.view addSubview:bar];
    
}



@end
