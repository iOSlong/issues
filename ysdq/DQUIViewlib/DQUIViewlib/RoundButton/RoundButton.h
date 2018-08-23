//
//  RoundButton.h
//  DQUIViewlib
//
//  Created by lxw on 2018/8/3.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RoundButtonStyle) {
    RoundButtonStyleCornerGray,
    RoundButtonStyleCornerLeft,
    RoundButtonStyleCornerRight,
    RoundButtonStyleCornerNone,
};

@interface RoundButton : UIButton
+ (instancetype)roundButtonFrame:(CGRect)frame style:(RoundButtonStyle)style;
- (void)addHoldMethod;
@end
