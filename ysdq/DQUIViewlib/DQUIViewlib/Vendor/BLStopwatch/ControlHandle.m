//
//  ControlHandle.m
//  Le123PhoneClient
//
//  Created by lxw on 2018/9/19.
//  Copyright © 2018年 Ying Shi Da Quan. All rights reserved.
//

#import "ControlHandle.h"

@implementation ControlHandle

+ (BOOL)controlPosition:(ControlPosition)position {
    return NO;
    switch (position) {
        case ControlPositionHomeView:
            return YES;
        case ControlPositionAppRegist:
            return YES;
        case ControlPositionWindowLoad:
            return YES;
        case ControlPositionAppDataLoad:
            return YES;
        case ControlPositionRecommendViewStruct:
            return YES;
        case ControlPositionRequestInit:
            return NO;
        case ControlPositionRequestRecommend:
            return NO;
        default:
            return YES;
            break;
    }
}

@end
