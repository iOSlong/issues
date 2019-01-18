//
//  ArrangeView.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/18.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "ArrangeView.h"

@interface ArrangeView ()
@property (nonatomic, strong) NSArray <ArrangeItemView *> *items;
@end

@implementation ArrangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self reloadData];
    }
    return self;
}
- (void)reloadData {
    if ([self.dataSouce respondsToSelector:@selector(numberOfArrangeItemsInArrangeView:)]) {
        
    }
}
@end
