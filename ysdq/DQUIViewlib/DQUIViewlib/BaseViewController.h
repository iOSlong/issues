//
//  BaseViewController.h
//  DQUIViewlib
//
//  Created by lxw on 2018/7/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ViewType) {
    ViewTypeBracelet,
    ViewTypeGradientLayer,
    ViewTypeGradientAnimation,
    
    ViewTypeGradientNavigationBar
};

@interface BaseViewController : UIViewController
@property (nonatomic, assign) ViewType viewType;
- (CGRect)showFrameBracelet;

@end
