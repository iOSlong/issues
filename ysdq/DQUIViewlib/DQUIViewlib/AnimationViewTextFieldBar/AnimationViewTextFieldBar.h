//
//  AnimationViewTextFieldBar.h
//  DQUIViewlib
//
//  Created by lxw on 2018/10/11.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationViewTextFieldBar : UIView<ApiControlEnable>

- (void)textfieldResignFirstResponder;
- (void)textfiledBecomeFirstResponder;

- (void)removeAllAnimations;

@end

NS_ASSUME_NONNULL_END
