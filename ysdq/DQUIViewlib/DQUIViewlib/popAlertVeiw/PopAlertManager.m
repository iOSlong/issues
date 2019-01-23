//
//  PopAlertManager.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/22.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "PopAlertManager.h"

@implementation PopAlertAction
@end


static NSMutableArray *allManagers;

@implementation PopAlertManager {
    NSMutableDictionary *_titleHandlers;
}

- (void)alertMessage:(NSString*)msg title:(NSString*)title actions:(NSArray*)actions {
    UIWindow *w = [[UIApplication sharedApplication].delegate window];
    [self alertMessage:msg title:title actions:actions presentViewController:w.rootViewController];
} /* alertMessage */
- (void)alertMessage:(NSString*)msg title:(NSString*)title actions:(NSArray*)actions presentViewController:(UIViewController*)viewController {
    if (allManagers == nil) {
        allManagers = [NSMutableArray array];
    }
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version < 8.0) {
        NSString       *cancelTitle = nil;
        NSMutableArray *otherTitles = [NSMutableArray array];
        for (PopAlertAction *action in actions) {
            if (_titleHandlers == nil) {
                _titleHandlers = [NSMutableDictionary dictionary];
            }
            
            if (action.block) {
                [_titleHandlers setObject:action.block forKey:action.title];
            }
            
            if (action.style == UIAlertActionStyleCancel) {
                cancelTitle = action.title;
            } else {
                [otherTitles addObject:action.title];
            }
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
        for (NSString *title in otherTitles) {
            [av addButtonWithTitle:title];
        }
        [av show];
        [allManagers addObject:self];
    } else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        for (PopAlertAction *dqAction in actions) {
            UIAlertAction *alertAct = [UIAlertAction actionWithTitle:dqAction.title style:dqAction.style handler:^(UIAlertAction *action) {
                if (dqAction.block) {
                    dqAction.block(action);
                }
            }];
            [ac addAction:alertAct];
        }
        
        [viewController presentViewController:ac animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ActionBlock block = [_titleHandlers objectForKey:[alertView buttonTitleAtIndex:buttonIndex]];
    if (block) {
        block(nil);
    }
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [allManagers removeObject:alertView.delegate];
}
@end
