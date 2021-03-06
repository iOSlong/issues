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
#import <AVFoundation/AVFoundation.h>
#import "AirPlayViewTableViewCell.h"
#import "SJAvatarBrowser/SJAvatarBrowser.h"
#import "FloatRectShadowView.h"
#import "DQCollectionViewFontCell.h"
#import "DQBarcodeManager.h"
#import "Student.h"

@interface BraceletViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BraceletView  *braceletView;
@property (nonatomic, strong) UIView *animationGrandientView;
@property (nonatomic, strong) TBGradientLayerView *animationGradientLayerView;
@property (nonatomic, strong) UIImageView *sdwebImgv;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sourceDataArr;
@property (nonatomic, strong) UILabel *navigationTitleLabel;

@property (nonatomic, strong) Student *myStu;
@property (nonatomic, strong) UILabel *stuInfo;
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
}

- (void)loadTitleView {
    self.navigationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 221, 38)];
    [self.navigationTitleLabel showBorderLine];
    //注意文字格式。
    UIFont *font = [UIFont fontWithName:@"MarkerFelt-Wide" size:19];
    self.navigationTitleLabel.text = [NSString stringWithFormat:@"01234-%@",@"Marker Felt Wide"];
    self.navigationTitleLabel.font = font;

    self.navigationItem.titleView = self.navigationTitleLabel;
}

#pragma mark - UICollectionView
- (void)configureCollectionView {
    [self loadTitleView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing      = 2;
    layout.minimumInteritemSpacing = 2;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate    = self;
    _collectionView.dataSource  = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DQCollectionViewFontCell" bundle:nil] forCellWithReuseIdentifier:@"DQCollectionViewFontCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sourceDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (self.viewType == ViewTypeSystemFontShow) {
        DQCollectionViewFontCell *fontCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DQCollectionViewFontCell" forIndexPath:indexPath];
        fontCell.keyInfo = self.sourceDataArr[indexPath.row];
        cell = fontCell;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewType == ViewTypeSystemFontShow) {
        NSDictionary *keyInfo = self.sourceDataArr[indexPath.row];
        NSString *fontName  = [keyInfo objectForKey:DQFONTNAME];
        NSString *show      = [keyInfo objectForKey:DQTITLESHOW];
        UIFont *font = [UIFont fontWithName:fontName size:19];
        self.navigationTitleLabel.text = [NSString stringWithFormat:@"01234-%@",show];
        self.navigationTitleLabel.font = font;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width * 0.49, 60);
}

#pragma mark - UITableView
- (void)configureTalleView {
    [self loadTitleView];

    CGFloat tableW = 60;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - tableW, 0, tableW, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[AirPlayViewTableViewCell class]  forCellReuseIdentifier:@"AirPlayViewTableViewCell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.width.equalTo(@(60));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AirPlayViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirPlayViewTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"r-%ld",(long)indexPath.row];
    if (indexPath.row == 8 && self.viewType == ViewTypeAirPlayView) {
        AirPlayView *airPV = [[AirPlayView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        [cell addSubview:airPV];
    }else if (indexPath.row == 9){
        [cell setViewModel:nil];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.sdwebImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width * 0.5, self.view.bounds.size.width * 0.5)];
        [self.view addSubview:self.sdwebImgv];
        [self.sdwebImgv sd_setImageWithURL:[NSURL URLWithString:@"http://101.96.131.182:83/group1/M00/00/2C/rBBH-lvFhomAPOxIAAKUABbWw-8289.jpg"]];
    } else if (indexPath.row == 1) {
        [SJAvatarBrowser showImageView:self.sdwebImgv];
    }
}





#pragma mark - ViewTypes
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
    }else if (self.viewType == ViewTypeFloatRectShadowView) {
        [self showViewfloatRectShadowView];
    }else if (self.viewType == ViewTypeSystemFontShow) {
        [self showSystemFonts];
    }else if (self.viewType == ViewTypeSystemKVO) {
        [self showSystemKVO];
    }
    
    else if (self.viewType == ViewTypeBarcodeView) {
        [self showBarcodeView];
    }
}

