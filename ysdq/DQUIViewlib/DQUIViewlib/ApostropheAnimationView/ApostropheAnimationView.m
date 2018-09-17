//
//  ApostropheAnimationView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/9/17.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "ApostropheAnimationView.h"

@interface ApostropheAnimationView()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) CAShapeLayer *hightlightLayer;
@property (nonatomic, strong) UIColor *colorHighlight;
@property (nonatomic, strong) UIColor *colorNormal;
@property (nonatomic, strong) NSArray<UIBezierPath *> *pointPaths;
@property (nonatomic, strong) NSArray<CAShapeLayer *> *shapeLayers;
@end

@implementation ApostropheAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _colorNormal    = RGBACOLOR_HEX(0xaaaaaa, 1);
        _colorHighlight = RGBACOLOR_HEX(0xffffff, 1);
        [self showBorderLine];
        [self setupUIItems];
        [self loadPointLoadintShapers];
        
        if (@available(iOS 10.0, *)) {
            [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self animationShapers];
            }];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void)setupUIItems {
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelTitle setFont:[UIFont systemFontOfSize:20]];
    [self addSubview:_labelTitle];
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
//    _labelTitle.text = @"···";
}

- (UIBezierPath *)pointPathFrame:(CGRect)frame {
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:frame.size.height * 0.5];
}
- (CAShapeLayer *)pointLayerPath:(UIBezierPath *)path {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = self.colorNormal.CGColor;
    layer.path  = path.CGPath;
    return layer;
}

- (void)setupPointPaths {
    self.pointPaths =
    @[[self pointPathFrame:CGRectMake(0, 5, 20, 20)],
      [self pointPathFrame:CGRectMake(30, 5, 20, 20)],
      [self pointPathFrame:CGRectMake(60, 5, 20, 20)]];
}

- (void)setupShapeLayers {
    self.shapeLayers =
    @[[self pointLayerPath:self.pointPaths[0]],
      [self pointLayerPath:self.pointPaths[1]],
      [self pointLayerPath:self.pointPaths[2]]];
}

- (void)loadPointLoadintShapers {
    [self setupPointPaths];
    [self setupShapeLayers];
    for (CAShapeLayer *layer in self.shapeLayers) {
        [self.layer addSublayer:layer];
        layer.frame = self.bounds;
    }
}

- (void)animationShapers {
    static int hightlightIndex = 0;
    if (!self.hightlightLayer) {
        self.hightlightLayer = self.shapeLayers[0];
    }
    self.hightlightLayer.fillColor = self.colorNormal.CGColor;
    self.shapeLayers[hightlightIndex].fillColor = self.colorHighlight.CGColor;
    self.hightlightLayer = self.shapeLayers[hightlightIndex];
    hightlightIndex = (hightlightIndex + 1)%self.pointPaths.count;
}

@end




