//
//  ControlHandle.h
//  Le123PhoneClient
//
//  Created by lxw on 2018/9/19.
//  Copyright © 2018年 Ying Shi Da Quan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ControlPosition) {
    ControlPositionAppRegist,
    ControlPositionAppDataLoad,
    ControlPositionWindowLoad,
    ControlPositionHomeView,
    ControlPositionRecommendViewStruct,
    
    ControlPositionRequestInit,
    ControlPositionRequestRecommend
};

@interface ControlHandle : NSObject

+ (BOOL)controlPosition:(ControlPosition)position;

@end
