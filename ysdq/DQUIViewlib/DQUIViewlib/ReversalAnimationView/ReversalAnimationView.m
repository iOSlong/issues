//
//  ReversalAnimationView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/10/10.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "ReversalAnimationView.h"

#define fieldLeftMode 1

@interface ReversalAnimationView()<CAAnimationDelegate>
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UISlider *valueSlider;
@property (nonatomic, strong) UISegmentedControl *transitionSegment;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UISwitch *animationSwitch;

@end
/*
 3D旋转变换抽 坐标系：
          y
         ^
         |
         |
         |
         |
         · - —— —— —— ——> x
        /
       /
      /
     V_
      z
*/

@implementation ReversalAnimationView {
    CGFloat     _actionSeconds;
    NSInteger   _segmentIndex;
    CGFloat     _angleArr[3];
    NSArray<UILabel *>     *_labelArray;
    SEL _mehodArr[20];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _actionSeconds = 2;
        [self setupUIItems];
        [self addKeyboardNotification];
    }
    return self;
}

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchWordChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditingNoti:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillHidden:) name:UIKeyboardWillHideNotification object:nil];


}

- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)searchWordChanged:(NSNotification*)sender {
    
}

- (void)didEndEditingNoti:(NSNotification*)sender {
    [self resignFirstResponder];
}

- (void)keybordWillShow:(NSNotification *)sender {
    [self groupAnimationHidden];
}
- (void)keybordWillHidden:(NSNotification *)sender {
    self.textfield.tintColor = [UIColor clearColor];
    self.textfield.leftViewMode = UITextFieldViewModeAlways;
    [self groupAnimationShow];
}






- (void)setupUIItems {
    _animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 46)];
    _animationView.contentMode = UIViewContentModeCenter;
    _animationView.image = [UIImage imageNamed:@"main_search_small"];
    _animationView.layer.shadowOpacity = 0.6;
    _animationView.layer.shadowColor = [UIColor blueColor].CGColor;
//    [_animationView showBorderLineColor:[UIColor redColor]];
    

#if !fieldLeftMode
    _animationView.frame = CGRectMake(10, 10, 50, 50);
    [self addSubview:_animationView];
#else
    
    _textfield = [[UITextField alloc] init];
    _textfield.tintColor = [UIColor clearColor];
    [self addSubview:_textfield];
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self).offset(5);
        make.height.equalTo(@50);
    }];
    _textfield.placeholder = @"输入什么都可以";
    
    
#if 0
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 46)];
//    [_leftView showBorderLineColor:[UIColor blueColor]];
    _textfield.leftView = _leftView;
    [_leftView addSubview:_animationView];
    _textfield.leftViewMode = UITextFieldViewModeUnlessEditing;
#else
    _textfield.leftView = _animationView;
    _textfield.leftViewMode = UITextFieldViewModeAlways;
#endif

#endif

    
    _transitionSegment = [[UISegmentedControl alloc] initWithItems:@[@"X",@"Y",@"Z"]];
    [_transitionSegment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_transitionSegment];
    [_transitionSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    
    _labelArray = @[[UILabel new],[UILabel new],[UILabel new]];
    for (int i = 0; i < 3; i ++) {
        _labelArray[i].font = [UIFont systemFontOfSize:12];
        _labelArray[i].textAlignment = NSTextAlignmentCenter;
        [_labelArray[i] showBorderLineColor:[UIColor darkGrayColor]];
        [self addSubview:_labelArray[i]];
    }
    [_labelArray[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_transitionSegment.mas_left);
        make.bottom.equalTo(self->_transitionSegment.mas_top).offset(-3);
        make.height.equalTo(@30);
    }];
    
    [_labelArray[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_transitionSegment.mas_right);
        make.bottom.equalTo(self->_transitionSegment.mas_top);
        make.width.height.equalTo(self->_labelArray[0]);
    }];
    
    [_labelArray[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_labelArray[0].mas_right);
        make.right.equalTo(self->_labelArray[2].mas_left);
        make.width.height.bottom.equalTo(self->_labelArray[0]);
    }];

    
    _valueSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [_valueSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_valueSlider];
    [_valueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_transitionSegment);
        make.bottom.equalTo(self->_transitionSegment.mas_top).offset(-48);
        make.height.equalTo(@30);
    }];
    
    _animationSwitch = [[UISwitch alloc] init];
    [self addSubview:_animationSwitch];
    [_animationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(@28);
        make.width.equalTo(@80);
        make.bottom.equalTo(self->_valueSlider.mas_top).offset(-5);
    }];
    UILabel *markLabel = [[UILabel alloc] init];
    markLabel.text = @"动画开关";
    markLabel.font = [UIFont boldSystemFontOfSize:12];
    [self addSubview:markLabel];
    [markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_animationSwitch);
        make.height.equalTo(@20);
        make.bottom.equalTo(self->_animationSwitch.mas_top);
    }];
    
}

