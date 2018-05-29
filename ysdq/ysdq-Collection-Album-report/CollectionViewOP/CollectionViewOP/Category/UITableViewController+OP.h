//
//  UITableViewController+OP.h
//  CollectionViewOP
//
//  Created by lxw on 2018/5/10.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USE_OP_REPORTPROTOCOL 1

@protocol OPCollectionViewReportProtocol<NSObject>
@required
- (NSArray<NSIndexPath *> *)reportCellIndexPathForVisibleItems;
- (void)reportCellHaudleForIndexPath:(NSIndexPath *)indexPath;
@end


@interface UIViewController (OPScrollView)
@property (nonatomic, weak) id<OPCollectionViewReportProtocol>opReportDelegate;

//如果是YES，表示有去重机制开启，如果是NO，不进行去重
@property (nonatomic, assign) BOOL reportFilterReduplicativeSwith;
@property (nonatomic, strong) NSMutableSet *reportIndexPathSet;//去重IndexPath容器

- (void)reportCellsDisplayedWithoutReduplicative;
- (void)reportCellDisplayedIndexPath:(NSIndexPath *)indexPath;
@end

