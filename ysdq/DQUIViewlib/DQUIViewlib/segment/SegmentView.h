//
//  SegmentView.h
//  DQUIViewlib
//
//  Created by lxw on 2018/7/17.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView
- (instancetype)initWithItems:(nullable NSArray *)items; // items can be NSStrings or UIImages. control is automatically sized to fit content
@end
