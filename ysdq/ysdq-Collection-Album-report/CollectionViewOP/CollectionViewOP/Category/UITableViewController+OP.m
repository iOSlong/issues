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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.reportFilterReduplicativeSwith = YES;
    //FIXME:存在漏洞-如果页面的移位不是通过手指拖拽，那么reportFilterReduplicativeSwith开关将没有机会设置为YES。
    //TODO:规避方案（在页面移位的方法譬如此例子scrollNoAnimationTop直接操作开关）
    //MARK:这个开关操作时机还可以房子scrollViewDidEndDragging:方法的最开始。
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSLog(@"滚动抬起手指没有减速惯性停止监听");
        [self.opReportDelegate reportCellsDisplayedWithoutReduplicative];
    }else{
        NSLog(@"滚动抬起手指有减速惯性，依赖scrollViewDidEndDecelerating：监听停止");
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"滚动抬起手指有减速惯性停止监听");
    [self.opReportDelegate reportCellsDisplayedWithoutReduplicative];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"非手指动画滚动停止监听");
    [self.opReportDelegate reportCellsDisplayedWithoutReduplicative];
    //FIXME:存在漏洞-若设置页面setContentOffset时候没有添加动画，那么移位后没有监听。
    //TODO:规避方案（可以通过setContentOffset使用animation：YES）
}

@end
