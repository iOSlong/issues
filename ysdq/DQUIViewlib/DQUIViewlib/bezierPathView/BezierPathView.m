//
//  BezierPathView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/8/8.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "BezierPathView.h"

@interface BezierPathView ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer2;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation BezierPathView {
    CGFloat _angle;
    CGFloat _tangentL;      //控制点切线长度。
    CGFloat _offsetY;       //path偏移高
    CGFloat _offsetX;       //
    CGFloat _borderW;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureMathData];
        [self bezierPathViewRrapezoid];
        [self bezierPathViewRoundedRect];
        [self layerGradientMask];
    }
    return self;
}

- (void)configureMathData {
    _tangentL   = 0.1 * self.bounds.size.height;
    _offsetX    = 30.0f;
    _offsetY    = self.bounds.size.height - 40;
    _angle      = atan(_offsetY/_offsetX);
    _borderW    = 5;
}


- (UIBezierPath *)bezierPathRoundRect {
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_offsetX, _offsetY + 5 + _borderW, self.bounds.size.width - 2 * _offsetX, 10) cornerRadius:5];
    [linePath fill];
    return linePath;
}

- (UIBezierPath *)bezierPathRrapezoid {
    CGFloat rectW = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath new];
    CGPoint pStar   = CGPointMake(0, 0);
    CGPoint pEnd    = CGPointMake(rectW, 0);
    CGPoint p_b1    = CGPointMake(_offsetX - _tangentL * cos(_angle), _offsetY - _tangentL * sin(_angle));
    CGPoint p_b2    = CGPointMake(_offsetX + _tangentL, _offsetY);
    CGPoint p_C1    = CGPointMake(_offsetX, _offsetY);
    
    CGPoint p_b3    = CGPointMake(rectW - _offsetX - _tangentL, _offsetY);
    CGPoint p_b4    = CGPointMake(rectW - _offsetX + _tangentL * cos(_angle), _offsetY - _tangentL * sin(_angle));
    CGPoint p_C2    = CGPointMake(rectW - _offsetX, _offsetY);
    
    [path moveToPoint:pStar];
    [path addLineToPoint:p_b1];
    [path addQuadCurveToPoint:p_b2 controlPoint:p_C1];
    [path addLineToPoint:p_b3];
    [path addQuadCurveToPoint:p_b4 controlPoint:p_C2];
    [path addLineToPoint:pEnd];
    return path;
}

- (void)bezierPathViewRrapezoid {
    if (!self.shapeLayer.superlayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = RGBACOLOR_HEX(0x323232, 1).CGColor;
        layer.fillColor = RGBACOLOR_HEX(0x161616, 1).CGColor;
        layer.lineWidth = _borderW;
        [self.layer addSublayer:layer];
        self.shapeLayer = layer;
    }
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.path  = [self bezierPathRrapezoid].CGPath;
}

- (void)bezierPathViewRoundedRect {
    if (!self.shapeLayer2.superlayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = RGBACOLOR_HEX(0x323232, 1).CGColor;
        layer.fillColor = RGBACOLOR_HEX(0x161616, 1).CGColor;
        layer.lineWidth = _borderW;
        [self.layer addSublayer:layer];
        self.shapeLayer2 = layer;
    }
    self.shapeLayer2.frame = self.bounds;
    self.shapeLayer2.path  = [self bezierPathRoundRect].CGPath;
}

- (void)layerGradientMask {
    if (!self.gradientLayer) {
        CAGradientLayer *gradLayer = [CAGradientLayer layer];
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                           (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                           (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                           nil];
        [gradLayer setColors:colors];
        [gradLayer setLocations:@[@0.0,@0.3,@1.0]];
        [gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
        [gradLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
        self.gradientLayer = gradLayer;
    }
    [self.gradientLayer setFrame:self.bounds];
    [self.layer setMask:self.gradientLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.shapeLayer) {
        if (!CGRectEqualToRect(self.shapeLayer.bounds, self.bounds)) {
            [self configureMathData];
            [self bezierPathViewRrapezoid];
            [self bezierPathViewRoundedRect];
            [self layerGradientMask];
        }
    }
}

@end
