//
//  UIView+SARRS.m
//  Le123PhoneClient
//
//  Created by wangchao9 on 2017/6/1.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import "UIView+SARRS.h"
@import ObjectiveC;

@implementation UIView (SARRS_)
+ (instancetype)ancestorForObject:(UIView*)view {
    if (!view) {
        return nil;
    }
    return [view ancestorForClass:self];
}

- (UIView*)ancestorForClass:(Class)clazz {
    UIView*result = self.superview;
    while (result && ![result isKindOfClass:clazz]) {
        result = result.superview;
    }

    return result;
}

+ (instancetype)autolayoutView {
    UIView *view = [[self alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];

    return view;
}

@end

@implementation UIView (ViewController)
- (UIViewController*)viewController {
    for (UIView *next = [self superview];next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }

    UIResponder *nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return (UIViewController*)nextResponder;
    }

    return nil;
}
@end

@implementation UIView (CalculatorHeight)

- (CGSize)calculateSizeThatFits:(CGFloat)contentViewWidth parentView:(UIView*)parentView {
    UIView*contentView = self;
    // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
    // of growing horizontally, in a flow-layout manner.
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];

    // [bug fix] after iOS 10.3, Auto Layout engine will add an additional 0 width constraint onto cell's content view, to avoid that, we add constraints to content view's left, right, top and bottom.
    static BOOL            isSystemVersionEqualOrGreaterThen10_2 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isSystemVersionEqualOrGreaterThen10_2 = [UIDevice.currentDevice.systemVersion compare:@"10.2" options:NSNumericSearch] != NSOrderedAscending;
    });

    NSArray<NSLayoutConstraint*> *edgeConstraints;
    if (isSystemVersionEqualOrGreaterThen10_2) {
        // To avoid confilicts, make width constraint softer than required (1000)
        widthFenceConstraint.priority = UILayoutPriorityRequired - 1;

        // Build edge constraints
        NSLayoutConstraint *leftConstraint   = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *rightConstraint  = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *topConstraint    = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        edgeConstraints = @[leftConstraint, rightConstraint, topConstraint, bottomConstraint];
        [parentView addConstraints:edgeConstraints];
    }

    [contentView addConstraint:widthFenceConstraint];

    // Auto layout engine does its math
    CGFloat fittingHeight = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    // Clean-ups
    [contentView removeConstraint:widthFenceConstraint];
    if (isSystemVersionEqualOrGreaterThen10_2) {
        [parentView removeConstraints:edgeConstraints];
    }
    return CGSizeMake(contentViewWidth, fittingHeight);
}

@end
#ifdef DEBUG
    #define DEBUG_MAKESUPER_ON_MAINTHREAD 0
#else  /* ifdef DEBUG */
    #define DEBUG_MAKESUPER_ON_MAINTHREAD 0
#endif /* ifdef DEBUG */

#if DEBUG_MAKESUPER_ON_MAINTHREAD

    @implementation UIView (AvoidCrash)
    + (void)load {
        NTYSwizzle(nos, setNeedsLayout);
        NTYSwizzle(nos, setNeedsDisplay);
        NTYSwizzle(nos, setNeedsDisplayInRect:);
        NTYSwizzle(nos, addSubview:);
        NTYSwizzle(nos, removeFromSuperview);
        NTYSwizzle(nos, addConstraints:);
        NTYSwizzle(nos, removeConstraints:);
        NTYSwizzle(nos, addConstraint:);
        NTYSwizzle(nos, removeConstraint:);
    }

    - (void)nos_addConstraint:(NSLayoutConstraint*)constraint {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_addConstraint:constraint];
    }];
    }

    - (void)nos_removeConstraint:(NSLayoutConstraint*)constraint {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_removeConstraint:constraint];
    }];
    }

    - (void)nos_addConstraints:(NSArray<__kindof NSLayoutConstraint*>*)constraints {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_addConstraints:constraints];
    }];
    }

    - (void)nos_removeConstraints:(NSArray<__kindof NSLayoutConstraint*>*)constraints {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_removeConstraints:constraints];
    }];
    }

    - (void)nos_addSubview:(UIView*)view {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_addSubview:view];
    }];
    }

    - (void)nos_removeFromSuperview {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_removeFromSuperview];
    }];
    }
    - (void)nos_setNeedsLayout {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_setNeedsLayout];
    }];
    }

    - (void)nos_setNeedsDisplay {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"当前线程不在主线程");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_setNeedsDisplay];
    }];
    }
    - (void)nos_setNeedsDisplayInRect:(CGRect)rect {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_setNeedsDisplayInRect:rect];
    }];
    }
    @end
    @implementation UITableView (AvoidCrash)
    + (void)load {
        NTYSwizzle(nos, setTableHeaderView:);
        NTYSwizzle(nos, setTableFooterView:);
    }

    - (void)nos_setTableHeaderView:(UIView*)tableHeaderView {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_setTableHeaderView:tableHeaderView];
    }];
    }

    - (void)nos_setTableFooterView:(UIView*)tableFooterView {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_setTableFooterView:tableFooterView];
    }];
    }

    @end

    @implementation UIViewController (AvoidCrash)
    + (void)load {
        NTYSwizzle(nos, addChildViewController:);
    }

    - (void)nos_addChildViewController:(UIViewController*)childController {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_addChildViewController:childController];
    }];
    }

    @end

    @implementation UIPageViewController (AvoidCrash)
    + (void)load {
        NTYSwizzle(nos, setViewControllers: direction: animated: completion:);
    }

    - (void)nos_setViewControllers:(NSArray<UIViewController*>*)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion {
   #ifdef DEBUG
            NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
        [BZXDispatch ui:^{
        [self nos_setViewControllers:viewControllers direction:direction animated:animated completion:completion];
    }];
    }

    @end

    @implementation BZXCALayer (AvoidCrash)
    + (void)load {
        NTYSwizzle(nos, setNeedsLayout);
        NTYSwizzle(nos, setNeedsDisplay);
        NTYSwizzle(nos, setNeedsDisplayInRect:);
    }

    #if 0 /// 会误杀WebThread
        - (void)nos_setNeedsLayout {
   #ifdef DEBUG
                NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
            [BZXDispatch ui:^{
        [self nos_setNeedsLayout];
    }];
        }

        - (void)nos_setNeedsDisplay {
   #ifdef DEBUG
                NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
            [BZXDispatch ui:^{
        [self nos_setNeedsDisplay];
    }];
        }
        - (void)nos_setNeedsDisplayInRect:(CGRect)rect {
   #ifdef DEBUG
                NTYAssert([NSThread isMainThread], @"");
   #endif // ifdef DEBUG
            [BZXDispatch ui:^{
        [self nos_setNeedsDisplayInRect:rect];
    }];
        }
    #endif // if 0
    @end
#endif // if DEBUG


@implementation UIView (BorderDebug)
- (void)showBorderLine {
#ifdef DEBUG
    self.layer.borderColor = [UIColor cyanColor].CGColor;
    self.layer.borderWidth = 1;
#endif
}
- (void)showBorderLineColor:(UIColor *)color {
#ifdef DEBUG
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
#endif
}
@end