- (void)sliderValueChange:(UISlider *)slider {
    _angleArr[_segmentIndex] = slider.value * M_PI;
    _labelArray[_segmentIndex].text = [NSString stringWithFormat:@"PI * %.3f",slider.value];
}

- (void)segmentValueChange:(UISegmentedControl *)segment {
    _segmentIndex = segment.selectedSegmentIndex;
    [self freshSliderValue];
}

- (void)freshSliderValue {
    [self.valueSlider setValue:_angleArr[_segmentIndex] / M_PI  animated:YES];
}


- (void)rotation3D {
//    CATransform3D rotate =  CATransform3DMakeRotation(_angleArr[_segmentIndex], _segmentIndex == 0, _segmentIndex == 1, _segmentIndex == 2);
    CATransform3D rotate =  CATransform3DMakeRotation(_angleArr[_segmentIndex], _angleArr[0]>0, _angleArr[1]>0, _angleArr[2]>0);
    self.animationView.layer.transform = rotate;
}



#pragma mark - API
- (void)callMethodIndex:(NSInteger)index {
    if (index == 0) {
        [self backOriginFrame];
    }else if (index == 1) {
        [self rotation2DAnimation:self.animationSwitch.isOn];
    }else if (index == 2) {
        [self rotation3DAnimation:self.animationSwitch.isOn];
    }else if (index == 3) {
        [self wobble2D];
    }else if (index == 4) {
        [self wobble3D];
    }else if (index == 5) {
        [self groupAnimationHidden];
    }else if (index == 6) {
        [self transform3DMakeScale:self.animationSwitch.isOn];
    }
}




- (void)backOriginFrame {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         self.animationView.transform = CGAffineTransformIdentity;
         self.animationView.layer.transform = CATransform3DIdentity;
     } completion:^(BOOL finished) {
         //         self.animationView.layer.transform = CATransform3DIdentity;
         //         [self layerRotation];
     }];
}

- (void)rotation2DAnimation:(BOOL)animation {
    CGFloat angleValue = _angleArr[_segmentIndex];
    if (animation) {
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            self->_animationView.transform=CGAffineTransformMakeRotation(angleValue);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self->_animationView.transform=CGAffineTransformMakeRotation(angleValue);
    }
}

- (void)rotation3DAnimation:(BOOL)animation {
    CATransform3D rotate =  CATransform3DMakeRotation(_angleArr[_segmentIndex], _angleArr[0]/M_PI, _angleArr[1]/M_PI, _angleArr[2]/M_PI);
    if (animation) {
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.animationView.layer.transform = rotate;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.animationView.layer.transform = rotate;
    }
}

- (void)transform3DMakeScale:(BOOL)animation {
    CATransform3D scale = CATransform3DMakeScale(_angleArr[0]/M_PI, _angleArr[1]/M_PI, _angleArr[2]/M_PI);
    if (animation) {
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.animationView.layer.transform = scale;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.animationView.layer.transform = scale;
    }
}

- (void)wobble2D {
    [self beginWobble2D];
}
- (void)wobble3D {
    [self layerWobble];
}

- (void)textfieldFist {
    [self.textfield becomeFirstResponder];
}

- (void)groupAnimationShow {
    CAKeyframeAnimation *animWobble     = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animWobble.values = [NSArray arrayWithObjects:
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.0), 0,1,0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.1), 0.1,1,0.1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/1.9), 0.1,1,0.1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.0), 0,1,0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                         nil];
    animWobble.keyTimes = @[@(0),@(0.05),@(0.08),@(0.1),@(1)];
    animWobble.autoreverses = NO;
    animWobble.fillMode = kCAFillModeForwards;
    animWobble.removedOnCompletion = NO;
    
    CAAnimationGroup * _group = [CAAnimationGroup animation];
    _group.animations = @[animWobble];
    _group.duration = 1.2f;
    _group.autoreverses = NO;
    _group.fillMode = kCAFillModeForwards;
    _group.removedOnCompletion = NO;
    [_group setValue:@"animationGroupShow" forKey:@"AnimationKey"];
    _group.delegate = self;
    [self.animationView.layer addAnimation:_group forKey:nil];
}

- (void)groupAnimationHidden {
#if 1
    CAKeyframeAnimation *animWobble     = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animWobble.values = [NSArray arrayWithObjects:
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.2, 0.1,1,0.1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5, 0.2,1,0.2)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-0.5, 0.2,1,0.2)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.0), 0,1,0)],
                         nil];
    animWobble.keyTimes = @[@(0),@(0.1),@(0.25),@(0.4),@(0.5),@(1)];
    animWobble.autoreverses = NO;
    animWobble.fillMode = kCAFillModeForwards;
    animWobble.removedOnCompletion = NO;
    
   CAAnimationGroup * _group = [CAAnimationGroup animation];
    _group.animations = @[animWobble];
    _group.duration = 1.2f;
    _group.autoreverses = NO;
    _group.fillMode = kCAFillModeForwards;
    _group.removedOnCompletion = NO;
    [_group setValue:@"groupAnimationHidden" forKey:@"AnimationKey"];
    _group.delegate = self;
    [self.animationView.layer addAnimation:_group forKey:nil];
    
