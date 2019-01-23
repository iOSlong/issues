//
//  MessageInputAlertView.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/22.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "MessageInputAlertView.h"

@implementation MessageInputAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUIItems];
    }
    return self;
}

- (void)buildUIItems {
    _backgroudImageView = [UIImageView new];
    [self addSubview:_backgroudImageView];
    [_backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _closeButton.titleLabel.text = @"X";
    [_closeButton addTarget:self
                     action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.height.equalTo(@34);
    }];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [_titleLabel setText:@"愿望片单"];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_titleLabel setTextColor:RGBACOLOR_HEX(0x000000, 0.9)];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(40);
        make.height.equalTo(@16);
    }];
    
    _messageField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    _messageField.borderStyle = UITextBorderStyleNone;
    _messageField.placeholder = @"输入什么？";
    [self addSubview:_messageField];
    [_messageField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(26);
        make.left.equalTo(self.mas_left).offset(26);
        make.right.equalTo(self.mas_right).offset(-26);
        make.height.equalTo(@44);
    }];
    
    _centerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 1)];
    _centerLine.backgroundColor = RGBACOLOR_HEX(0x000000, 0.15);
    [self addSubview:_centerLine];
    [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageField.mas_bottom).offset(4);
        make.left.equalTo(self.messageField.mas_left);
        make.right.equalTo(self.messageField.mas_right);
        make.height.equalTo(@1);
    }];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [_descLabel setText:@"大全采用机器识别，准确填写片单名称 可提高愿望实现的机会哦"];
    [_descLabel setNumberOfLines:2];
    [_descLabel setTextAlignment:NSTextAlignmentCenter];
    [_descLabel setFont:[UIFont systemFontOfSize:14]];
    [_descLabel setTextColor:RGBACOLOR_HEX(0x000000, 0.6)];
    [self addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerLine.mas_bottom).offset(18);
        make.left.equalTo(self.centerLine.mas_left);
        make.right.equalTo(self.centerLine.mas_right);
    }];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 38)];
    [_submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.backgroundColor = [UIColor blueColor];
    [_submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@45);
        make.width.equalTo(@190);
    }];
    
    
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 6;
    
    
    [_closeButton showBorderLine];
    [_descLabel showBorderLine];
    [_messageField showBorderLine];
    [_titleLabel showBorderLine];
}

- (void)submit:(UIButton *)button {
    if (self.alertAction) {
        self.alertAction(self, MSGInputAlertEventSubmit);
    }
}

- (void)close:(UIButton *)button {
    if (self.alertAction) {
        self.alertAction(self, MSGInputAlertEventClose);
    }
}

@end




@implementation DecisionAlertView {
    DecisionAction _decisionAction;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)description decision:(DecisionAction)action {
    self = [super initWithFrame:frame];
    if (self) {
        _decisionAction = action;
       UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleLabel setTextColor:RGBACOLOR_HEX(0x000000, 0.9)];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(16);
            make.height.equalTo(@24);
        }];
        
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        [descLabel setText:description];
        [descLabel setNumberOfLines:0];
        [descLabel setTextAlignment:NSTextAlignmentCenter];
        [descLabel setFont:[UIFont systemFontOfSize:16]];
        [descLabel setTextColor:RGBACOLOR_HEX(0x000000, 0.6)];
        [self addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(24);
            make.left.equalTo(self.mas_left).offset(24);
            make.right.equalTo(self.mas_right).offset(-24);
        }];

        
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 1)];
        horizontalLine.backgroundColor = RGBACOLOR_HEX(0x000000, 0.15);
        [self addSubview:horizontalLine];
        [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-54);
            make.height.equalTo(@1);
        }];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 54)];
        verticalLine.backgroundColor = RGBACOLOR_HEX(0x000000, 0.15);
        [self addSubview:verticalLine];
        [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(horizontalLine.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@1);
        }];
        
        
        UIButton *cacelButton = [self buttonDecisiton:@"取消" action:@selector(cancel:) titleColor:RGBACOLOR_HEX(0x000000, 0.6)];
        [self addSubview:cacelButton];
        [cacelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(horizontalLine.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(verticalLine.mas_left);
            make.bottom.equalTo(self.mas_bottom);
        }];

    
        UIButton *confirmBtn = [self buttonDecisiton:@"确认" action:@selector(confirm:) titleColor:RGBACOLOR_HEX(0x3599F8, 1)];
        [self addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(horizontalLine.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.left.equalTo(verticalLine.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 6;
    }
    return self;
}

- (UIButton *)buttonDecisiton:(NSString *)title action:(SEL)action titleColor:(UIColor *)color {
    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 38)];
    [buton setTitle:title forState:UIControlStateNormal];
    [buton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [buton setTitleColor:color forState:UIControlStateNormal];
    [buton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return buton;
}
- (void)confirm:(UIButton *)sender {
    if (_decisionAction) {
        _decisionAction(YES);
    }
}
- (void)cancel:(UIButton *)sender {
    if (_decisionAction) {
        _decisionAction(NO);
    }
}

@end
