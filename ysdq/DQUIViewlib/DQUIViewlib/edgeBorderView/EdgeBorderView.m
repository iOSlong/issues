//
//  EdgeBorderView.m
//  DQUIViewlib
//
//  Created by lxw on 2019/2/27.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "EdgeBorderView.h"

EdgeBorder EdgeBorderMake(UIRectEdge edge, UIEdgeInsets insets) {
    EdgeBorder border;
    border.edge     = edge;
    border.insets   = insets;
    return border;
}

@interface EdgeBorderView ()
@property (nonatomic, strong) UIView *borderTop;
@property (nonatomic, strong) UIView *borderLeft;
@property (nonatomic, strong) UIView *borderBottom;
@property (nonatomic, strong) UIView *borderRight;
@end

@implementation EdgeBorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _borderColor = [UIColor redColor];
    }
    return self;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.borderTop.backgroundColor = borderColor;
    self.borderLeft.backgroundColor = borderColor;
    self.borderRight.backgroundColor = borderColor;
    self.borderBottom.backgroundColor = borderColor;
}

- (void)callMethodIndex:(NSInteger)index {
    UIRectEdge edge = UIRectEdgeNone;
    if (index == 0) {
        edge = UIRectEdgeNone;
    }else if (index == 1) {
        edge = UIRectEdgeTop;
    }else if (index == 2) {
        edge = UIRectEdgeLeft;
    }else if (index == 3) {
        edge = UIRectEdgeBottom;
    }else if (index == 4) {
        edge = UIRectEdgeRight;
    }else if (index == 5) {
        edge = UIRectEdgeTop|UIRectEdgeLeft;
    }else if (index == 6) {
        edge = UIRectEdgeTop|UIRectEdgeBottom;
    }else if (index == 7) {
        edge = UIRectEdgeAll;
    }
    [self setEdgeBorder:EdgeBorderMake(edge, UIEdgeInsetsMake(2, 2, 2, 2))];
}



- (void)setEdgeBorder:(EdgeBorder)edgeBorder {
    _edgeBorder = edgeBorder;
    UIRectEdge edge = edgeBorder.edge;
    UIEdgeInsets borderInsets = edgeBorder.insets;
    if(UIRectEdgeTop & edge){
        if (!_borderTop) {
            CGRect rect = [self rectBorder:edge width:borderInsets.top];
            _borderTop = [self defaultBorderView:rect];
            [self addSubview:_borderTop];
        }
    }
    if (UIRectEdgeLeft & edge) {
        if (!_borderLeft) {
            CGRect rect = [self rectBorder:edge width:borderInsets.left];
            _borderLeft =[self defaultBorderView:rect];
            [self addSubview:_borderLeft];
        }
    }
    if (UIRectEdgeRight & edge){
        if (!_borderRight) {
            CGRect rect = [self rectBorder:edge width:borderInsets.right];
            _borderRight = [self defaultBorderView:rect];
            [self addSubview:_borderRight];
        }
    }
    if (UIRectEdgeBottom & edge){
        if (!_borderBottom) {
            CGRect rect = [self rectBorder:edge width:borderInsets.bottom];
            _borderBottom = [self defaultBorderView:rect];
            [self addSubview:_borderBottom];
        }
    }
    if (UIRectEdgeAll == edge){
        [self setEdgeBorder:EdgeBorderMake(UIRectEdgeTop, borderInsets)];
        [self setEdgeBorder:EdgeBorderMake(UIRectEdgeLeft, borderInsets)];
        [self setEdgeBorder:EdgeBorderMake(UIRectEdgeRight, borderInsets)];
        [self setEdgeBorder:EdgeBorderMake(UIRectEdgeBottom, borderInsets)];
    }
    [self.borderTop setHidden:!(UIRectEdgeTop & edge)];
    [self.borderLeft setHidden:!(UIRectEdgeLeft & edge)];
    [self.borderBottom setHidden:!(UIRectEdgeBottom & edge)];
    [self.borderRight setHidden:!(UIRectEdgeRight & edge)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.borderTop && self.borderTop.hidden == NO) {
        [self freshBorder:UIRectEdgeTop];
    }
    if (self.borderLeft && self.borderLeft.hidden == NO) {
        [self freshBorder:UIRectEdgeLeft];
    }
    if (self.borderBottom && self.borderBottom.hidden == NO) {
        [self freshBorder:UIRectEdgeBottom];
    }
    if (self.borderRight && self.borderRight.hidden == NO) {
        [self freshBorder:UIRectEdgeRight];
    }
}

- (void)freshBorder:(UIRectEdge)edge {
    CGFloat borderW = 0;
    UIView  *borderView = nil;
    if (edge == UIRectEdgeTop) {
        borderW = self.edgeBorder.insets.top;
        borderView = self.borderTop;
    }else if (edge == UIRectEdgeLeft) {
        borderW = self.edgeBorder.insets.left;
        borderView = self.borderLeft;
    }else if (edge == UIRectEdgeBottom) {
        borderW = self.edgeBorder.insets.bottom;
        borderView = self.borderBottom;
    }else if (edge == UIRectEdgeRight) {
        borderW = self.edgeBorder.insets.right;
        borderView = self.borderRight;
    }
    CGRect borderRect = [self rectBorder:edge width:borderW];
    if (!CGRectEqualToRect(borderView.frame, borderRect)) {
        borderView.frame = borderRect;
    }
}

- (CGRect)rectBorder:(UIRectEdge)edge width:(CGFloat)width {
    if (edge == UIRectEdgeTop) {
        return  CGRectMake(0, 0, self.bounds.size.width, width);
    }else if (edge == UIRectEdgeLeft) {
        return   CGRectMake(0, 0,width,self.bounds.size.height);
    }else if (edge == UIRectEdgeBottom) {
        return CGRectMake(0, self.bounds.size.height - width,self.bounds.size.width,width);
    }else if (edge == UIRectEdgeRight) {
        return  CGRectMake(self.bounds.size.width - width, 0,width,self.bounds.size.height);
    }
    return CGRectZero;
}

- (UIView *)defaultBorderView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = _borderColor;
    return view;
}
@end