#else
    CAKeyframeAnimation * scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnim.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)],                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)],                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]                       ];
    scaleAnim.keyTimes = @[@(0),@(0.3),@(0.7),@(1)];
    scaleAnim.autoreverses = NO;
    scaleAnim.fillMode = kCAFillModeForwards;
    scaleAnim.removedOnCompletion = NO;
    
    CAKeyframeAnimation * posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    posAnim.values = @[[NSValue valueWithCGPoint:self.animationView.layer.position],                       [NSValue valueWithCGPoint:self.animationView.layer.position],                       [NSValue valueWithCGPoint:CGPointMake(self.animationView.layer.position.x+200, 400)],[NSValue valueWithCGPoint:CGPointMake(self.animationView.layer.position.x+200, 400)]                       ];
    posAnim.keyTimes = @[@(0),@(0.3),@(0.7),@(1)];
    posAnim.autoreverses = NO;
    posAnim.fillMode = kCAFillModeForwards;
    posAnim.removedOnCompletion = NO;
    
    CAAnimationGroup * _group = [CAAnimationGroup animation];
    _group = [CAAnimationGroup animation];
    _group.animations = @[scaleAnim,posAnim];
    _group.duration = 5.0f;
    _group.autoreverses = NO;
    _group.fillMode = kCAFillModeForwards;
    _group.removedOnCompletion = NO;
    _group.delegate = self;
    [self.animationView.layer addAnimation:_group forKey:nil];
    
#endif
}






-(void)beginWobble2D
{
    [UIView animateWithDuration:0.1 delay:0.1 options:0  animations:^
     {
         self->_animationView.transform = CGAffineTransformMakeRotation(- 0.1);
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction  animations:^
          {
              self->_animationView.transform=CGAffineTransformMakeRotation(0.1);
          } completion:^(BOOL finished) {
              
          }];
     }];
    [self performSelector:@selector(endWobble2D) withObject:nil afterDelay:3];
}
- (void)endWobble2D
{
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         self->_animationView.transform = CGAffineTransformIdentity;
     } completion:^(BOOL finished) {
//         self.animationView.layer.transform = CATransform3DIdentity;
//         [self layerRotation];
     }];
}

- (CAKeyframeAnimation *)layerWobbleAnim {
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5, 0.2,1,0.2)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-0.5, 0.2,1,0.2)],
                           nil];
    
    keyAnimation.cumulative = NO;
    
//    keyAnimation.duration = 0.25;
    
//    keyAnimation.repeatCount = 3;
    
    keyAnimation.autoreverses = YES;
    
    keyAnimation.removedOnCompletion = YES;
    
    return keyAnimation;
}

- (CAKeyframeAnimation *)layerRotationAnim {
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    
    // 旋转角度， 其中的value表示图像旋转的最终位置
    keyAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2.05), 0,1,0)],
                           nil];
    
    keyAnimation.cumulative = NO;
    
//    keyAnimation.duration = 0.25;
    
    keyAnimation.repeatCount = 1;
    
    keyAnimation.removedOnCompletion = NO;
    
    return keyAnimation;
}

- (void)layerWobble {
    CAKeyframeAnimation *keyAnimation = [self layerWobbleAnim];

    keyAnimation.delegate = self;
    [keyAnimation setValue:@"startlayerWobble" forKey:@"AnimationKey"];

    [_animationView.layer addAnimation:keyAnimation forKey:@"transform"];

}

- (void)layerRotation {
    
    CAKeyframeAnimation *keyAnimation = [self layerRotationAnim];
    
    keyAnimation.delegate = self;

    [keyAnimation setValue:@"startlayerRotation" forKey:@"AnimationKey"];
    [_animationView.layer addAnimation:keyAnimation forKey:@"transform"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"startlayerWobble"]) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//#if fieldLeftMode
//                self.textfield.rightView = nil;
//                self.textfield.rightViewMode = UITextFieldViewModeNever;
//#endif
//                [self layerRotation];
//            });
        } else if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"startlayerRotation"]) {
//            CATransform3D turnTrans = CATransform3DMakeRotation(M_PI/2.05, 0, 1, 0);
//            self.animationView.layer.transform = turnTrans;
//            return;
            
        } else if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"groupAnimationHidden"]) {
            [self.textfield becomeFirstResponder];
            self.textfield.leftViewMode = UITextFieldViewModeNever;
            self.textfield.tintColor = [UIColor blueColor];
        } else if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"groupAnimationShow"]) {
            if (self.textfield.text.length) {
                self.textfield.tintColor = [UIColor blueColor];
            }else{
                self.textfield.tintColor = [UIColor clearColor];
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textfield resignFirstResponder];
}

@end
