//
//  ControlView.h
//  DQUIViewlib
//
//  Created by lxw on 2018/8/9.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlView : UIControl
@property (nonatomic, strong) UILabel *titleLabel;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

@property (nonatomic, assign) BOOL isIndicatorShow;
@end
