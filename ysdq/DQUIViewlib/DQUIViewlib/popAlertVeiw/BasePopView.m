//
//  BasePopView.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/22.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "BasePopView.h"

@interface BasePopView ()
@property (nonatomic, copy) void (^tempCompleteBlock)(void);
@property (nonatomic, assign) CGRect originFrame;
@end

@implementation BasePopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.originFrame = frame;
        self.backgroundColor  = RGBACOLOR_HEX(0xff0000, 0.5);
        self.clipsToBounds    = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame with:(CGFloat)popContentContentHeight {
    self = [super initWithFrame:frame];
    if (self) {
        self.originFrame = frame;
    }
    return self;
}

+ (instancetype)fullScreenView {
    id view = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return view;
}

+ (instancetype)fullScreenViewWith:(CGFloat)popHeight {
    id view = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds with:popHeight];
    return view;
}


- (void)showInView:(UIView*)view {
    [self showInView:view animated:YES isEpisode:NO];
}

- (void)show {
    [self showInView:[[UIApplication sharedApplication] keyWindow]];
}
- (void)setType:(BasePopType)type {
    if (_type != type) {
        _type = type;
    }
}

- (void)showInView:(UIView*)view animated:(BOOL)animated isEpisode:(BOOL)isEpisode {
    [self addSubview:self.popContentView];
    if (animated) {
        CGFloat startAlpha = 0.4f;
        CGRect  startFrame = _popContentView.frame;
        switch (_type) {
            case BasePopTypeFade: {
                break;
            }
                
            case BasePopTypeSlideBottomTop: {
                startFrame.origin.y = startFrame.origin.y + self.bounds.size.height;
                break;
            }
                
            case BasePopTypeSlideTopBottom: {
                startFrame.origin.y = -_popContentView.frame.size.height;
                break;
            }
                
            case BasePopTypeSlideLeftRight: {
                startFrame.origin.x = -_popContentView.frame.size.width;
                break;
            }
                
            case BasePopTypeSlideRightLeft: {
                startFrame.origin.x = _popContentView.frame.size.width + startFrame.origin.x;
                break;
            }
        } /* switch */
        
        
        self.frame = view.bounds;
        [view addSubview:self];
        
        CGRect frame = self.originFrame;
        _popContentView.frame = startFrame;
        _popContentView.alpha = startAlpha;
        
        [UIView animateWithDuration:0.3
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self->_popContentView.frame = frame;
                             self->_popContentView.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             if (self.showCompletionHandler) {
                                 self.showCompletionHandler();
                             }
                         }];
    } else {
        self.frame = view.bounds;
        [view addSubview:self];
    }
} /* showInView */


- (void)dissmiss {
    CGFloat startAlpha = 0.0f;
    CGRect  startFrame = _popContentView.frame;
    switch (_type) {
        case BasePopTypeFade: {
            break;
        }
            
        case BasePopTypeSlideBottomTop: {
            startFrame.origin.y = self.bounds.size.height;
            break;
        }
            
        case BasePopTypeSlideTopBottom: {
            startFrame.origin.y = -_popContentView.frame.size.height;
            break;
        }
            
        case BasePopTypeSlideLeftRight: {
            startFrame.origin.x = -_popContentView.frame.size.width;
            break;
        }
            
        case BasePopTypeSlideRightLeft: {
            startFrame.origin.x = self.bounds.size.width;
            break;
        }
    } /* switch */
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self->_popContentView.frame = startFrame;
                         self->_popContentView.alpha = startAlpha;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (self.tempCompleteBlock) {
                             self.tempCompleteBlock();
                         }
                     }];
}


- (void)tapAction:(UITapGestureRecognizer *)tapG {
    CGPoint point = [tapG locationInView:self];
    CGPoint relatedAlertP = [self.popContentView convertPoint:point fromView:self];
    if(!CGRectContainsPoint(self.popContentView.bounds, relatedAlertP)){
        [self cancel];
    }
}

- (void)cancel {
    if (self.cancelHandler) {
        self.cancelHandler(self);
        self.cancelHandler = nil;
    }
    [self dissmiss];
}


- (void)cancelCompletion:(void (^)(void))complete {
    self.tempCompleteBlock = complete;
    [self cancel];
}


@end
