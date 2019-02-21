//
//  CollectionViewListCommonCell.m
//  DQUIViewlib
//
//  Created by lxw on 2019/2/21.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "CollectionViewListCommonCell.h"

@implementation CollectionViewListCommonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}


@end
