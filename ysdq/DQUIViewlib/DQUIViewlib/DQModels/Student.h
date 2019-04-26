//
//  Student.h
//  DQUIViewlib
//
//  Created by lxw on 2019/4/25.
//  Copyright © 2019 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LocationCityState) {
    LocationCityStateNorth,
    LocationCityStateWest,
    LocationCityStateSouth,
    LocationCityStateEast,
};



NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isFemale;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) LocationCityState state;

+(instancetype)demoStudent;

@end

NS_ASSUME_NONNULL_END
