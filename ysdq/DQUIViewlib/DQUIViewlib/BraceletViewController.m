//
//  BraceletViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "BraceletViewController.h"
#import "BraceletView.h"
#import "TBGradientLayerView.h"
#import "GradientLayerView.h"
#import "RoundButton.h"
#import "BezierPathView.h"
#import "ControlView.h"
#import "AirPlayView.h"
#import "AppDelegate.h"
#import "ApostropheAnimationView.h"
#import "ReversalAnimationView.h"

@interface BraceletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BraceletView  *braceletView;
@property (nonatomic, strong) UIView *animationGrandientView;
@property (nonatomic, strong) TBGradientLayerView *animationGradientLayerView;
@end

@implementation BraceletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemClick:)];
    self.navigationItem.rightBarButtonItem = barItem;
    BOOL barHidden = self.navigationController.navigationBar.hidden;
    NSLog(@"%d",barHidden);
    
    
    if (self.viewType == ViewTypeFloatButton) {
        [self loadManaymanayThings];
        [self showFloatButton];
    }
    
    CGFloat tableW = 60;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - tableW, 0, tableW, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"r-%ld",(long)indexPath.row];
    return cell;
}





- (void)loadManaymanayThings {
    int countX = self.view.frame.size.width / 10;
    for (int i = 0; i < 20000; i ++ ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake((i%countX) * 10, (i / countX + 1) * 10, 50, 50);
        button.layer.borderColor = [UIColor redColor].CGColor;
        button.layer.borderWidth = 1;
        float colorR  =  arc4random()%255;
        float colorG  =  arc4random()%255;
        float colorB  =  arc4random()%255;
        float alpha   =  (arc4random()%155 + 100) / 255.0;
        button.backgroundColor = RGBACOLOR(colorR, colorG, colorB, alpha);
        [self.view addSubview:button];
    }
}

- (void)buttonItemClick:(id)item {
    BraceletViewController *vc = [[BraceletViewController alloc] init];
    vc.title = [self.title stringByAppendingString:@"*"];
    vc.viewType = ViewTypeFloatButton;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.viewType == ViewTypeBracelet) {
        [self showBraeletView];
    } else if(self.viewType == ViewTypeGradientLayer){
        [self showGradientLayerView];
    } else if (self.viewType == ViewTypeGradientAnimation) {
        [self showGradientAnimationView];
    } else if (self.viewType == ViewTypeGradientNavigationBar) {
        [self showGradientNavigationBar];
    }else if (self.viewType == ViewTypeLayerImage) {
        [self showLayerImage];
    }else if (self.viewType == ViewTypeRoundButton) {
        [self showRoundButton];
    }else if (self.viewType == ViewTypeBezierPath) {
        [self showBezirPathView];
    }else if (self.viewType == ViewTypeControlView) {
        [self showControlView];
    }else if (self.viewType == ViewTypeAirPlayView) {
        [self showAirPlayView];
    }else if (self.viewType == ViewTypeApostropheAnimationView) {
        [self showApostropheAnimationView];
    }
}



