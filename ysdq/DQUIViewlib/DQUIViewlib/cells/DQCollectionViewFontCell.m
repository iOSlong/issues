//
//  DQCollectionViewFontCell.m
//  DQUIViewlib
//
//  Created by lxw on 2018/12/12.
//  Copyright © 2018 lxw. All rights reserved.
//

#import "DQCollectionViewFontCell.h"

@implementation DQCollectionViewFontCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = RGBCOLOR_HEX(0x17202F);
}

- (void)setKeyInfo:(NSDictionary *)keyInfo {
    _keyInfo = keyInfo;
    NSString *fontName  = [keyInfo objectForKey:DQFONTNAME];
    NSString *show      = [keyInfo objectForKey:DQTITLESHOW];
    UIFont *font = [UIFont fontWithName:fontName size:19];
    [self.labelFont setFont:font];
    [self.labelFont setText:show];
    [self.labelFont setTextColor:RGBCOLOR_HEX(0x999999)];
    self.labelFont.numberOfLines = 0;
}

@end
