//
//  OPCollectionViewController.m
//  CollectionViewOP
//
//  Created by lxw on 2018/5/9.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "OPCollectionViewController.h"
#import "OPCollectionViewCell.h"
#import "UITableViewController+OP.h"

@interface OPCollectionViewController ()<UICollectionViewDelegateFlowLayout,OPCollectionViewReportProtocol>

@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) NSInteger reloadTimes;
#if !USE_OP_REPORTPROTOCOL
@property (nonatomic, assign) BOOL  reportFilterReduplicativeSwith;//如果是YES，表示有去重机制开启，如果是NO，不进行去重
@property (nonatomic, strong) NSMutableSet *reportIndexPathSet;
#endif
@end

@implementation OPCollectionViewController

static NSString * const reuseIdentifier = @"collectioncellReuseIdentifer";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@界面生成",self.title);

    [self.collectionView registerNib:[UINib nibWithNibName:@"OPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    self.cellCount = 30;
    self.reloadTimes = 1;

#if !USE_OP_REPORTPROTOCOL
    self.reportIndexPathSet = [NSMutableSet set];
#else
    self.opReportDelegate = self;
#endif

    //
    [self.collectionView performBatchUpdates:^{}
                                  completion:^(BOOL finished) {
                                      /// collection-view finished reload
                                      NSLog(@"监听 collectionview完成了reloadData行为！");
                                  }];

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
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)scrollNoAnimationTop:(id)sender {
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    NSLog(@"这个行为暂没有找到移位结束时机的监听！\n");
    //FIXME:可以做延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reportCellsDisplayedWithoutReduplicative];
    });

}
- (IBAction)refreshCollectionView:(id)sender {
    self.reloadTimes ++;
    self.reportFilterReduplicativeSwith = NO;
    [self.reportIndexPathSet removeAllObjects];
    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:^{
    } completion:^(BOOL finished) {
        NSLog(@"监听 collectionview完成了reloadData行为！22");
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor darkGrayColor];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"RT%ld:[%ld,%ld]",(long)self.reloadTimes,(long)indexPath.section,(long)indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50)/3, 100);
    }else{
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 40)/2, 100);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark -
#pragma mark <监听上报相关内容>
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.reportFilterReduplicativeSwith) {
        [self reportCellDisplayedInIndexPath:indexPath];
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
    //self.reportFilterReduplicativeSwith = YES;
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
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForVisibleItems]) {
        if (![self.reportIndexPathSet containsObject:indexPath]) {
            [self reportCellDisplayedInIndexPath:indexPath];
        }
    }
    //去重：上一次曝光过的就不用再上报，所以保留曝光完后界面可见的所有indexPath，用于下一次偏移或滚动的曝光去重。
    if (self.reportFilterReduplicativeSwith) {
        [self.reportIndexPathSet removeAllObjects];
    }
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForVisibleItems]) {
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
- (NSArray<NSIndexPath *> *)reportCellIndexPathForVisibleItems {
    return self.collectionView.indexPathsForVisibleItems;
}
@end
