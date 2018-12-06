//
//  AirPlayViewTableViewCell.h
//  DQUIViewlib
//
//  Created by lxw on 2018/10/15.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirPlayView.h"

@interface AirPlayViewTableViewCell : UITableViewCell
@property (nonatomic, strong) AirPlayView *airPlayView;
- (void)setViewModel:(id)viewModel;

@end
