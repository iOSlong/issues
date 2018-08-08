//
//  RoundButton.m
//  DQUIViewlib
//
//  Created by lxw on 2018/8/3.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "RoundButton.h"
#import "GradientLayerView.h"

@interface RoundButton()
@property (nonatomic, assign) RoundButtonStyle style;
@property (nonatomic, strong) GradientLayerView *gradientLayerView;
@end
@implementation RoundButton

+ (instancetype)roundButtonFrame:(CGRect)frame style:(RoundButtonStyle)style {
    RoundButton *button = [[RoundButton alloc] initWithFrame:frame];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [button setTitle:@"这是按钮" forState:UIControlStateNormal];
//    [button showBorderLine];
    button.style = style;
    [button configureGradientLayer];
    switch (style) {
        case RoundButtonStyleCornerGray:
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button configureCornerGray];
        }
            break;
        case RoundButtonStyleCornerLeft:{
            [button configureCornerLeft];
        }
            break;
        case RoundButtonStyleCornerRight: {
            [button configureCornerRight];
        }
        default:
            break;
    }
    return button;
}
- (UIColor *)colorBegin:(RoundButtonStyle)style {
    if (style == RoundButtonStyleCornerGray) {
        return RGBACOLOR_HEX(0xEEEEEE, 1);
    }else {
        return RGBACOLOR_HEX(0x19A8F0, 1);

    }
}
- (UIColor *)colorEnd:(RoundButtonStyle)style {
    if (style == RoundButtonStyleCornerGray) {
        return RGBACOLOR_HEX(0xD8D8D8, 1);
    }else {
        return RGBACOLOR_HEX(0x1964E8, 1);
    }
}

- (void)configureGradientLayer {
    GradientLayerView *glv = [[GradientLayerView alloc] initWithFrame:self.bounds directionLandscape:YES colorStar:[self colorBegin:self.style] colorEnd:[self colorEnd:self.style]];
    [self setBackgroundImage:[glv gradinetLayerImage] forState:UIControlStateNormal];
}

- (void)configureCornerRight {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:self.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

- (void)configureCornerLeft {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:self.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)configureCornerGray {
//    self.layer.cornerRadius = self.bounds.size.height * 0.5;
//    self.clipsToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft |UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:self.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

- (void)_pan:(UIPanGestureRecognizer *)_panGestureRecognizer {
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    UIView *panGView = _panGestureRecognizer.view;
    
    [keyWindow bringSubviewToFront:panGView];
    CGPoint translation = [_panGestureRecognizer translationInView:keyWindow];
    
    
    NSLog(@"xxoo---xxoo---xxoo");
    CGPoint desCenter = CGPointMake(panGView.center.x + translation.x, panGView.center.y + translation.y);
    
    
    if (desCenter.x < 25 || desCenter.x > keyWindow.bounds.size.width - 25 || desCenter.y < 60 || desCenter.y > keyWindow.bounds.size.height-25) {
        return;
    }
    
    if (_panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Began");
//        originCenter = panGView.center;
    }else if (_panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Ended");
    }else if (_panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        panGView.center = desCenter;
        [_panGestureRecognizer setTranslation:CGPointZero inView:keyWindow];
    }else if (_panGestureRecognizer.state == UIGestureRecognizerStateFailed) {
        NSLog(@"Failed");
    }else if (_panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"Cancelled");
    }else if (_panGestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Recognized");
    }
}



@end
