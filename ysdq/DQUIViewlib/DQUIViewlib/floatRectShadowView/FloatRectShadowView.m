//
//  FloatRectShadowView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/11/13.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "FloatRectShadowView.h"

@implementation Arrow

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(rect.size.width/2, 0)];
    
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    
    [path addCurveToPoint:CGPointMake(0, rect.size.height) controlPoint1:CGPointMake(rect.size.width/2, rect.size.height) controlPoint2:CGPointMake(rect.size.width/2, rect.size.height)];
    
    [path closePath];
    
    [RGBACOLOR_HEX(0xffffff, 0.5) setStroke];
    [[UIColor whiteColor] setFill];
    [path stroke];
    [path fill];
    
    self.layer.shadowColor = RGBACOLOR_HEX(0xdadada, 0.5).CGColor;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.4;
    
}

@end

@interface FloatRectShadowView()
@property (nonatomic, strong) Arrow *arrow;
@end

@implementation FloatRectShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 8;
        
        [self.layer setShadowColor:RGBCOLOR_HEX(0xdadada).CGColor];
        [self.layer setShadowOpacity: 0.5];
        [self.layer setShadowOffset:CGSizeMake(0,0)];
        [self.layer setShadowRadius:5];
        
        _arrow = [[Arrow alloc] initWithFrame:CGRectMake(0, 0, 28, 18)];
        _arrow.backgroundColor = [UIColor clearColor];
        _arrow.center = CGPointMake(30, -5);
        [self addSubview:_arrow];
    }
    return self;
}


-(void)moveArrowCenterAtPoint:(CGPoint)point
{
    _arrow.center = point;
    CGFloat rotateAngle = 0;
    
    if (point.x==self.frame.size.width+5) {
        rotateAngle = M_PI/2;
    }//左侧
    if (point.x==-5) {
        rotateAngle = -M_PI/2;
    }//右侧
    if (point.y==self.frame.size.height+5) {
        rotateAngle = M_PI;
    }//上侧
    if (point.y==-5) {
        rotateAngle = 0;
    }//下侧
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGAffineTransform rotationTransform = CGAffineTransformRotate(transform, rotateAngle);
    _arrow.transform = rotationTransform;
    
}


@end
