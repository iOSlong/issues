//
//  APIControlViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/10/10.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "APIControlViewController.h"
#import "ReversalAnimationView.h"
#import "AnimationViewTextFieldBar/AnimationViewTextFieldBar.h"
#import "edgeBorderView/EdgeBorderView.h"

@interface APIControlViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic, strong) ReversalAnimationView *reversalAnimationView;
@property (nonatomic, strong) UIView<ApiControlEnable> *controllView;
@property (nonatomic, strong) EdgeBorderView *borderView;
@end

@implementation APIControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.controllView callMethodIndex:10];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.viewType == ViewTypeReversalAnimationView) {
        [self showViewTypeReversalAnimationView];
    } else if (self.viewType == ViewTypeAnimationFieldBar) {
        [self showViewTypeAnimationFieldBar];
    } else if (self.viewType == ViewTypeEdgeBorderView) {
        [self showViewTypeEdgeborderView];
    }
    [self.tableView reloadData];
}

- (void)showViewTypeEdgeborderView {
    self.dataArray = [NSMutableArray arrayWithArray:@[@"None",@"Top",@"Left",@"Bottom",@"Right",@"Top|Left",@"Top|Bottom",@"All"]];
    EdgeBorderView *borderView = [[EdgeBorderView alloc] initWithFrame:CGRectMake(20, 100, 50, 50)];
    self.borderView = borderView;
    [borderView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.equalTo(@50);
    }];
}

- (void)showViewTypeAnimationFieldBar {
    self.dataArray = [NSMutableArray arrayWithArray:@[@"ratatonHidden",@"ratatonShow",@"animPause",@"animResume"]];
    AnimationViewTextFieldBar *fieldBar = [[AnimationViewTextFieldBar alloc] init];
    [self.view addSubview:fieldBar];
    [fieldBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.equalTo(@40);
    }];
    self.controllView = fieldBar;
    
    [fieldBar textfiledBecomeFirstResponder];
}

- (void)showViewTypeReversalAnimationView {
    self.dataArray = [NSMutableArray arrayWithArray:@[@"backOrigin",@"rotation2D",@"rotation3D",@"2DWabble",@"3DWabble",@"抖动+旋转动画组",@"Transform3DMakeScale"]];
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.reversalAnimationView textfieldFist];
    [self.reversalAnimationView callMethodIndex:5];
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
    if (self.viewType == ViewTypeAnimationFieldBar) {
        [self.controllView callMethodIndex:indexPath.row];
    } else if (self.viewType == ViewTypeReversalAnimationView) {
        [self.reversalAnimationView callMethodIndex:indexPath.row];
    }else if (self.viewType == ViewTypeEdgeBorderView) {
        [self.borderView callMethodIndex:indexPath.row];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:self.view];
    if (point.x < self.view.bounds.size.width * 0.1) {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (point.y < self.view.bounds.size.height * 0.4){
        [self.view endEditing:YES];
    }
}

@end
