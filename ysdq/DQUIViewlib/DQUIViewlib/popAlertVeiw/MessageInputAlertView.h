//
//  MessageInputAlertView.h
//  DQUIViewlib
//
//  Created by lxw on 2019/1/22.
//  Copyright © 2019 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MSGInputAlertEvent) {
    MSGInputAlertEventSubmit,
    MSGInputAlertEventClose,
};

@class MessageInputAlertView;

typedef void(^InputAlertAction)(MessageInputAlertView *alertView, MSGInputAlertEvent event);

@interface MessageInputAlertView : UIView
@property (nonatomic, strong) UIImageView   *backgroudImageView;
@property (nonatomic, strong) UIButton      *closeButton;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UITextField   *messageField;
@property (nonatomic, strong) UIView        *centerLine;
@property (nonatomic, strong) UILabel       *descLabel;
@property (nonatomic, strong) UIButton      *submitButton;
@property (nonatomic, copy) InputAlertAction alertAction;
@end




typedef void(^DecisionAction)(BOOL confirm);
@interface DecisionAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)description decision:(DecisionAction)action;
@end

NS_ASSUME_NONNULL_END
