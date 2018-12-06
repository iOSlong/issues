//
//  AirPlayViewTableViewCell.m
//  DQUIViewlib
//
//  Created by lxw on 2018/10/15.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AirPlayViewTableViewCell.h"
@implementation AirPlayViewTableViewCell

- (void)setViewModel:(id)viewModel {
    if (!self.airPlayView) {
        self.airPlayView = [[AirPlayView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [self addSubview:self.airPlayView];
    }
    [self.airPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
