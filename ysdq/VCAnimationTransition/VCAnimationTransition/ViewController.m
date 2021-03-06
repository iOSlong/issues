//
//  ViewController.m
//  VCAnimationTransition
//
//  Created by lxw on 2018/7/4.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnimateTransitionPop.h"
#import "PushAnimationController.h"
@interface ViewController ()
@property (nonatomic, strong) PushAnimationController *pushAnimationController;
@end

#define DefaultStruct 0

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#if DefaultStruct
//    self.navigationController.delegate = self;
#else
    self.navigationController.delegate = self.pushAnimationController;
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pushAnimationController = [[PushAnimationController alloc] init];
}
#if DefaultStruct
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        CustomAnimateTransitionPop *pingInvert = [CustomAnimateTransitionPop new];
        return pingInvert;
    } else  if(operation==UINavigationControllerOperationPush) {
        CustomAnimateTransitionPush *animateTransitionPush=[CustomAnimateTransitionPush new];
        return animateTransitionPush;
    } else {
        return nil;
    }
}
#endif

@end
