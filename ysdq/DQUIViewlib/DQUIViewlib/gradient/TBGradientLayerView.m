//
//  TBGradientLayerView.m
//  ViewColorGrad
//
//  Created by xw.long on 16/3/21.
//  Copyright © 2016年 xw.long. All rights reserved.
//

#import "TBGradientLayerView.h"


@implementation TBGradientLayerView{
    UIColor *_colorLight;
    UIColor *_colorStrong;
    CGFloat offset;
    CGFloat time_off;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        offset = 1.0/24.0;
        time_off = 0.68;

        [self judgeColorIncreaseRed];
        self.increaseColorRed = YES;//默认为涨势
        self.canAnimation = YES;

        [self reloadLayerConfigures];

    }
    return self;
}

-(void)reloadLayerConfigures{
    if (_colorLayer) {
        [_colorLayer removeFromSuperlayer];
        _colorLayer = nil;
    }
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    _colorLayer = colorLayer;
    colorLayer.frame = (CGRect){CGPointZero, CGSizeMake(self.frame.size.width, self.frame.size.height)};
    [self.layer addSublayer:colorLayer];
    
    colorLayer.colors = @[(__bridge id)_colorLight.CGColor,(__bridge id)_colorLight.CGColor,(__bridge id)_colorStrong.CGColor,(__bridge id)_colorStrong.CGColor,(__bridge id)_colorLight.CGColor];
    
    colorLayer.locations = @[@0.0,@(23*offset),@(23.5*offset),@(24*offset),@1.0];
    
    colorLayer.startPoint   = CGPointMake(0, 0);
    
    colorLayer.endPoint     = CGPointMake(1, 0);
}

-(CABasicAnimation *)basicAnimation{
    if (!_basicAnimation) {
        _basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _basicAnimation.fromValue   = [NSNumber numberWithFloat:0.6f];
        _basicAnimation.toValue     = [NSNumber numberWithFloat:0.0f];
        _basicAnimation.duration    = time_off;
        ;
        _basicAnimation.delegate    = self;
    }
    return _basicAnimation;
}
-(void)animationDidStart:(CAAnimation *)anim{
    self.canAnimation = NO;
    _showGradientLayer = YES;//标记动画完成
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    self.alpha = 0;
    
    self.canAnimation = YES;
    _showGradientLayer = NO;//标记动画完成
    _basicAnimation = nil;
    if ([self.delegate respondsToSelector:@selector(gradientLayerAnimationFinished)]) {
        [self.delegate gradientLayerAnimationFinished];
    }

}




-(void)setShowGradientLayer:(BOOL)showGradientLayer{
    _showGradientLayer = showGradientLayer;
    if (_showGradientLayer && _canAnimation) {
        
        self.alpha = 0.6;
        _colorLayer.locations = @[@0.0,@(23*offset),@(23.5*offset),@(24*offset),@1.0];
        [_colorLayer removeAllAnimations];
        
    }else if(_showGradientLayer == NO){
        self.alpha = 0.0;
    }else{
        self.alpha = 0;
        return;
    }
    
    if (showGradientLayer && _canAnimation && _basicAnimation==nil)
    {
        self.canAnimation = NO;
        if ([self.delegate respondsToSelector:@selector(gradientLayerAnimationStar)])
        {
            [self.delegate gradientLayerAnimationStar];
        }
        
        //开始一条行情动效播放。
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _colorLayer.locations = @[@0.0,@(0*offset),@(14*offset),@(18*offset),@1.0];
        });
        
        /*使用显式动画会出现动画借宿的时候设置alpha=0 或 setHidden导致有闪烁现象！*/
//        [self.layer addAnimation:self.basicAnimation forKey:@"opacity"];
                
        [UIView animateWithDuration:time_off animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.canAnimation = YES;
            _showGradientLayer = NO;//标记动画完成
            _basicAnimation = nil;
            if ([self.delegate respondsToSelector:@selector(gradientLayerAnimationFinished)]) {
                [self.delegate gradientLayerAnimationFinished];
            }
        }];
        
    }
    else
    {
        _colorLayer.locations = @[@0.0,@(23*offset),@(23.5*offset),@(24*offset),@1.0];
        [_colorLayer removeAllAnimations];
    }
}


-(BOOL)judgeColorIncreaseRed{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    BOOL value = arc4random()%2;
    if (arc4random()%2) {
        return YES;
    }else{
        return NO;
    }
}

-(void)setIncreaseColorRed:(BOOL)increaseColorRed{
    _increaseColorRed = increaseColorRed;
    if (_increaseColorRed) {
        if ([self judgeColorIncreaseRed]) {//红涨绿跌
            _colorLight  = RGBACOLOR_HEX(0x1e1c20,1);
            _colorStrong  = RGBACOLOR_HEX(0x249c00,0.5);
        }else{//绿涨红跌
            _colorLight  = RGBACOLOR_HEX(0x1e1c20,1);
            _colorStrong  = RGBACOLOR_HEX(0xdd0d32,0.5);
        }
    }else if(!_increaseColorRed){
        if ([self judgeColorIncreaseRed]) {
            _colorLight  = RGBACOLOR_HEX(0x1e1c20,1);
            _colorStrong  = RGBACOLOR_HEX(0xdd0d32,0.5);
        }else{
            _colorLight  = RGBACOLOR_HEX(0x1e1c20,1);
            _colorStrong  = RGBACOLOR_HEX(0x249c00,0.5);
        }
    }
    _colorLayer.colors = @[(__bridge id)_colorLight.CGColor,(__bridge id)_colorLight.CGColor,(__bridge id)_colorStrong.CGColor,(__bridge id)_colorStrong.CGColor,(__bridge id)_colorLight.CGColor];
}


@end











