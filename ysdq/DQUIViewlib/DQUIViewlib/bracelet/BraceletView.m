//
//  BraceletView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "BraceletView.h"

@interface BraceletView()
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation BraceletView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showBorderMask];
    }
    return self;
}

- (void)showBorderMask {
    self.maskLayer = [CAShapeLayer layer];
    
    self.maskLayer.strokeColor  = self.titleLabel.textColor.CGColor;
    self.maskLayer.fillColor    = [UIColor clearColor].CGColor;
    self.maskLayer.lineWidth    = 2;
    
    [self.layer addSublayer:self.maskLayer];
    
    CGFloat radius  = self.frame.size.width * 0.5;
    CGFloat PstarX  = radius * 0.5;
    CGFloat pStarY  = [self coordinateVerticalFrom:PstarX radius:radius];
    CGFloat angle   = asin((radius-PstarX)/radius);
    CGFloat angleStar = -( M_PI_2 + angle);
    CGFloat angleEnd  = M_PI + angle;

    UIBezierPath *maskPath = [UIBezierPath new];
    [maskPath moveToPoint:CGPointMake(PstarX, radius-pStarY)];
    [maskPath addArcWithCenter:CGPointMake(radius,radius) radius:radius startAngle:angleStar endAngle:angleEnd clockwise:YES];
    [maskPath fill];
    [maskPath stroke];
    [self.maskLayer setPath:maskPath.CGPath];
}
- (CGFloat)coordinateVerticalFrom:(CGFloat)horizontal radius:(CGFloat)radius{
    CGFloat temp = radius - horizontal;
    CGFloat powY = pow(radius, 2) - pow(temp, 2);
    CGFloat vertical =  sqrt(powY);
    return vertical;
}
- (void)setTitleShow:(NSString *)titleShow {
    if (_titleShow != titleShow) {
        _titleShow = titleShow;
        [self setTitle:titleShow forState:UIControlStateNormal];
    }
}
- (void)setColorShow:(UIColor *)colorShow {
    if (_colorShow != colorShow) {
        _colorShow = colorShow;
        [self setTitleColor:colorShow forState:UIControlStateNormal];
        self.maskLayer.strokeColor  = colorShow.CGColor;
    }
}
@end









