//
//  CustomNavigationBar.m
//  DQUIViewlib
//链接：https://www.jianshu.com/p/5abc591feeda
//  Created by lxw on 2018/7/18.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "CustomNavigationBar.h"


@implementation CustomNavigationBar


- (void)layoutSubviews{
    [super layoutSubviews];

    //这里底层的View iOS 9.0以上好像是_UIBarBackground 类  以下是_UINavigationBarBackground  ，所以需要判断两个
    NSArray *classNamesToReposition = @[@"_UIBarBackground",@"_UINavigationBarBackground"];

    for (UIView *view in [self subviews]) {
        CGRect bounds = [self bounds];//{0,0,414,84}
        CGRect frame = [view frame];//{0,0,414,44}
        
        /*!_UIBarBackground*/
        
        if ([NSStringFromClass([view class]) isEqualToString:@"_UIBarBackground"]) {
            [view setFrame:bounds];
        } else if ([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarContentView"]){
            frame.origin.y = bounds.origin.y + CUSTOM_LOCATION_OFFSETY;
            [view setFrame:frame];
        } else if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {

            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            frame.origin.y = bounds.origin.y + CUSTOM_LOCATION_OFFSETY - 20.f;
            frame.size.height = bounds.size.height + 20.f;

            [view setFrame:frame];
        }
    }
}


//- (CGSize)sizeThatFits:(CGSize)size {
//    CGSize newSize = [super sizeThatFits:size];
//    newSize.height += CUSTOM_LOCATION_OFFSETY;
//    return newSize;
//}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//
//    self = [super initWithCoder:aDecoder];
//
//    if (self) {
//        [self initialize];
//    }
//
//    return self;
//}
//
//- (id)initWithFrame:(CGRect)frame {
//
//    self = [super initWithFrame:frame];
//
//    if (self) {
//        [self initialize];
//    }
//
//    return self;
//}
//
//- (void)initialize {
//    self.backgroundColor = [UIColor redColor];
//    [self setTransform:CGAffineTransformMakeTranslation(0, -(CUSTOM_LOCATION_OFFSETY))];
//}

@end
