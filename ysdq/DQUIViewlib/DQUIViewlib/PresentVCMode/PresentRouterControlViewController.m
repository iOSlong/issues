//
//  PresentRouterControlViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2019/2/15.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "PresentRouterControlViewController.h"

@interface PresentRouterControlViewController ()
@property (nonatomic, strong) UIButton *buttonPopOut;
@property (nonatomic, strong) UIButton *buttonRouterControl;
@end

@implementation PresentRouterControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [button1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button1 setTintColor:[UIColor blueColor]];
    [button1 setTitle:@"popOut" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(buttonPopOut:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonPopOut = button1;

    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 50)];
    [button2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button2 setTintColor:[UIColor blueColor]];
    [button2 setTitle:@"RoutControlTest" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(buttonRouterTest:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonRouterControl = button2;
}

+ (UIView*)BFSSearchView:(Class)clazz inView:(UIView*)root {
    if (!root) {
        return nil;
    }
    UIView         *result = nil;
    NSMutableArray *queue  = [NSMutableArray arrayWithCapacity:0x10];
    UIView         *node   = nil;
        /// push
    [queue addObject:root];
    while (queue.count != 0) {
            /// pop
        node = [queue lastObject];
        [queue removeLastObject];
        
            /// check
        if ([node isKindOfClass:clazz]) {
            result = node;
            break;
        }
            /// trans all
        [queue addObjectsFromArray:node.subviews];
    }
    return result;
}

+ (UINavigationController*)findTopmostNavigationController:(UIWindow*)window {
    UIView *expectView      = nil;
    Class   expectViewClass = NSClassFromString(@"UINavigationTransitionView");
    expectView = [self BFSSearchView:expectViewClass inView:window];
    
    UINavigationController *navi = (UINavigationController *)[expectView viewController];
    if (!navi) {
        NSLog(@"");
    }
    return navi;
}

+ (UINavigationController*)findTopmostNavigationController {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    return [self findTopmostNavigationController:window];
}

+ (void)push:(UIViewController*)controller animated:(BOOL)animated {
    UINavigationController *navi = [self findTopmostNavigationController];
    [navi pushViewController:controller animated:animated];
}

- (void)buttonRouterTest:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:^{
        UIViewController *testVC = [[UIViewController alloc] init];
        [[self class] push:testVC animated:btn];
    }];
}

- (void)buttonPopOut:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
