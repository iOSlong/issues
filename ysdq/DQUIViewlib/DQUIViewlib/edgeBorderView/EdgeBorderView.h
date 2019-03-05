//
//  EdgeBorderView.h
//  DQUIViewlib
//
//  Created by lxw on 2019/2/27.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "SASView.h"

typedef struct EdgeBorder {
    UIRectEdge edge;
    UIEdgeInsets insets;
}EdgeBorder;

EdgeBorder EdgeBorderMake(UIRectEdge edge, UIEdgeInsets insets);


NS_ASSUME_NONNULL_BEGIN

@interface EdgeBorderView : SASView<ApiControlEnable>
@property (nonatomic, assign) EdgeBorder edgeBorder;
@property (nonatomic, strong) UIColor *borderColor;
@end

NS_ASSUME_NONNULL_END
