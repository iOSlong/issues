//
//  StaticTableViewController.m
//  CollectionViewOP
//
//  Created by lxw on 2018/5/9.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "StaticTableViewController.h"
#import "OPCollectionViewController.h"
#import "OPTableViewController.h"
#import "OPPageViewController.h"

@interface StaticTableViewController ()

@end

@implementation StaticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@",segue);
    BOOL needReportWhenViewAppear = NO;
    NSString *pageViewControllerDes = nil;
    if ([segue.identifier isEqualToString:@"needReportWhenViewAppear"]) {
        needReportWhenViewAppear = YES;
    }else if ([segue.identifier isEqualToString:@"showPageViewControllerCollectionView"]) {
        pageViewControllerDes = @"UICollectionViewController";
    }else if ([segue.identifier isEqualToString:@"showPageViewControllerTableView"]) {
        pageViewControllerDes = @"UITableViewController";
    }
    if ([segue.destinationViewController isKindOfClass:[OPCollectionViewController class]]) {
        OPCollectionViewController *collectionVC = segue.destinationViewController;
        collectionVC.needReportWhenViewAppear = needReportWhenViewAppear;
    }else if ([segue.destinationViewController isKindOfClass:[OPTableViewController class]]) {
        OPTableViewController *collectionVC = segue.destinationViewController;
        collectionVC.needReportWhenViewAppear = needReportWhenViewAppear;
    }else if ([segue.destinationViewController isKindOfClass:[OPPageViewController class]]) {
        OPPageViewController *controllerVC = segue.destinationViewController;
        controllerVC.viewControllerStoryBoardID = pageViewControllerDes;
    }

}


@end
