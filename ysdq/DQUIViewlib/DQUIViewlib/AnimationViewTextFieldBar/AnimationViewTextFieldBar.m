//
//  AnimationViewTextFieldBar.m
//  DQUIViewlib
//
//  Created by lxw on 2018/10/11.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AnimationViewTextFieldBar.h"
#import "AnimationController.h"


@interface AnimationViewTextFieldBar ()<CAAnimationDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *animationImgV;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) AnimationController *animController;
@end

@implementation AnimationViewTextFieldBar {
    BOOL _shouldHiddenImgv;
    CAAnimationGroup * _animGroup;
    BOOL _shouldHiddenIcon;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIItems];
        [self showBorderLineColor:[UIColor lightGrayColor]];
    }
    return self;
}

- (void)setupUIItems {
    _animationImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 46)];
    _animationImgV.contentMode = UIViewContentModeCenter;
    _animationImgV.image = [UIImage imageNamed:@"main_search_small"];
    _animationImgV.layer.shadowOpacity = 0.6;
    _animationImgV.layer.shadowColor = [UIColor blueColor].CGColor;
    [self addSubview:_animationImgV];
    
    _textfield = [[UITextField alloc] init];
    _textfield.delegate = self;
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.borderStyle = UITextBorderStyleLine;
    _textfield.tintColor = [UIColor blueColor];
    _textfield.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_search_small"]];
    _textfield.rightViewMode = UITextFieldViewModeAlways;
    [_textfield showBorderLineColor:[UIColor redColor]];
    _textfield.placeholder = @"输入什么都可以";
    [self addSubview:_textfield];
    _textfield.frame = [self frameOfField];
    [self addKeyboardNotification];

}

- (void)layoutSubviews {
    self.textfield.frame = [self frameOfField];
}

- (CGRect)frameOfField {
    CGFloat leftImgW  = _animationImgV.frame.size.width;
    CGFloat fieldW = self.bounds.size.width - leftImgW;
    if (_shouldHiddenIcon) {
        leftImgW = leftImgW * 0.5;
        fieldW += leftImgW;
    }
    CGFloat fieldH = self.bounds.size.height;
    return  CGRectMake(leftImgW, 0, fieldW, fieldH);
}


- (void)callMethodIndex:(NSInteger)index {
    if (index == 0) {
        [self blockAnimationIconHidden:YES];
    }else if (index == 1){
        [self blockAnimationIconHidden:NO];
    }
    
    else if (index == 10){
        [self removeAllAnimations];
    }
}


- (void)textfieldResignFirstResponder {
    [self.textfield resignFirstResponder];
}

- (void)textfiledBecomeFirstResponder {
    [self.textfield becomeFirstResponder];
}

- (void)searchWordChanged:(id)sender {
    
}
- (void)didEndEditingNoti:(NSNotification*)noti {
    [self resignFirstResponder];
}

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchWordChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditingNoti:) name:UITextFieldTextDidEndEditingNotification object:nil];
}
#pragma mark TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField*)textField {
    [self blockAnimationIconHidden:YES];
}

- (void)textFieldDidEndEditing:(UITextField*)textField {
    [self blockAnimationIconHidden:NO];
}


#pragma mark - fix
- (void)blockAnimationIconHidden:(BOOL)hidden {
    if (!self.animController) {
        self.animController = [AnimationController new];
    }
    ViewAnimationType animTyp = ViewAnimationTypeUnknown;
    CGFloat delayT = 0.0;
    if (hidden) {
        animTyp     = ViewAnimationTypeSearchIconRotationHidden;
        delayT      = 0.3;
    }else {
        animTyp = ViewAnimationTypeSearchIconRotationShow;
    }
    _shouldHiddenIcon = hidden;
    
    NSLog(@"%@",NSStringFromCGRect(_textfield.frame));
    _textfield.rightViewMode = UITextFieldViewModeNever;
    
    self.animController = [[AnimationController alloc] init];
    __weak __typeof(self)weakSelf = self;
    [self.animController view:_animationImgV animation:animTyp didStart:^(ViewAnimationType animType) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.textfield.tintColor = [UIColor clearColor];
    } completion:^(ViewAnimationType animType) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (animType == ViewAnimationTypeSearchIconRotationShow) {
            if (strongSelf.textfield.text.length) {
                strongSelf.textfield.tintColor = [UIColor blueColor];
            }else{
                strongSelf.textfield.tintColor = [UIColor clearColor];
            }
        }else if (animType == ViewAnimationTypeSearchIconRotationHidden){
            strongSelf.textfield.tintColor = [UIColor blueColor];
        }
        strongSelf->_animController = nil;
    } appendTask:^{
        [UIView animateWithDuration:1 delay:delayT options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.textfield.frame = [self frameOfField];
        } completion:^(BOOL finished) {
            
        }];
    }];
}



