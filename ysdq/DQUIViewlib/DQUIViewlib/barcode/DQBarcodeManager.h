//
//  BZXBarcodeManager.h
//  Le123PhoneClient
//
//  Created by bruce 朱 on 2017/11/15.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZXBarcodeManager : NSObject
+ (UIView*)manageBarcodeViewInSearch:(UIView*)parentView;
+ (UIView*)manageBarcodeViewInHalfScreenDetail:(UIView*)parentView
                                     underView:(UIView*)underView;
+ (UIView*)manageBarcodeViewInFullScreenDetail:(UIView*)parentView;
@end
