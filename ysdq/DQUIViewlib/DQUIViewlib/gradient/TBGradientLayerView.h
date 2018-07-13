//
//  TBGradientLayerView.h
//  ViewColorGrad
//
//  Created by xw.long on 16/3/21.
//  Copyright © 2016年 xw.long. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBGradientLayerViewDelegate <NSObject>
-(void)gradientLayerAnimationStar;
-(void)gradientLayerAnimationFinished;
@end

@interface TBGradientLayerView : UIView

@property (nonatomic, strong) CAGradientLayer *colorLayer;
@property (nonatomic, strong) CABasicAnimation *basicAnimation;
@property (nonatomic, strong) NSTimer *timerAnimation;
@property (nonatomic, assign) BOOL showGradientLayer;
@property (nonatomic, assign) BOOL increaseColorRed;
@property (nonatomic, assign) BOOL canAnimation;

@property (nonatomic, assign) id <TBGradientLayerViewDelegate>delegate;

@end
