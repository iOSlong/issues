//
//  UIView+SARRS.h
//  Le123PhoneClient
//
//  Created by wangchao9 on 2017/6/1.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SARRS)
/**
 * 按照层级关系,找到view的类型为Self的祖先
 *
 *  @param view 寻找的起点
 *
 *  @return 祖先对象, nil表示没有找到
 */
+ (instancetype)ancestorForObject:(UIView*)view;
/**
 *  按照层级关系,找到特定类的直系祖先
 *
 *  @param clazz 祖先的类型
 *
 *  @return 对应类型的祖先对象, nil表示没有找到
 */
- (id)ancestorForClass:(Class)clazz;

+ (instancetype)autolayoutView;

@end


@interface UIView (ViewController)
/**
 *  通过响应链,找到对应的viewController
 */
@property (nonatomic,readonly) UIViewController *viewController;
@end

@interface UIView (CalculatorHeight)
- (CGSize)calculateSizeThatFits:(CGFloat)contentViewWidth parentView:(UIView*)parentView;
@end


@interface UIView (BorderDebug)
- (void)showBorderLine;
- (void)showBorderLineColor:(UIColor *)color;
@end

