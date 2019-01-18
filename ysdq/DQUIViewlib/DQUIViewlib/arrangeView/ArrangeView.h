//
//  ArrangeView.h
//  DQUIViewlib
//
//  Created by lxw on 2019/1/18.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "SASView.h"
#import "ArrangeItemView.h"

NS_ASSUME_NONNULL_BEGIN

@class ArrangeView;

@protocol ArrangeViewDataSource <NSObject>
@required
- (NSInteger)numberOfArrangeItemsInArrangeView:(ArrangeView *)arrangeView;
- (ArrangeItemView *)arrangeView:(ArrangeView *)arrangeView itemViewOfIndex:(NSInteger)index;
@end

@protocol ArrangeViewDelegate <NSObject>
@optional
- (void)arrangeView:(ArrangeView *)arrangeView didSelectedIndex:(NSInteger)index;
@end


@interface ArrangeView : SASView
@property (nonatomic, assign) id<ArrangeViewDataSource>dataSouce;
@property (nonatomic, assign) id<ArrangeViewDelegate>delegate;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
