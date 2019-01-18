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
        [self configureUIItems];
    }
    return self;
}

- (void)configureUIItems {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    NSString *title = self.titleLabel.text;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    rect.size.width +=4;
    rect.size.height+=0;
    
    rect.size.width = (rect.size.width > 100)? 100 : rect.size.width;
    attributes.frame = rect;
    return attributes;
}


@end

@implementation NSString (fontSize)

- (CGSize)sizeWithFont:(UIFont *)font {
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:self];
    [attString addAttribute:NSFontAttributeName             //文字字体
                      value:font?:[UIFont systemFontOfSize:17]
                      range:NSMakeRange(0, self.length)];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CFRange visibleRange;
    CGSize constraint = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGSize newSize   = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self length]), nil, constraint, &visibleRange);
    CFRelease(framesetter);
    return newSize;
}

@end
