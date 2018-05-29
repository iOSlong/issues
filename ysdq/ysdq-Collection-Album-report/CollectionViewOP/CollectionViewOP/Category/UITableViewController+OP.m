//
//  UITableViewController+OP.m
//  CollectionViewOP
//
//  Created by lxw on 2018/5/10.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "UITableViewController+OP.h"
#import <objc/runtime.h>

//@implementation UITableViewController (OP)

@implementation UIViewController (OPScrollView)

- (void)setReportFilterReduplicativeSwith:(BOOL)reportFilterReduplicativeSwith {
    NSNumber *numberV = [NSNumber numberWithBool:reportFilterReduplicativeSwith];
    objc_setAssociatedObject(self, @selector(reportFilterReduplicativeSwith), numberV, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)reportFilterReduplicativeSwith {
    NSNumber *numberV = objc_getAssociatedObject(self, @selector(reportFilterReduplicativeSwith));
    return numberV.boolValue;
}


- (void)setOpReportDelegate:(id<OPCollectionViewReportProtocol>)opReportDelegate {
    objc_setAssociatedObject(self, @selector(opReportDelegate), opReportDelegate, OBJC_ASSOCIATION_ASSIGN);
}
- (id<OPCollectionViewReportProtocol>)opReportDelegate {
    id<OPCollectionViewReportProtocol> delegate = objc_getAssociatedObject(self, @selector(opReportDelegate));
    return delegate;
}

- (void)setReportIndexPathSet:(NSMutableSet *)reportIndexPathSet {
    objc_setAssociatedObject(self, @selector(reportIndexPathSet), reportIndexPathSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet *)reportIndexPathSet {
    NSMutableSet *muSet = objc_getAssociatedObject(self, @selector(reportIndexPathSet));
    if (!muSet) {
        muSet = [NSMutableSet set];
        [self setReportIndexPathSet:muSet];
    }
    return muSet;
}


#pragma mark -
#pragma mark <监听上报相关内容>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.reportFilterReduplicativeSwith = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self reportCellsDisplayedWithoutReduplicative];
    }else{
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reportCellsDisplayedWithoutReduplicative];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self reportCellsDisplayedWithoutReduplicative];
}

#pragma mark 上报及上报去重机制处理
- (void)reportCellsDisplayedWithoutReduplicative {
    for (NSIndexPath *indexPath in [self.opReportDelegate reportCellIndexPathForVisibleItems]) {
        if (![self.reportIndexPathSet containsObject:indexPath]) {
            [self reportHandleIndexPath:indexPath];
        }
    }
    //去重：上一次曝光过的就不用再上报，所以保留曝光完后界面可见的所有indexPath，用于下一次偏移或滚动的曝光去重。
    if (self.reportFilterReduplicativeSwith) {
        [self.reportIndexPathSet removeAllObjects];
    }
    for (NSIndexPath *indexPath in [self.opReportDelegate reportCellIndexPathForVisibleItems]) {
        [self.reportIndexPathSet addObject:[indexPath copy]];
    }
}

- (void)reportCellDisplayedIndexPath:(NSIndexPath *)indexPath {
    if (!self.reportFilterReduplicativeSwith) {
        [self reportHandleIndexPath:indexPath];
    }
    if (!self.reportFilterReduplicativeSwith) {
        if (indexPath.row == [[self.opReportDelegate reportCellIndexPathForVisibleItems] lastObject].row) {
            self.reportFilterReduplicativeSwith = YES;
        }
    }
}

- (void)reportHandleIndexPath:(NSIndexPath *)indexPath {
    if ([self.reportIndexPathSet containsObject:indexPath]) {
        return;
    } else {
        [self.reportIndexPathSet addObject:[indexPath copy]];
    }
    [self.opReportDelegate reportCellHaudleForIndexPath:indexPath];
}

@end
