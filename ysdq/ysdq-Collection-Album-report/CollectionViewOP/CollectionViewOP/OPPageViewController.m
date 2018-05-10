//
//  OPPageViewController.m
//  CollectionViewOP
//
//  Created by lxw on 2018/5/10.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "OPPageViewController.h"

@interface OPPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, assign) NSInteger index;
@end

@implementation OPPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    [self didMoveToParentViewController:self];
    UIStoryboard *tutorialStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.controllers = [NSMutableArray array];
    self.index = 0;
    if (!self.viewControllerStoryBoardID) {
        self.viewControllerStoryBoardID = @"UICollectionViewController";
    }
    for (int i = 0; i < 6; i++) {
        UIViewController *vc = [tutorialStoryboard instantiateViewControllerWithIdentifier:self.viewControllerStoryBoardID];
        vc.title = [NSString stringWithFormat:@"PageVC[%d]",i];
        [self.controllers addObject:vc];
    }
    [self setViewControllers:@[self.controllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return self.controllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.controllers indexOfObject:viewController];
    index--;
    if (index < 0 || index == NSNotFound) {
        return nil;
    }
    return self.controllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.controllers indexOfObject:viewController];
    index++;
    if (index == (NSInteger)self.controllers.count) {
        return nil;
    }
    return self.controllers[index];
}


@end
