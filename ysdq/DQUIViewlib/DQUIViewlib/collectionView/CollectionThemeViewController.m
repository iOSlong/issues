//
//  CollectionThemeViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/18.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "CollectionThemeViewController.h"
#import "ArrangeCollectionViewCell.h"
#import "ArrangeCollectionViewFlowLayout.h"

@interface CollectionThemeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation CollectionThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor  = [UIColor whiteColor];
    
    self.dataArray = @[@"American",@"two",@"American",@"English",@"India",@"Chinese-man",@"morehelo",@"American university",@"two",@"American",@"English island",@"India-",@"Chinese",@"more"];
    
    [self configureCollectionView];
    
}


#pragma mark - UICollectionView
- (void)configureCollectionView {
    
    ArrangeCollectionViewFlowLayout *layout = [[ArrangeCollectionViewFlowLayout alloc] init];
    
    layout.estimatedItemSize        = CGSizeMake(80, 38);
    layout.minimumLineSpacing       = 20;
    layout.minimumInteritemSpacing  = 8;
    layout.sectionInset             = UIEdgeInsetsMake(10, 10, 10, 10);
//    layout.arrangeAlignment         = ArrangeAlignmentCenter;
    

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate    = self;
    _collectionView.dataSource  = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ArrangeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ArrangeCollectionViewCell class])];
    [_collectionView showBorderLine];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArrangeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArrangeCollectionViewCell" forIndexPath:indexPath];
    NSString *title = self.dataArray[indexPath.row];
    cell.titleLabel.text = title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.view.bounds.size.width * 0.49, 60);
//}
@end