- (void)showApostropheAnimationView {
    ApostropheAnimationView *apostropheV = [[ApostropheAnimationView alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    [self.view addSubview:apostropheV];
    
    BOOL noen = apostropheV.isTestBoolValue;
    noen = apostropheV.testBoolValue;
    apostropheV.testBoolValue = YES;
    noen = apostropheV.isTestBoolValue;
    noen = apostropheV.testBoolValue;
    noen = NO;
}

- (void)showAirPlayView {
    AirPlayView *airPV = [[AirPlayView alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    [airPV showBorderLine];
    [self.view addSubview:airPV];
}

- (void)showControlView {
    ControlView *conV =  [[ControlView alloc] initWithFrame:CGRectMake(100, 200, 200, 30)];
    [conV setTitle:@"试试正常效果" forState:UIControlStateNormal];
    [conV setTitle:@"试试高亮" forState:UIControlStateHighlighted];
    [conV setTitle:@"试试选中效果" forState:UIControlStateSelected];
    [conV showBorderLine];
    [self.view addSubview:conV];
}

- (void)showBezirPathView {
    self.view.backgroundColor = [UIColor blackColor];
    
    BezierPathView *bezierPV1 = [[BezierPathView alloc] initWithFrame:CGRectMake(50, 100, self.view.bounds.size.width - 100, 100)];
    [self.view addSubview:bezierPV1];

    [bezierPV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.top.equalTo(@70);
        make.height.equalTo(@140);
    }];
    
    CGFloat viewW = self.view.bounds.size.width - 100;
    BezierPathView *bezierPV2 = [[BezierPathView alloc] initWithFrame:CGRectMake(50, 250, viewW, viewW)];

    [bezierPV1 showBorderLine];
    [bezierPV2 showBorderLine];
    [self.view addSubview:bezierPV2];
    
    
    UIImage *image = imageFromLayer(bezierPV1.layer);
    UIImageView *imgv = [[UIImageView alloc] initWithImage:image];
    imgv.frame = CGRectMake(50, 200, CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
    [self.view addSubview:imgv];
    [imgv showBorderLine];
    
}

- (void)showFloatButton {
    UIView *floatView = [[UIApplication sharedApplication].delegate.window viewDesTag:999];
    if (!floatView) {
        RoundButton *floatButton = [RoundButton buttonWithType:UIButtonTypeCustom];
        floatButton.frame = CGRectMake(200, 200, 50, 50);
        floatButton.layer.borderWidth = 5;
        floatButton.layer.cornerRadius = 10;
        floatButton.tag = 999;
        [floatButton showBorderLine];
        [floatButton setTitle:@"Drag" forState:UIControlStateNormal];
        UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
        [keyWindow addSubview:floatButton];
        UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:floatButton action:@selector(_pan:)];
        panG.minimumNumberOfTouches = 1;
        panG.maximumNumberOfTouches = 1;
        [floatButton addGestureRecognizer:panG];
        [floatButton addHoldMethod];
    }
    ((AppDelegate *)[UIApplication sharedApplication].delegate).holdVC = self;
}



- (void)showRoundButton {
//    1.
    RoundButton *rbtn1 = [RoundButton roundButtonFrame:CGRectMake(100, 100, 200, 40) style:RoundButtonStyleCornerGray];
    [self.view addSubview:rbtn1];
    
    
    RoundButton *rbtn2 = [RoundButton roundButtonFrame:CGRectMake(100, 160, 200, 40) style:RoundButtonStyleCornerLeft];
    [self.view addSubview:rbtn2];

    
    RoundButton *rbtn3 = [RoundButton roundButtonFrame:CGRectMake(100, 220, 200, 40) style:RoundButtonStyleCornerRight];
    [self.view addSubview:rbtn3];
    
    
    RoundButton *rbtn4 = [RoundButton roundButtonFrame:CGRectMake(100, 280, 200, 40) style:RoundButtonStyleCornerNone];
    [self.view addSubview:rbtn4];

    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 340, 50, 50)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [indicatorView showBorderLine];
    indicatorView.color = [UIColor redColor];
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
}

//UIImage *imageFromLayer(CALayer *layer) {
//    UIGraphicsBeginImageContext(layer.frame.size);
//    [layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    return image;
//}
- (void)showLayerImage {
    self.view.backgroundColor = RGBCOLOR_HEX(0x19A8F0);
    UIImageView *layerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 250, 32)];
    layerImageView.layer.cornerRadius = 16;
    layerImageView.layer.borderWidth = 1;
    layerImageView.layer.borderColor = RGBCOLOR_HEX(0x2A95F7).CGColor;
    layerImageView.layer.backgroundColor = RGBACOLOR_HEX(0xffffff, 0.3).CGColor;
    [self.view addSubview:layerImageView];

    CALayer *layer = [[CALayer alloc] init];
    layer.frame = layerImageView.bounds;
    layer.backgroundColor = RGBACOLOR_HEX(0xffffff, 0.3).CGColor;
    UIImage *image = imageFromLayer(layer);
//    layerImageView.image = image;
    
    
    
    
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, layerImageView.bounds.size.width, layerImageView.bounds.size.height)];
    [self.view addSubview:field];
    field.layer.cornerRadius = layerImageView.bounds.size.height * 0.5;
    field.background   = image;
    field.layer.borderWidth = 0.5f;
    //        field.layer.backgroundColor = COLOR_HEXA(0xffffff, 0.3).CGColor;//searchTextFiledBackgroudColor().CGColor;
    //    field.layer.borderColor =  RGBCOLOR_HEX(0x2A95F7).CGColor;

    
}

- (void)showGradientNavigationBar {
    UIImage *image = [GradientLayerView gradientLayerNavigationImage];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)showGradientLayerView {
    GradientLayerView *glvNav = [GradientLayerView gradientLayerNavigationBar];
    glvNav.frame = CGRectMake(0, 200, glvNav.frame.size.width, glvNav.frame.size.height);
    glvNav.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:glvNav];
    
    GradientLayerView *glv2 = [[GradientLayerView alloc] initWithFrame:CGRectMake(0, 0, glvNav.frame.size.width, glvNav.frame.size.height) directionLandscape:NO colorStar:[UIColor redColor] colorEnd:[UIColor blackColor]];
//    GradientLayerView *glv2 = [[GradientLayerView alloc] initWithFrame:glvNav.bounds];
    glv2.frame = CGRectMake(0, 300, glvNav.frame.size.width, glvNav.frame.size.height);
    glv2.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:glv2];

    UIImage *image = [GradientLayerView gradientLayerNavigationImage];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 360, glvNav.frame.size.width - 10, glvNav.frame.size.height)];
    [imageV setImage:image];
    [self.view addSubview:imageV];
}

- (void)showGradientAnimationView {
    CGSize showSize = self.view.bounds.size;
    self.animationGrandientView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, showSize.width, 80)];
    self.animationGrandientView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.animationGrandientView];
    
    self.animationGradientLayerView = [[TBGradientLayerView alloc] initWithFrame:CGRectMake(105, 0, showSize.width - 100, 80)];
    [self.animationGrandientView addSubview:self.animationGradientLayerView];
    
    __weak __typeof(self)weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.animationGradientLayerView.increaseColorRed  = arc4random()%2;
        strongSelf.animationGradientLayerView.showGradientLayer = YES;
    }];
}


- (void)showBraeletView {
    self.braceletView = [[BraceletView alloc] initWithFrame:[self showFrameBracelet]];
    self.braceletView.backgroundColor = [UIColor yellowColor];
    [self.braceletView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.braceletView setTitle:@"2" forState:UIControlStateNormal];
    [self.braceletView.titleLabel setFont:[UIFont boldSystemFontOfSize:50]];
    [self.view addSubview:self.braceletView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.braceletView setColorShow:[UIColor purpleColor]];
    });
    self.braceletView = [[BraceletView alloc] initWithFrame:[self showFrameBracelet]];
    self.braceletView.backgroundColor = [UIColor yellowColor];
    [self.braceletView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.braceletView setTitle:@"2" forState:UIControlStateNormal];
    [self.braceletView.titleLabel setFont:[UIFont boldSystemFontOfSize:50]];
    [self.view addSubview:self.braceletView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.braceletView setColorShow:[UIColor purpleColor]];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:self.view];
    if (point.y > self.view.bounds.size.height * 0.7) {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self.view endEditing:YES];
    }
}

@end
