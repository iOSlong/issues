//
//  ControlView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/8/9.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "ControlView.h"

@interface ControlView ()
@property (nonatomic, strong) NSMutableDictionary  *stateInfo;
@property (nonatomic, assign) BOOL isHightlight;
@end


@implementation ControlView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (NSString *)keyElementClass:(Class)class state:(UIControlState)state {
    NSString *key = [NSString stringWithFormat:@"%@_state_%ld",NSStringFromClass(class), state];
    return key;
}

- (NSObject *)elementState:(UIControlState)state class:(Class)class {
    NSString *key = [self keyElementClass:class state:state];
    return [self.stateInfo objectForKey:key];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self.titleLabel setText:title];
    [self.stateInfo setObject:title forKey:[self keyElementClass:NSString.class state:state]];
}

- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state {
    [self.titleLabel setFont:font];
    [self.stateInfo setObject:font forKey:[self keyElementClass:UIFont.class state:state]];
}
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.titleLabel.textColor = color;
    [self.stateInfo setObject:color forKey:[self keyElementClass:UIColor.class state:state]];
}
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.stateInfo setObject:image forKey:[self keyElementClass:UIImage.class state:state]];
}


- (void)setup {
    self.stateInfo = [NSMutableDictionary dictionary];

    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
  
    [self addTarget:self action:@selector(controlTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)controlTouchUpInside:(UIControl *)control {
    control.selected = !control.selected;
    [self refreshState];
    NSLog(@"");
}


- (void)refreshState {
    NSString *stateTitle = (NSString *)[self elementState:self.state class:NSString.class];
    UIColor *stateColor = (UIColor *)[self elementState:self.state class:UIColor.class];
    UIFont *stateFont = (UIFont *)[self elementState:self.state class:UIFont.class];
    NSLog(@"%@",stateTitle);
    if (stateTitle) {
        [self.titleLabel setText:stateTitle];
    }
    if (stateColor) {
        [self.titleLabel setTextColor:stateColor];
    }
    if (stateFont) {
        [self.titleLabel setFont:stateFont];
    }
    switch (self.state) {
        case UIControlStateNormal:
        {
            
        }
            break;
        case UIControlStateSelected:
        {
            
        }
            break;
        case UIControlStateHighlighted:{
            [UIView animateWithDuration:0.1 animations:^{
                [self setBackgroundColor:UIColor.yellowColor];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark inherit methods
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (_isHightlight != highlighted) {
        _isHightlight = highlighted;
        NSLog(@"hightlight = %d",highlighted);
        [self refreshState];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchP = [touch locationInView:self];
    [self refreshState];
    if (CGRectContainsPoint([self bounds], touchP)) {
        return YES;
    }
    return NO;
}
//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    [self refreshState];
//    if(self.touchInside == YES){
//        return YES;
//    }
//    return NO;
//}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    //TODO: 恢复正常状态
    [self refreshState];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    [self refreshState];
    //TODO: 恢复正常状态
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
