//
//  SASView.m
//  Le123PhoneClient
//
//  Created by lxw on 2017/10/23.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import "SASView.h"

@implementation SASView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation UIView(TagSubviewFinder)
- (UIView *)viewDesTag:(NSInteger)tag {
    if (self.tag == tag) {
        return self;
    }
    NSArray *subViews = [self subviews];
    UIView *desView = nil;
    if (subViews.count) {
        for (UIView *subV in subViews) {
            if (subV.tag == tag ) {
                return subV;
            }else{
                desView = [subV viewDesTag:tag];
                if (desView) {
                    return desView;
                }
            }
        }
    }
    return nil;
}
- (BOOL)viewContainKindClassName:(NSString *)name {
    if ([NSStringFromClass([self class]) isEqualToString:name]) {
        return YES;
    }
    NSArray *subViews = [self subviews];
    BOOL isContain = NO;
    if (subViews.count) {
        for (UIView *subV in subViews) {
            if ([NSStringFromClass([subV class]) isEqualToString:name] ) {
                return YES;
            }else{
                isContain = [subV viewContainKindClassName:name];
                if (isContain) {
                    return isContain;
                }
            }
        }
    }
    return NO;
}
@end








