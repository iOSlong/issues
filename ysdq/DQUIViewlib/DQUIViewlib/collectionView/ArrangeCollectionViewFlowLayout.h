//
//  ArrangeCollectionViewFlowLayout.h
//  DQUIViewlib
//
//  Created by lxw on 2019/1/18.
//  Copyright © 2019 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ArrangeAlignment) {
    ArrangeAlignmentBalance,//默认平均分布
    ArrangeAlignmentLeft,   //左对齐
    ArrangeAlignmentRight,  //右对齐
    ArrangeAlignmentCenter, //居中对齐
};

@interface ArrangeCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat spanHorizonal;
@property (nonatomic, assign) ArrangeAlignment arrangeAlignment;
@end

NS_ASSUME_NONNULL_END
