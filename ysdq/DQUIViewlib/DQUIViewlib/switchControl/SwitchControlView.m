//
//  SwitchControlView.m
//  DQUIViewlib
//
//  Created by lxw on 2019/4/20.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "SwitchControlView.h"
#import "DrawHelper.h"
#import "JTMaterialSwitch.h"


@interface MYMTSwitch : JTMaterialSwitch
@end

@implementation MYMTSwitch
@end



@interface SwitchControlView ()
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;
@property (nonatomic, strong) UIImageView *swithImageView;
@end

@implementation SwitchControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSwitchControl];
        [self showBorderLine];
    }
    return self;
}

- (void)loadSwitchControl {
    
    UIView *onView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    onView.layer.backgroundColor = [UIColor redColor].CGColor;
    [self addSubview:onView];
    
    
    UIView *offView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 100, 30)];
    offView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self addSubview:offView];
    
    
    
    _swithImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 90, 40)];
    [_swithImageView showBorderLine];
    [self addSubview:_swithImageView];
    
    UIImage *onImg = [DrawHelper imageFromLayerView:onView];
    UIImage *offImg = [DrawHelper imageFromLayerView:offView];
    self.onImage    = onImg;
    self.offImage   = offImg;
    
    _switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_switchControl showBorderLine];
    [self addSubview:_switchControl];
    [_switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_switchControl addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    
    _switchControl.onImage  = onImg;
    _switchControl.offImage = offImg;
    
    
    
    
    MYMTSwitch *jtSwitchRippleOFF = [[MYMTSwitch alloc] initWithSize:JTMaterialSwitchSizeSmall
                                                                           style:JTMaterialSwitchStyleDefault
                                                                           state:JTMaterialSwitchStateOn];
    jtSwitchRippleOFF.isRippleEnabled = NO;
    [jtSwitchRippleOFF.switchThumb setImage:[UIImage imageNamed:@"sunwu.jpg"] forState:UIControlStateNormal];
    [jtSwitchRippleOFF showBorderLine];
    jtSwitchRippleOFF.switchThumb.clipsToBounds = YES;
    jtSwitchRippleOFF.trackOnTintColor = [UIColor redColor];
    jtSwitchRippleOFF.trackOffTintColor = [UIColor blackColor];
    [self addSubview:jtSwitchRippleOFF];
    jtSwitchRippleOFF.center = CGPointMake(self.frame.size.width/3, 135);
    [jtSwitchRippleOFF addTarget:self action:@selector(jtSwitchValueChange:) forControlEvents:UIControlEventValueChanged];

    
}
- (void)jtSwitchValueChange:(MYMTSwitch *)jtmSw {
    if (jtmSw.isOn) {
        NSLog(@"JTMaterialSwitch ON");
    }else{
        NSLog(@"JTMaterialSwitch OFF");
    }
}


- (void)switchValueChange:(UISwitch *)sw {
    if (sw.isOn) {
        self.swithImageView.image = self.onImage;
    } else {
        self.swithImageView.image = self.offImage;
    }
}

@end
