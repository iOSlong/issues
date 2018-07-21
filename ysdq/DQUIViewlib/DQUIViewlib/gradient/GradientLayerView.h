//
//  GradientLayerView.h
//  DQUIViewlib
//
//  Created by lxw on 2018/7/13.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
UIImage *imageFromLayer(CALayer *layer);


@interface GradientLayerView : UIView
@property (nonatomic) NSArray<UIColor *> *colors;
@property (nonatomic) NSArray<NSNumber *> *locations;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
- (instancetype)initWithFrame:(CGRect)frame directionLandscape:(BOOL)landscape colorStar:(UIColor *)colorStar colorEnd:(UIColor *)colorEnd;
+ (instancetype)gradientLayerNavigationBar;
+ (UIImage *)gradientLayerNavigationImage;
@end
