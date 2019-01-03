//
//  BZXBarcodeView.m
//  Le123PhoneClient
//
//  Created by 刘洋 on 16/5/11.
//  Copyright © 2016年 Ying Shi Da Quan. All rights reserved.
//

#import "DQBarcodeView.h"


@interface BZXBarcodeView ()

@property (nonatomic, copy) NSString *udid;

@end

@implementation BZXBarcodeView

- (instancetype)initWihtUDID:(NSString*)udid {
    if (self = [super initWithFrame:CGRectMake(0,0,320,1)]) {
        self.udid            = udid;
#if USE_UI_STYLE_PAD
//        self.backgroundColor =  
#else
        self.backgroundColor = RGBCOLOR_HEX(0xFFFFFF);
#endif
        self.backgroundColor = RGBCOLOR_HEX(0xFFFFFF);

    }

    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.udid) {
        NSString    *binaryString = [self getBinaryByhex:self.udid];

        CGFloat      y         = self.bounds.origin.y;
        CGFloat      lineWidth = kLineWidth;
        CGFloat      xPadding  = 0.0f;

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, lineWidth);

        UIColor *colorOfTrue  = self.colorOfTrue;
        UIColor *colorOfFalse = self.colorOfFalse;

        //        UIColor *colorOfTrue = RGBCOLOR_HEX(0x000000);
        //        UIColor *colorOfFalse = RGBCOLOR_HEX(0x323232);

        for (NSUInteger i = 0; i < binaryString.length; i++) {
            NSRange  range = NSMakeRange(i, 1);
            int      value = [[binaryString substringWithRange:range] intValue];
            UIColor *color = value? colorOfTrue:colorOfFalse;

            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGFloat x = i * lineWidth + xPadding;
            //画点
            CGRect  pointRect = CGRectMake(x, y, kLineWidth,kLineHeight);
            CGContextFillRect(context, pointRect);

            CGContextStrokePath(context);
        }
    }
}

- (NSString*)getBinaryByhex:(NSString*)hex {
    NSDictionary *hexDic = @{@"0":@"0000",
                             @"1":@"0001",
                             @"2":@"0010",
                             @"3":@"0011",
                             @"4":@"0100",
                             @"5":@"0101",
                             @"6":@"0110",
                             @"7":@"0111",
                             @"8":@"1000",
                             @"9":@"1001",
                             @"A":@"1010",
                             @"B":@"1011",
                             @"C":@"1100",
                             @"D":@"1101",
                             @"E":@"1110",
                             @"F":@"1111"};
    hex = [hex uppercaseString];
    NSMutableString *binaryString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < hex.length; i++) {
        NSRange   range  = NSMakeRange(i, 1);
        NSString *key    = [hex substringWithRange:range];
        NSString *binary = hexDic[key];
        [binaryString appendString:[NSString stringWithFormat:@"%@",binary? binary:@""]];
    }

    return binaryString;
}

#pragma mark - Public

+ (BZXBarcodeView*)barcodeViewWithUDID {
    NSString *udid = @"896942968929b937268a9efa78eb2a96fa401213";
    return [[BZXBarcodeView alloc] initWihtUDID:udid];
//    return [[BZXBarcodeView alloc] initWihtUDID:[UIDevice deviceID]];
}

#pragma mark - Property
- (void)setColorOfFalse:(UIColor *)colorOfFalse {
    _colorOfFalse = colorOfFalse;
    self.backgroundColor = colorOfFalse;
}

@end
