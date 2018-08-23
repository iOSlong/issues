//
//  AirPlayView.h
//  DQUIViewlib
//
//  Created by lxw on 2018/8/16.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "SASView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AirPlayView : SASView

@property (nonatomic, strong) UIColor   *titleColor;
@property (nonatomic, strong) UIFont    *titleFont;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, assign) BOOL      isLandscape;

@property (nonatomic, assign) BOOL      disableAirPlayResponse;//Default NO.
/*! 如果disableAirPlayResponse:YES, 那么点击控件的时候，将触发下面的block方法实现*/
@property (nonatomic, copy)void(^tapClick)();


@end
