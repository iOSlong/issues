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
#import "SelfNavigationBarViewController.h"
#import "DQNavigationController.h"
#import "NavigationControllerListViewController.h"
#import "NavBarShowHiddenViewController.h"

@interface SingleViewLibTableViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) SegmentView *segmentView;
@end

@implementation SingleViewLibTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self dosomethingHightCPUUSAGE1];

    [[BLStopwatch sharedStopwatch] splitWithType:BLStopwatchSplitTypeContinuous description:WATCH_VIEWDIDLOAD0];

    self.segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [self.segmentControl insertSegmentWithTitle:@"One" atIndex:0 animated:NO];
    [self.segmentControl insertSegmentWithTitle:@"Two" atIndex:1 animated:NO];
    self.navigationItem.titleView = self.segmentControl;
    
    self.segmentView = [[SegmentView alloc] initWithItems:@[@"One",@"Two"]];
    self.segmentView.backgroundColor = [UIColor lightGrayColor];
    self.segmentView.frame = CGRectMake(0, 0, 200, 40);
    self.navigationItem.titleView = self.segmentView;
    
    [[BLStopwatch sharedStopwatch] splitWithType:BLStopwatchSplitTypeContinuous description:WATCH_VIEWDIDLOAD1];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self dosomethingHightCPUUSAGE2];
//    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self dosomethingHightCPUUSAGE3];
    });
    
}

- (void)dosomethingHightCPUUSAGE1 {
    sleep(1);
    for (int i = 0; i < 100 ; i ++) {
        NSLog(@"----%@",[NSNumber numberWithInt:i]);
        for (int j = 0; j < 200 ; j ++) {
            NSLog(@"======%@",[NSNumber numberWithInt:j]);
        }
    }
}

- (void)dosomethingHightCPUUSAGE3 {
    for (int i = 100; i < 200 ; i ++) {
        NSLog(@"----%@",[NSNumber numberWithInt:i]);
        for (int j = 300; j < 600 ; j ++) {
            NSLog(@"======%@",[NSNumber numberWithInt:j]);
        }
    }
    
}

- (void)dosomethingHightCPUUSAGE2 {
    for (int i = 0; i < 100 ; i ++) {
        NSLog(@"----%@",[NSNumber numberWithInt:i]);
        for (int j = 0; j < 300 ; j ++) {
            NSLog(@"======%@",[NSNumber numberWithInt:j]);
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BLStopwatch sharedStopwatch] splitWithType:BLStopwatchSplitTypeContinuous description:WATCH_VIEWDIDAPPEAR];
    [[BLStopwatch sharedStopwatch] stopAndPresentResultsThenReset];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            NavigationControllerListViewController *nbvc = [[NavigationControllerListViewController alloc] init];
            DQNavigationController *nav = [[DQNavigationController alloc] initWithRootViewController:nbvc];
            [self presentViewController:nav animated:YES completion:nil];
        }else if (indexPath.row == 3) {
            NavBarShowHiddenViewController *nbshVC = [NavBarShowHiddenViewController new];
            nbshVC.title = @"title";
            [self.navigationController pushViewController:nbshVC animated:YES];
        }
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BaseViewController *desVC = segue.destinationViewController;
    desVC.title = @"子页面";
    if ([segue.identifier isEqualToString:@"Bracelet"]) {
        desVC.viewType = ViewTypeBracelet;
    }else if ([segue.identifier isEqualToString:@"GradientAnimation"]) {
        desVC.viewType = ViewTypeGradientAnimation;
    }else if ([segue.identifier isEqualToString:@"GradientLayer"]) {
        desVC.viewType = ViewTypeGradientLayer;
    }else if ([segue.identifier isEqualToString:@"gradentNavigationBar"]){
        desVC.viewType = ViewTypeGradientNavigationBar;
    }else if ([segue.identifier isEqualToString:@"LayerImage"]){
        desVC.viewType = ViewTypeLayerImage;
    }else if ([segue.identifier isEqualToString:@"RoundButton"]) {
        desVC.viewType = ViewTypeRoundButton;
    }else if ([segue.identifier isEqualToString:@"BezierPathView"]){
        desVC.viewType = ViewTypeBezierPath;
    }else if ([segue.identifier isEqualToString:@"ControlView"]) {
        desVC.viewType = ViewTypeControlView;
    }else if ([segue.identifier isEqualToString:@"AirPlayView"]){
        desVC.viewType = ViewTypeAirPlayView;
    }else if ([segue.identifier isEqualToString:@"ApostropheAnimationView"]){
        desVC.viewType = ViewTypeApostropheAnimationView;
    }else if ([segue.identifier isEqualToString:@"ReversalAnimationView"]) {
        desVC.viewType = ViewTypeReversalAnimationView;
    }else if ([segue.identifier isEqualToString:@"ViewTypeAnimationFieldBar"]) {
        desVC.viewType = ViewTypeAnimationFieldBar;
    }else if ([segue.identifier isEqualToString:@"ViewTypeFloatRectShadowView"]) {
        desVC.viewType = ViewTypeFloatRectShadowView;
    } else if ([segue.identifier isEqualToString:@"ViewTypeSystemFontShow"]) {
        desVC.viewType = ViewTypeSystemFontShow;
    }
}

@end
