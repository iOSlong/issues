//
//  OPTableViewController.m
//  CollectionViewOP
//
//  Created by lxw on 2018/5/9.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "OPTableViewController.h"
#import "UITableViewController+OP.h"

@interface OPTableViewController ()<OPCollectionViewReportProtocol>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) NSInteger reloadTimes;

@end

@implementation OPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@界面生成",self.title);
    
    self.cellCount = 20;
    self.opReportDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.needReportWhenViewAppear) {
        [self reportCellsDisplayedWithoutReduplicative];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@界面消失，考虑回来是否要再进行曝光上报。",self.title);
    if (self.needReportWhenViewAppear) {
        [self.reportIndexPathSet removeAllObjects];
    }
}



- (IBAction)scrollAnimationTop:(id)sender {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)scrollNoAnimationTop:(id)sender {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    NSLog(@"这个行为暂没有找到移位结束时机的监听！\n");
    //FIXME:可以做延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reportCellsDisplayedWithoutReduplicative];
    });
}
- (IBAction)refreshTableView:(id)sender {
    self.reloadTimes ++;
    self.reportFilterReduplicativeSwith   = NO;
    [self.reportIndexPathSet removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OPtableViewCellReuseIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"RT%ld:indexPath[%ld,%ld]",self.reloadTimes,(long)indexPath.section,(long)indexPath.row];
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor darkGrayColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 168;
}


#pragma mark -
#pragma mark <监听上报相关内容>
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self reportCellDisplayedIndexPath:indexPath];
}

#pragma mark OPCollectionViewReportProtocol
- (NSArray<NSIndexPath *> *)reportCellIndexPathForVisibleItems {
    return self.tableView.indexPathsForVisibleRows;
}

- (void)reportCellHaudleForIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@reportItem:----%@---",self.title,[NSString stringWithFormat:@"[%ld,%ld]",(long)indexPath.section,(long)indexPath.row]);
}
@end


















