//
//  UITableViewController+OP.h
//  CollectionViewOP
//
//  Created by lxw on 2018/5/10.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USE_OP_REPORTPROTOCOL 0

@protocol OPCollectionViewReportProtocol<NSObject>
@required
- (void)reportCellsDisplayedWithoutReduplicative;
- (void)reportCellDisplayedInIndexPath:(NSIndexPath *)indexPath;
@end


@interface UIViewController (OPScrollView)
@property (nonatomic, weak) id<OPCollectionViewReportProtocol>opReportDelegate;

//如果是YES，表示有去重机制开启，如果是NO，不进行去重
@property (nonatomic, assign) BOOL reportFilterReduplicativeSwith;

@property (nonatomic, strong) NSMutableSet *reportIndexPathSet;//去重IndexPath容器
@end

//@interface UITableViewController (OP)
//@property (nonatomic, weak) id<OPCollectionViewReportProtocol>opReportDelegate;
//@property (nonatomic, assign) BOOL  reportFilterReduplicativeSwith;//如果是YES，表示有去重机制开启，如果是NO，不进行去重
//@property (nonatomic, strong) NSMutableSet *reportIndexPathSet;//去重IndexPath容器
//
//@end
//
//
//@interface UICollectionViewController (OP)
//@property (nonatomic, weak) id<OPCollectionViewReportProtocol>opReportDelegate;
//@property (nonatomic, assign) BOOL  reportFilterReduplicativeSwith;//如果是YES，表示有去重机制开启，如果是NO，不进行去重
//@property (nonatomic, strong) NSMutableSet *reportIndexPathSet;//去重IndexPath容器
//
//@end
