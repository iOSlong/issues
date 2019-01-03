//
//  BZXBarcodeView.h
//  Le123PhoneClient
//
//  Created by 刘洋 on 16/5/11.
//  Copyright © 2016年 Ying Shi Da Quan. All rights reserved.
//  条形码view

#import <UIKit/UIKit.h>

#define kLineHeight 5.0f
#define kLineWidth  2.0f

@interface BZXBarcodeView : UIView
@property (nonatomic, strong) UIColor *colorOfTrue;
@property (nonatomic, strong) UIColor *colorOfFalse;

- (instancetype)initWihtUDID:(NSString*)udid;
+ (BZXBarcodeView*)barcodeViewWithUDID;
@end
