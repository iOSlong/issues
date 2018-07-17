//
//  SegmentView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/17.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "SegmentView.h"

#define ITEMTAG_FROMINDEX(N) (100+N)
#define INDEX_FROMITEMTAG(TAG) (TAG - 100)

@interface SegmentView()
@property (nonatomic, strong) NSArray   *items;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *segmentItems;
@end

@implementation SegmentView

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        _items = items;
        [self configureItems];
    }
    return self;
}
- (void)configureItems {
    self.segmentItems = [NSMutableArray array];
    for (int i = 0; i < self.items.count; i ++) {
        id obj = self.items[i];
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.layer.cornerRadius = 5;
        item.layer.borderColor = [UIColor blueColor].CGColor;
        item.layer.borderWidth = 2;
        if ([obj isKindOfClass:[NSString class]]) {
            [item setTitle:obj forState:UIControlStateNormal];
        }else if ([obj isKindOfClass:[UIImage class]]) {
            [item setImage:obj forState:UIControlStateNormal];
        }
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = ITEMTAG_FROMINDEX(i);
        [self.segmentItems addObject:item];
        [self addSubview:item];
    }
}

- (void)updateItemsFrame {
    CGFloat viewW = self.frame.size.width / self.segmentItems.count;
    CGFloat viewH = self.frame.size.height;
    CGFloat lastLocationX = 0;
    for (int i = 0; i < self.items.count; i ++) {
        UIView *itemV = self.segmentItems[i];
        itemV.frame = CGRectMake(lastLocationX, 0, viewW, viewH);
        lastLocationX += viewW;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateItemsFrame];
}

- (void)itemClicked:(UIView *)sender {
    NSInteger index = INDEX_FROMITEMTAG(sender.tag);
    NSLog(@"click index = %ld",(long)index);
}
@end
