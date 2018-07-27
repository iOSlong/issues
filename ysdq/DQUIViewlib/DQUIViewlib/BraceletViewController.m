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

@interface BraceletViewController ()
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
    
    
    
}

- (void)buttonItemClick:(id)item {
    BraceletViewController *vc = [[BraceletViewController alloc] init];
    vc.title = [self.title stringByAppendingString:@"*"];
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
    }
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


@end