- (void)showSystemKVO {
    Student *stu = [Student demoStudent];
    self.myStu = stu;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 100)];
    label.textColor = [UIColor redColor];
    label.numberOfLines = 0;
    label.text = [stu description];
    [label showBorderLine];
    self.stuInfo = label;
    [self.view addSubview:label];
    
    UISegmentedControl *segC = [[UISegmentedControl alloc] initWithItems:@[@"name",@"age",@"sex",@"state"]];
    segC.frame = CGRectMake(10, 320, 280, 30);
    [segC showBorderLine];
    [segC addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC];
    
    [self.myStu addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [self.myStu addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    [self.myStu addObserver:self forKeyPath:@"isFemale" options:NSKeyValueObservingOptionNew context:nil];
    [self.myStu addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keyPath :  %@", keyPath);
    NSLog(@"%@ change  :  %@",object, change);
    
    self.stuInfo.text = [self.myStu description];
}

- (void)segmentValueChange:(UISegmentedControl *)segC {
    if (segC.selectedSegmentIndex == 0) {
        self.myStu.name = @[@"name1",@"name2",@"name3",@"name4",@"name5"][arc4random()%5];
    } else if (segC.selectedSegmentIndex == 1) {
        int age[5] = {1,2,3,4,5};
        self.myStu.age = age[arc4random()%5];
    } else if (segC.selectedSegmentIndex == 2) {
        self.myStu.isFemale = arc4random()%2;
    } else if (segC.selectedSegmentIndex == 3) {
        NSInteger state[4] = {LocationCityStateNorth,LocationCityStateSouth,LocationCityStateWest,LocationCityStateEast};
        self.myStu.state = state[arc4random()%4];
    }
    self.stuInfo.text = [self.myStu description];
}

- (void)showBarcodeView {
    self.view.backgroundColor = RGBCOLOR_HEX(0x0e1624);
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 300, 100)];
    parentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:parentView];
    [parentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    [BZXBarcodeManager manageBarcodeViewInFullScreenDetail:parentView];
}

- (void)showSystemFonts {
    NSArray *fonts =  [UIFont familyNames];
    self.sourceDataArr = [NSMutableArray arrayWithCapacity:fonts.count];
    for (int i = 0; i < fonts.count; i ++) {
        NSString *show = [NSString stringWithFormat:@"%d:%@", i, fonts[i]];
        NSDictionary *sourceData = @{DQFONTNAME:fonts[i],
                                     DQTITLESHOW:show
                                     };
        [self.sourceDataArr addObject:sourceData];
    }
    [self configureCollectionView];
}


- (void)showViewfloatRectShadowView {
    FloatRectShadowView *rectShadowView = [[FloatRectShadowView alloc] initWithFrame:CGRectMake(50, 150, 200, 240)];
    [self.view addSubview:rectShadowView];
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
    AirPlayView *airPV = [[AirPlayView alloc] initWithFrame:CGRectMake(10, 400, 300, 50)];
    [airPV showBorderLine];
    [self.view addSubview:airPV];
    
    __weak __typeof(self)weakSelf = self;
    [airPV setTapClick:^(NSInteger index) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (index == 2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf isPresentAirPlayChooseWindow:YES];
            });

        }
    }];
}

#pragma mark
- (BOOL)isPresentAirPlayChooseWindow:(BOOL)isAddTarget {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *w in windows) {
        if([w isKindOfClass:NSClassFromString(@"_MPAVRoutingSheetSecureWindow")]) {
            if(isAddTarget) {
                ///<找到系统的 "取消按钮" 并捕捉事件
                UIView *view = w.subviews.firstObject;
                if([UIDevice currentDevice].systemVersion.floatValue < 11) {
                    [self addTargetForView_iOS10:view];
                }else {
//                    [self addTargetForView_iOS11:view];
                }
            }
            return YES;
        }
    }
    return NO;
}

- (void)addTargetForView_iOS10:(UIView *)view {
    for(UIView *v in view.subviews) {
        if([v isKindOfClass:[UIButton class]]) {
            //找到第一个button
            [((UIButton *)v) addTarget:self action:@selector(airplayChooseViewDismiss:) forControlEvents:UIControlEventTouchUpInside];
        }else if(v.subviews.count > 1 && ![v isKindOfClass:[UIButton class]]) {
            for(UIView *sv in v.subviews) {
                if([sv isKindOfClass:[UIButton class]]) {
                    //2,3号button
                    [((UIButton *)sv) addTarget:self action:@selector(airplayChooseViewDismiss:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
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
    
    
    SASView *shadowButton = [[SASView alloc] initWithFrame:CGRectMake(100, 400, 200, 40)];
//    [shadowButton showBorderLine];
    shadowButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shadowButton];
    shadowButton.layer.cornerRadius = 20;
    shadowButton.layer.shadowColor     = RGBACOLOR_HEX(0x000000, 0.2).CGColor;
    shadowButton.layer.shadowOpacity   = 1;
    shadowButton.layer.shadowRadius    = 7;
    shadowButton.layer.shadowOffset    = CGSizeMake(0.0, 10.0);
    
    CGRect shadowFrame = CGRectMake(100, 0, 100, 40);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:shadowFrame byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:shadowFrame.size];
    shadowButton.layer.shadowPath = maskPath.CGPath;

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
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.animationGradientLayerView.increaseColorRed  = arc4random()%2;
            strongSelf.animationGradientLayerView.showGradientLayer = YES;
        }];
    } else {
            // Fallback on earlier versions
    }
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
