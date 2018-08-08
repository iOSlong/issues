//
//  GradientLayerView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/13.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "GradientLayerView.h"



UIImage *imageFromLayer(CALayer *layer) {
    UIGraphicsBeginImageContext(layer.frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}




@interface GradientLayerView()
@property (nonatomic, strong) CAGradientLayer *colorLayer;
@end

@implementation GradientLayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGradientLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame directionLandscape:(BOOL)landscape colorStar:(UIColor *)colorStar colorEnd:(UIColor *)colorEnd {
    self = [self initWithFrame:frame];
    if (self) {
        _colors     = @[colorStar?:[UIColor clearColor],colorEnd?:[UIColor clearColor]];
        _locations  = @[@0.0,@1.0];
        if (landscape) {
            _startPoint = CGPointMake(0, 0);
            _endPoint   = CGPointMake(0, 1);
        }else{
            _startPoint = CGPointMake(0, 0);
            _endPoint   = CGPointMake(1, 0);
        }
        [self refreshGradientLayer];
    }
    return self;
}

+ (instancetype)gradientLayerNavigationBar {
    GradientLayerView *glv = [[GradientLayerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) directionLandscape:YES colorStar:nil colorEnd:nil];
    return glv;
}


- (UIImage *)gradinetLayerImage {
    return imageFromLayer(self.colorLayer);
}


+ (UIImage *)gradientLayerNavigationImage {
    CGFloat barHeight = 64;
    if (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) == 375) {
        barHeight += 24;
    }
    GradientLayerView *glv = [[GradientLayerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, barHeight) directionLandscape:YES colorStar:RGBCOLOR_HEX(0x19A8F0) colorEnd:RGBCOLOR_HEX(0x0049CB)];
    return imageFromLayer(glv.colorLayer);
}

- (void)addGradientLayer {
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    _colorLayer = colorLayer;
    colorLayer.frame = (CGRect){CGPointZero, CGSizeMake(self.frame.size.width, self.frame.size.height)};
    [self.layer addSublayer:colorLayer];
    [self refreshGradientLayer];
}

- (void)refreshGradientLayer {
    NSMutableArray *colorRefs = [NSMutableArray array];
    for (int i = 0; i < self.colors.count; i ++) {
        CGColorRef colorRef = self.colors[i].CGColor;
        [colorRefs addObject:(__bridge id _Nonnull)(colorRef)];
    }
    self.colorLayer.colors      = colorRefs;
    self.colorLayer.locations   = self.locations;
    self.colorLayer.startPoint  = self.startPoint;
    self.colorLayer.endPoint    = self.endPoint;
}
- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = colors;
    [self refreshGradientLayer];
}
- (void)setLocations:(NSArray<NSNumber *> *)locations {
    _locations = locations;
    [self refreshGradientLayer];
}
- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    [self refreshGradientLayer];
}
- (void)setEndPoint:(CGPoint)endPoint {
    _endPoint = endPoint;
    [self refreshGradientLayer];
}

@end
