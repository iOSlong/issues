//
//  CollectionViewListMultiItemCell.m
//  DQUIViewlib
//
//  Created by lxw on 2019/2/21.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "CollectionViewListMultiItemCell.h"
#import "CollectionViewListCommonCell.h"
#import "ArrangeCollectionViewFlowLayout.h"
#import "ArrangeCollectionViewCell.h"

@interface CollectionViewListMultiItemCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation CollectionViewListMultiItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = @[@"就0",@"就是1",@"就是测2",@"就是测试3",@"就是测试4",@"就是测5",@"就是6",@"就7",@"就是测试8",@"就0来一条特别长的记录看看效果",@"就是1",@"就是测2",@"就是测试再9",@"就是测试10",@"就是测试"];
        [self configureCollectionViews];
    }
    return self;
}

- (void)configureCollectionViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing      = 10;
    layout.minimumInteritemSpacing = 10;
    layout.estimatedItemSize        = CGSizeMake(80, 30);

    
//    ArrangeCollectionViewFlowLayout *layout = [[ArrangeCollectionViewFlowLayout alloc] init];
//    layout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing      = 10;
//    layout.minimumInteritemSpacing = 10;
//    layout.arrangeAlignment        = ArrangeAlignmentLeft;
//    layout.estimatedItemSize        = CGSizeMake(80, 30);

    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate        = self;
    _collectionView.dataSource      = self;
    [_collectionView registerClass:[ArrangeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ArrangeCollectionViewCell class])];
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArrangeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArrangeCollectionViewCell" forIndexPath:indexPath];
    NSString *title = self.dataArray[indexPath.row];
    cell.titleLabel.text = title;
    return cell;
}
@end
