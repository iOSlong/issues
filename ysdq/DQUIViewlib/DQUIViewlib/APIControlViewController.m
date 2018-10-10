//
//  APIControlViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/10/10.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "APIControlViewController.h"
#import "ReversalAnimationView.h"


@interface APIControlViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic, strong) ReversalAnimationView *reversalAnimationView;
@end

@implementation APIControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.viewType == ViewTypeReversalAnimationView) {
        [self showViewTypeReversalAnimationView];
    }
    [self.tableView reloadData];
}

- (void)showViewTypeReversalAnimationView {
    self.dataArray = [NSMutableArray arrayWithArray:@[@"backOrigin",@"rotation2D",@"rotation3D",@"2Dwabble",@"3D抖动",@"抖动+旋转动画组"]];
    
    ReversalAnimationView *reversalAV = [[ReversalAnimationView alloc] initWithFrame:CGRectMake(20, 100, 340, 320)];
    [self.view addSubview:reversalAV];
    [reversalAV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tableView.mas_top).offset(-4);
        make.top.equalTo(self.view.mas_top).offset(64);
    }];
    [reversalAV showBorderLineColor:[UIColor purpleColor]];
    self.reversalAnimationView = reversalAV;
}


#pragma mark - Table Control list
- (void)setupTable {
    CGFloat view_W = self.view.bounds.size.width;
    CGFloat view_H = self.view.bounds.size.height;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(view_W * 0.5, view_H * 0.5, view_W * 0.5, view_H * 0.5) style:UITableViewStyleGrouped];
    _tableView.dataSource   = self;
    _tableView.delegate     = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell01"];
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell01" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.reversalAnimationView callMethodIndex:indexPath.row];
}

@end
