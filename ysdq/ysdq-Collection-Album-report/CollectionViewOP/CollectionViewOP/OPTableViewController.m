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
#if !USE_OP_REPORTPROTOCOL
@property (nonatomic, assign) BOOL  reportFilterReduplicativeSwith;//如果是YES，表示有去重机制开启，如果是NO，不进行去重
@property (nonatomic, strong) NSMutableSet *reportIndexPathSet;//去重IndexPath容器
#endif

@property (nonatomic, assign) BOOL  havAllCellDisplayOverMark;//


@end

@implementation OPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@界面生成",self.title);
    
    self.cellCount = 20;
#if !USE_OP_REPORTPROTOCOL
    self.reportIndexPathSet = [NSMutableSet set];
#else
    self.opReportDelegate = self;
#endif
    
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
    self.havAllCellDisplayOverMark  = NO;
    [self.reportIndexPathSet removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"section-[%@]",@(section)];
}

#pragma mark -
#pragma mark <监听上报相关内容>
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.reportFilterReduplicativeSwith) {
        [self reportCellDisplayedInIndexPath:indexPath];
    }
    if (indexPath.row == [[self.tableView indexPathsForVisibleRows] lastObject].row) {
        if (!self.havAllCellDisplayOverMark) {
            self.havAllCellDisplayOverMark = YES;
            NSLog(@"tableview所有的Cell均完成展示，可以用于标记界面内容展示完毕监听");
            //MARK:每一次页面活动之后lastIndexPath变更都会走入此判断，所以log中描述应用于首次走入判断时候(也就是标志界面第一次展示完成)。
            self.reportFilterReduplicativeSwith = YES;
        }
    }
}
#if !USE_OP_REPORTPROTOCOL
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.reportFilterReduplicativeSwith = YES;
    //FIXME:存在漏洞-如果页面的移位不是通过手指拖拽，那么reportFilterReduplicativeSwith开关将没有机会设置为YES。
    //TODO:规避方案（在页面移位的方法譬如此例子scrollNoAnimationTop直接操作开关）
    //MARK:这个开关操作时机还可以放在scrollViewDidEndDragging:方法的最开始。
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //self.reportFilterReduplicativeSwith = YES;如此可以舍弃scrollViewWillBeginDragging。
    if (!decelerate) {
        NSLog(@"滚动抬起手指没有减速惯性停止监听");
        [self reportCellsDisplayedWithoutReduplicative];
    }else{
        NSLog(@"滚动抬起手指有减速惯性，依赖scrollViewDidEndDecelerating：监听停止");
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"滚动抬起手指有减速惯性停止监听");
    [self reportCellsDisplayedWithoutReduplicative];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"非手指动画滚动停止监听");
    [self reportCellsDisplayedWithoutReduplicative];
    //FIXME:存在漏洞-若设置页面setContentOffset时候没有添加动画，那么移位后没有监听。
    //TODO:规避方案（可以通过setContentOffset使用animation：YES）
}
#endif


#pragma mark 上报及上报去重机制处理
- (void)reportCellsDisplayedWithoutReduplicative {
    NSLog(@"--------时机性进行去重判断上报\n\n");
    for (NSIndexPath *indexPath in [self.tableView indexPathsForVisibleRows]) {
        if (![self.reportIndexPathSet containsObject:indexPath]) {
            [self reportCellDisplayedInIndexPath:indexPath];
        }
    }
    //去重：上一次曝光过的就不用再上报，所以保留曝光完后界面可见的所有indexPath，用于下一次偏移或滚动的曝光去重。
    if (self.reportFilterReduplicativeSwith) {
        [self.reportIndexPathSet removeAllObjects];
    }
    for (NSIndexPath *indexPath in [self.tableView indexPathsForVisibleRows]) {
        [self.reportIndexPathSet addObject:[indexPath copy]];
    }
}

- (void)reportCellDisplayedInIndexPath:(NSIndexPath *)indexPath {
        if ([self.reportIndexPathSet containsObject:indexPath]) {
            return;
        } else {
            [self.reportIndexPathSet addObject:[indexPath copy]];
        }
    NSLog(@"%@reportItem:----%@---",self.title,[NSString stringWithFormat:@"[%ld,%ld]",(long)indexPath.section,(long)indexPath.row]);
}

@end


















