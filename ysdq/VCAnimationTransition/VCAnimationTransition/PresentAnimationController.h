//
//  PresentAnimationController.h
//  VCAnimationTransition
//
//  Created by lxw on 2018/7/5.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PresentAnimationController : NSObject<UIViewControllerAnimatedTransitioning>
@end


@interface PresentViewControllerTransitioningDelegator : NSObject<UIViewControllerTransitioningDelegate>
+ (instancetype)transitionDelegatorfromVC:(UIViewController*)fromVC ToVC:(UIViewController*)toVC;
@end
