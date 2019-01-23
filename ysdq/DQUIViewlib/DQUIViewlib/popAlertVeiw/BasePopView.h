//
//  BasePopView.h
//  DQUIViewlib
//
//  Created by lxw on 2019/1/22.
//  Copyright © 2019 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, BasePopType) {
    BasePopTypeFade           = 0,
    BasePopTypeSlideBottomTop = 1, //从下向上
    BasePopTypeSlideTopBottom = 2, //从上向下
    BasePopTypeSlideLeftRight = 3, //从左到右
    BasePopTypeSlideRightLeft = 4, //从右到左
};

@class BasePopView;

typedef void (^BasePopViewCancelHandler)(BasePopView *popView);
typedef void (^showCompletion)(void);


@interface BasePopView : UIView

@property (nonatomic, assign) BasePopType          type;
@property (nonatomic, strong) UIView                  *popContentView;
@property (nonatomic, strong) UIColor                 *popBackgroudColor;
@property (nonatomic, copy) BasePopViewCancelHandler  cancelHandler;         //!<取消回调
@property (nonatomic, copy) showCompletion             showCompletionHandler; //显示动画结束

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;           //!<必须通过iniWithFram进行初始化
+ (instancetype)fullScreenView;                        //!<获取全屏大小的view
+ (instancetype)fullScreenViewWith:(CGFloat)popHeight; //!<自适应半屏高度
- (instancetype)initWithFrame:(CGRect)frame with:(CGFloat)popContentContentHeight;

- (void)showInView:(UIView*)view animated:(BOOL)animated isEpisode:(BOOL)isEpisode;
- (void)showInView:(UIView*)view;
- (void)show;
- (void)cancel;
- (void)cancelCompletion:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
