//
//  ReversalAnimationView.h
//  DQUIViewlib
//
//  Created by lxw on 2018/10/10.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReversalAnimationView : UIView

- (void)callMethodIndex:(NSInteger)index;

- (void)backOriginFrame;
- (void)rotation2DAnimation:(BOOL)animation;
- (void)rotation3DAnimation:(BOOL)animation;
- (void)wobble2D;
- (void)wobble3D;

- (void)groupAnimation;
@end
