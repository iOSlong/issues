//
//  HouseViewController.h
//  VCAnimationTransition
//
//  Created by lxw on 2018/7/4.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, AppearType) {
    AppearTypePushInNav,
    AppearTypePush,
    AppearTypePresentInNav,
    AppearTypePresent
};

@interface HouseViewController : ViewController

@property (nonatomic, assign) AppearType appearType;
@end
