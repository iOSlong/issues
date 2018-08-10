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
    ViewTypeLayerImage,
    ViewTypeRoundButton,
    ViewTypeFloatButton,
    ViewTypeBezierPath,
    ViewTypeControlView,
    
    ViewTypeGradientNavigationBar
};

typedef NS_ENUM(NSUInteger, NaviBarTime) {
    NaviBarTimeNone,
    NaviBarTimeViewDidLoad,
    NaviBarTimeViewWillAppear,
    NaviBarTimeViewDidAppear,
    NaviBarTimeViewWillDisappear,
    NaviBarTimeViewDidDisappear,
};


@interface BaseViewController : UIViewController
@property (nonatomic, assign) ViewType viewType;
@property (nonatomic, assign) NaviBarTime navShowTime;
@property (nonatomic, assign) NaviBarTime navHiddenTime;
@property (nonatomic, assign) BOOL navAnimation;
- (CGRect)showFrameBracelet;
@end




