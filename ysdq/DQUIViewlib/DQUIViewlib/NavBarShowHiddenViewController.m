//
//  NavBarShowHiddenViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/24.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "NavBarShowHiddenViewController.h"

@interface NavBarShowHiddenViewController ()
@property (nonatomic, strong) UIView *viewSegments;
@property (nonatomic, strong) NavBarShowHiddenViewController *subVC;
@end

@implementation NavBarShowHiddenViewController

- (void)dealloc {
    NSLog(@"dealloc ……");
}

- (UIButton *)navigationPushButton {
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    pushButton.layer.borderColor    = [UIColor blueColor].CGColor;
    pushButton.layer.borderWidth    = 2;
    pushButton.layer.cornerRadius   = 10;
    return pushButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navAnimation = YES;
    
    UIButton *pushButton = [self navigationPushButton];
    [pushButton setTitle:@"pushVC" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
    
    UIButton *popButton = [self navigationPushButton];
    [popButton setTitle:@"popVC" forState:UIControlStateNormal];
    popButton.tag = 100;
    [popButton addTarget:self action:@selector(pushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popButton];
    [pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.height.equalTo(@70);
    }];
    [popButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.width.equalTo(pushButton.mas_width);
        make.left.equalTo(pushButton.mas_right);
        make.height.equalTo(@70);
    }];

    
    
    self.viewSegments = [[UIView alloc] initWithFrame:CGRectZero];
    self.viewSegments.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_viewSegments];
    [self.viewSegments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(pushButton.mas_top).offset(-10);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 80)];
    label.text = @"上 - subView， 下 - selfView， 红色：show， 黑色：hidden ";
    [self.viewSegments addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewSegments);
        make.top.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    UISegmentedControl *showSegment = [[UISegmentedControl alloc] initWithItems:@[@"None",@"DidLoad",@"WillAppear",@"DidAppear",@"WillDisappear",@"DidDisappear"]];
    UISegmentedControl *hiddenSegment = [[UISegmentedControl alloc] initWithItems:@[@"None",@"DidLoad",@"WillAppear",@"DidAppear",@"WillDisappear",@"DidDisappear"]];
    UISegmentedControl *subShowSegment = [[UISegmentedControl alloc] initWithItems:@[@"None",@"DidLoad",@"WillAppear",@"DidAppear",@"WillDisappear",@"DidDisappear"]];
    UISegmentedControl *subHiddenSegment = [[UISegmentedControl alloc] initWithItems:@[@"None",@"DidLoad",@"WillAppear",@"DidAppear",@"WillDisappear",@"DidDisappear"]];
    
    [self.viewSegments addSubview:showSegment];
    [self.viewSegments addSubview:hiddenSegment];
    [self.viewSegments addSubview:subShowSegment];
    [self.viewSegments addSubview:subHiddenSegment];
    showSegment.tintColor =  subShowSegment.tintColor = [UIColor redColor];
    subHiddenSegment.tintColor = hiddenSegment.tintColor = [UIColor blackColor];


    [showSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.viewSegments);
        make.height.equalTo(@30);
    }];
    [hiddenSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewSegments);
        make.height.equalTo(@30);
        make.bottom.equalTo(showSegment.mas_top).offset(-10);
    }];
    [subShowSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewSegments);
        make.height.equalTo(@30);
        make.bottom.equalTo(hiddenSegment.mas_top).offset(-50);
    }];
    [subHiddenSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewSegments);
        make.height.equalTo(@30);
        make.bottom.equalTo(subShowSegment.mas_top).offset(-10);
    }];
    
    
    showSegment.tag = 10;
    hiddenSegment.tag = 20;
    subShowSegment.tag = 30;
    subHiddenSegment.tag = 40;
    [showSegment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [hiddenSegment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [subShowSegment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [subHiddenSegment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];

    
    NavBarShowHiddenViewController *vc = [[NavBarShowHiddenViewController alloc] init];
    vc.title = [self.title stringByAppendingString:@"* "];
    self.subVC = vc;
    
    [self barTime:NaviBarTimeViewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self barTime:NaviBarTimeViewWillAppear];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self barTime:NaviBarTimeViewDidAppear];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self barTime:NaviBarTimeViewWillDisappear];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self barTime:NaviBarTimeViewDidDisappear];
}

- (void)segmentValueChange:(UISegmentedControl *)segment {
    if (segment.tag == 10) {
        self.navShowTime = segment.selectedSegmentIndex;
    }else if (segment.tag == 20) {
        self.navHiddenTime = segment.selectedSegmentIndex;
    }else if (segment.tag == 30) {
        self.subVC.navShowTime = segment.selectedSegmentIndex;
    }else if (segment.tag == 40) {
        self.subVC.navHiddenTime = segment.selectedSegmentIndex;
    }
}

- (void)pushButtonClick:(UIView *)sender {
    if (sender.tag == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController pushViewController:self.subVC animated:YES];
    }
}

- (void)barTime:(NaviBarTime)barTime {
    if (self.navShowTime == barTime) {
        [self barChangeStateHidden:NO];
    }
    if (self.navHiddenTime == barTime) {
        [self barChangeStateHidden:YES];
    }
}
- (void)barChangeStateHidden:(BOOL)hidden {
    [self.navigationController setNavigationBarHidden:hidden animated:self.navAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self barChangeStateHidden:NO];
}

@end
