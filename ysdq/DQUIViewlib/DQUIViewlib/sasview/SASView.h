//
//  SASView.h
//  Le123PhoneClient
//
//  Created by lxw on 2017/10/23.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASView : UIView
@end



@interface UIView(TagSubviewFinder)
- (UIView *)viewDesTag:(NSInteger)tag;
- (BOOL)viewContainKindClassName:(NSString *)name;
@end
