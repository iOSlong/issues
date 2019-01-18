//
//  ArrangeCollectionViewFlowLayout.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/18.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "ArrangeCollectionViewFlowLayout.h"

@implementation ArrangeCollectionViewFlowLayout


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAtris = [super layoutAttributesForElementsInRect:rect];
    if (layoutAtris) {
        switch (self.arrangeAlignment) {
                case ArrangeAlignmentBalance:
                return layoutAtris;
                break;
                case ArrangeAlignmentLeft:
                case ArrangeAlignmentRight:
            default:
                break;
        }
        for (int i = 0; i < layoutAtris.count - 1; i ++) {
            UICollectionViewLayoutAttributes *curAtr    = layoutAtris[i];
            UICollectionViewLayoutAttributes *nextAtr   = layoutAtris[i + 1];
            
            if (CGRectGetMinY(curAtr.frame) == CGRectGetMinY(nextAtr.frame)) {
                if (self.spanHorizonal == 0) {
                    self.spanHorizonal = self.minimumInteritemSpacing;
                }
                CGRect frame = nextAtr.frame;
                CGFloat x = CGRectGetMaxX(curAtr.frame) + self.spanHorizonal;
                frame = CGRectMake(x, CGRectGetMinY(frame), frame.size.width, frame.size.height);
                nextAtr.frame = frame;
            }
            
        }
        return layoutAtris;
    }
    return nil;
}

@end
