//
//  ArrangeCollectionViewCell.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/18.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "ArrangeCollectionViewCell.h"
#import <CoreText/CoreText.h>

@implementation ArrangeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 8;
        [self showBorderLine];
        [self configureUIItems];
    }
    return self;
}

- (void)configureUIItems {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize contentSize = [self sizeContentFit];
    attributes.frame = CGRectMake(0, 0, contentSize.width + 4, contentSize.height + 10);
    return attributes;
}

- (CGSize)sizeContentFit {
    NSString *contentText = self.titleLabel.text;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:contentText attributes:@{NSFontAttributeName:self.titleLabel.font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CGSize constraint = CGSizeMake(300, CGFLOAT_MAX);
    CGSize newSize   = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [contentText length]), nil, constraint, nil);
    CFRelease(framesetter);
    return newSize;
}

@end
