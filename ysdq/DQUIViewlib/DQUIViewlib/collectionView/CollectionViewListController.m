//
//  CollectionViewListController.m
//  DQUIViewlib
//
//  Created by lxw on 2019/2/21.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "CollectionViewListController.h"
#import "CollectionViewListCommonCell.h"
#import "CollectionViewListMultiItemCell.h"


@interface CollectionViewListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation CollectionViewListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor  = [UIColor whiteColor];
    
    self.dataArray = @[@[@"CollectionThemeViewController",@"other"],@[@"MultiItemCells"]];
    
    [self configureCollectionView];
}

#pragma mark - UICollectionView
- (void)configureCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing      = 12;
    layout.minimumInteritemSpacing = 12;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, 60);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate        = self;
    _collectionView.dataSource      = self;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_collectionView registerClass:[CollectionViewListCommonCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewListCommonCell class])];
    [_collectionView registerClass:[CollectionViewListMultiItemCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewListMultiItemCell class])];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];

}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
    CollectionViewListCommonCell *commonCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewListCommonCell" forIndexPath:indexPath];
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
        commonCell.titleLabel.text = title;
        cell = commonCell;
    }else if (indexPath.section == 1) {
        CollectionViewListMultiItemCell *multiItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewListMultiItemCell" forIndexPath:indexPath];
        cell = multiItemCell;
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = self.dataArray[indexPath.section][indexPath.row];
    UIViewController *desVc = [NSClassFromString(vcName) new];
    if (desVc) {
        desVc.title = vcName;
        [self.navigationController pushViewController:desVc animated:YES];
    }
}

@end
