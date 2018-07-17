//
//  SingleViewLibTableViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/13.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "SingleViewLibTableViewController.h"
#import "BaseViewController.h"
#import "SegmentView.h"

@interface SingleViewLibTableViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) SegmentView *segmentView;
@end

@implementation SingleViewLibTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [self.segmentControl insertSegmentWithTitle:@"One" atIndex:0 animated:NO];
    [self.segmentControl insertSegmentWithTitle:@"Two" atIndex:1 animated:NO];
    self.navigationItem.titleView = self.segmentControl;
    
    self.segmentView = [[SegmentView alloc] initWithItems:@[@"One",@"Two"]];
    self.segmentView.backgroundColor = [UIColor lightGrayColor];
    self.segmentView.frame = CGRectMake(0, 0, 200, 40);
    self.navigationItem.titleView = self.segmentView;
    
    
    
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
    }else if ([segue.identifier isEqualToString:@"gradentNavigationBar"]){
        desVC.viewType = ViewTypeGradientNavigationBar;
    }
}

@end
