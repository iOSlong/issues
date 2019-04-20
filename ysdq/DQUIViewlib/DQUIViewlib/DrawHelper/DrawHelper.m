//
//  DrawHelper.m
//  DQUIViewlib
//
//  Created by lxw on 2019/4/20.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "DrawHelper.h"

@implementation DrawHelper

+ (UIImage *)imageFromLayerView:(UIView *)desView {
    UIGraphicsBeginImageContext(desView.layer.frame.size);
    [desView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
