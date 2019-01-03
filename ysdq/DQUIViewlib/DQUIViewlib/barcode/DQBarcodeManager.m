//
//  BZXBarcodeManager.m
//  Le123PhoneClient
//
//  Created by bruce 朱 on 2017/11/15.
//  Copyright © 2017年 Ying Shi Da Quan. All rights reserved.
//

#import "DQBarcodeManager.h"
#import "DQBarcodeView.h"




@implementation BZXBarcodeManager
+ (UIView*)manageBarcodeViewInSearch:(UIView*)parentView {
    return [self addUUIDBarcodeViewAtBottomToHalfScreen:parentView
                                            colorOfTrue:RGBCOLOR_HEX(0xFCFCFC)
                                           colorOfFalse:RGBCOLOR_HEX(0xFFFFFF)];
}

+ (UIView*)manageBarcodeViewInHalfScreenDetail:(UIView*)parentView
                                     underView:(UIView*)underView {
    return [self addUUIDBarcodeViewToView:parentView
                                underView:underView
                              colorOfTrue:RGBCOLOR_HEX(0xFCFCFC)
                             colorOfFalse:RGBCOLOR_HEX(0xFFFFFF)];
}

+ (UIView*)manageBarcodeViewInFullScreenDetail:(UIView*)parentView {
    return [self addUUIDBarcodeViewAtBottomToFullScreen:parentView
                                            colorOfTrue:RGBCOLOR_HEX(0x0A0A0A)
                                           colorOfFalse:RGBCOLOR_HEX(0x000000)];
}

#pragma mark - Private Method

+ (UIView*)addUUIDBarcodeViewAtBottomToHalfScreen:(UIView*)parentView
                                      colorOfTrue:(UIColor*)colorOfTrue
                                     colorOfFalse:(UIColor*)colorOfFalse {
    CGFloat        height = kLineHeight;
    
    BZXBarcodeView *barcodeView = [BZXBarcodeView barcodeViewWithUDID];
    barcodeView.colorOfTrue = colorOfTrue;
    barcodeView.colorOfFalse = colorOfFalse;
    [parentView addSubview:barcodeView];
    [barcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(parentView);
        make.bottom.equalTo(parentView);
        make.height.mas_equalTo(height);
    }];
    
    return barcodeView;
}
+ (BOOL)isIPhoneX {
    if ((LONG_BORDER == 812 && SHORT_BORDER == 375) || (LONG_BORDER == 896 && SHORT_BORDER == 414)) {
        return YES;
    }
    return NO;
}
+ (UIView*)addUUIDBarcodeViewAtBottomToFullScreen:(UIView*)parentView
                                      colorOfTrue:(UIColor*)colorOfTrue
                                     colorOfFalse:(UIColor*)colorOfFalse {
    CGFloat        height = kLineHeight;
    
    BZXBarcodeView *barcodeView = [BZXBarcodeView barcodeViewWithUDID];
    barcodeView.colorOfTrue = colorOfTrue;
    barcodeView.colorOfFalse = colorOfFalse;
    [parentView addSubview:barcodeView];
    [barcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self isIPhoneX]) {
            // iPhone X横屏全屏时，左右两边要留出圆角位置
            make.left.equalTo(parentView).offset(44);
            make.right.equalTo(parentView).offset(-44);
        } else {
            make.left.and.right.equalTo(parentView);
        }
        make.bottom.equalTo(parentView);
        make.height.mas_equalTo(height);
    }];
    
    return barcodeView;
}

+ (UIView*)addUUIDBarcodeViewToView:(UIView*)parentView
                          underView:(UIView*)upView
                        colorOfTrue:(UIColor*)colorOfTrue
                       colorOfFalse:(UIColor*)colorOfFalse {
    CGFloat        height = kLineHeight;
    BZXBarcodeView *barcodeView = [BZXBarcodeView barcodeViewWithUDID];
    barcodeView.colorOfTrue = colorOfTrue;
    barcodeView.colorOfFalse = colorOfFalse;
    [parentView addSubview:barcodeView];
    [barcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
#if IS_YSDQ_IPAD_TARGET
        make.left.right.equalTo(upView);
#else
        make.left.right.equalTo(parentView);
#endif
        make.top.equalTo(upView.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    
    return barcodeView;
}
@end
