//
//  HitTestView.m
//  DQUIViewlib
//
//  Created by lxw on 2019/6/14.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "HitTestView.h"

#define HitTruncation   (10)

@interface HitTestView ()
@property (nonatomic, strong) UIButton *hitTestButton;
@property (nonatomic, strong) UISwitch *enableSW;
@end

@implementation HitTestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadTestButton];
    }
    return self;
}
- (void)loadTestButton {
    self.hitTestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.hitTestButton.backgroundColor = [UIColor blueColor];
    self.hitTestButton.tag = HitTruncation;
    [self.hitTestButton addTarget:self action:@selector(hitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.hitTestButton];
    [self.hitTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    self.enableSW = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.enableSW setOn:self.hitTestButton.userInteractionEnabled];
    [self addSubview:self.enableSW];
    [self.enableSW addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.enableSW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.top.equalTo(@50);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
}

- (void)switchChange:(UISwitch *)sw {
    self.hitTestButton.userInteractionEnabled = sw.isOn;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest %@",NSStringFromCGPoint(point));
    UIView *hitV = [super hitTest:point withEvent:event];
    CGPoint pInButton =  [self.hitTestButton convertPoint:point fromView:self];
    if ([self.hitTestButton pointInside:pInButton withEvent:event] && hitV != self.hitTestButton) {
        NSLog(@"relP %@",NSStringFromCGPoint(pInButton));
        return nil;
    }
    return hitV;
}

- (void)hitButton:(UIButton *)btn {
    NSLog(@"hitButton");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touchesBegan!");
}

@end
