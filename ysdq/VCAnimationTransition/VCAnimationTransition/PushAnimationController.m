//
//  PushAnimationController.m
//  VCAnimationTransition
//
//  Created by lxw on 2018/7/5.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "PushAnimationController.h"
#import "CustomAnimateTransitionPop.h"
#import "CustomAnimateTransitionPush.h"

@implementation PushAnimationController

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

@end
