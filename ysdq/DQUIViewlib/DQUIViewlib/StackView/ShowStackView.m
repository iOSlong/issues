//
//  ShowStackView.m
//  DQUIViewlib
//
//  Created by lxw on 2019/6/17.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "ShowStackView.h"

@implementation ShowStackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureStackView];
    }
    return self;
}

- (void)configureStackView {
    [self showBorderLine];
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:self.bounds];
    [self addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    label1.text = @"肃肃兔罝";
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    label2.text = @"肃肃兔罝，椓之丁丁";
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    label3.text = @"肃肃兔罝，椓之丁丁，赳赳武夫，公侯干城";
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    label4.numberOfLines = 0;
    label4.text = @"兔罝：肃肃兔罝，施于中逵，赳赳武夫，公侯好仇，公侯腹心";
    
    NSArray *labels = @[label1,label2,label3,label4];
    for (UIView *label in labels) {
        [label showBorderLineColor:UIColor.redColor];
        [stackView addArrangedSubview:label];
    }
    
    stackView.axis = UILayoutConstraintAxisVertical;//default-horizonal
    stackView.alignment = UIStackViewAlignmentLeading;//default
    stackView.distribution  = UIStackViewDistributionFillEqually;
    
    stackView.spacing = 5;
}

@end