#pragma mark - Animation
- (CAKeyframeAnimation *)keyframeAnimationHiddenState:(BOOL)isHidden {
    CAKeyframeAnimation *anim     = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    if (isHidden) {
        anim.values = [NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.2, 0.1,1,0.1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5, 0.2,1,0.2)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-0.5, 0.2,1,0.2)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-(M_PI/2.0), 0,1,0)],
                       nil];
        anim.keyTimes = @[@(0),@(0.1),@(0.25),@(0.4),@(0.5),@(1)];
    } else {
        anim.values = [NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.0), 0,1,0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.1), 0.1,1,0.1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/1.9), 0.1,1,0.1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.0), 0,1,0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                       nil];
        anim.keyTimes = @[@(0),@(0.05),@(0.08),@(0.1),@(1)];
    }
    anim.autoreverses = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    return anim;
}
- (void)searchIconAnimationHiddenState:(BOOL)isHidden {
    CAKeyframeAnimation *anim       = [self keyframeAnimationHiddenState:isHidden];
    CAAnimationGroup * animGroup    = [CAAnimationGroup animation];
    animGroup.fillMode              = kCAFillModeForwards;
    animGroup.animations            = @[anim];
    animGroup.duration              = 1.2f;
    animGroup.autoreverses          = NO;
    animGroup.removedOnCompletion   = NO;
    animGroup.delegate              = self;
    _animGroup = animGroup;
    if (isHidden) {
        [animGroup setValue:@"groupAnimationHidden" forKey:@"AnimationKey"];
    } else {
        [animGroup setValue:@"groupAnimationShow" forKey:@"AnimationKey"];
    }
    [self.animationImgV.layer addAnimation:animGroup forKey:nil];
    
    
    
    CGFloat imgvW  = _animationImgV.frame.size.width;
    _shouldHiddenImgv = isHidden;
    if (isHidden) {
        imgvW = imgvW * 0.5;
    }
    CGFloat fieldW = self.bounds.size.width - imgvW;
    CGFloat fieldH = self.bounds.size.height;
    CGFloat delayT = isHidden?0.3:0.0;
    [UIView animateWithDuration:1 delay:delayT options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.textfield.frame = CGRectMake(imgvW, 0, fieldW, fieldH);
    } completion:^(BOOL finished) {

    }];
}
#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    [_animationImgV setHidden:NO];
    if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"groupAnimationShow"]) {
        self.textfield.leftViewMode = UITextFieldViewModeAlways;
    }
    self.textfield.tintColor = [UIColor clearColor];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"groupAnimationHidden"]) {
            [self.textfield becomeFirstResponder];
            self.textfield.leftViewMode = UITextFieldViewModeNever;
            self.textfield.tintColor = [UIColor blueColor];
            [_animationImgV setHidden:YES];
        } else if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"groupAnimationShow"]) {
            if (self.textfield.text.length) {
                self.textfield.tintColor = [UIColor blueColor];
            }else{
                self.textfield.tintColor = [UIColor clearColor];
            }
        }
        _animGroup.delegate = nil;
        [_animationImgV.layer removeAllAnimations];
    } else {
        anim.delegate = nil;
        NSLog(@"");
    }
}

- (void)removeAllAnimations {
    [self.animController releaseHoldAnimation];
}

- (void)dealloc {
    NSLog(@"dealloc ");
}

@end
