//
//  Student.m
//  DQUIViewlib
//
//  Created by lxw on 2019/4/25.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "Student.h"

@implementation Student

+ (instancetype)demoStudent {
    Student *stu = [Student new];
    stu.name        = @"student";
    stu.age         = 5;
    stu.isFemale    = YES;
    stu.state       = LocationCityStateEast;
    return stu;
}
- (void)setIsFemale:(BOOL)isFemale {
    if (_isFemale != isFemale) {
        _isFemale = isFemale;
    }else{
        NSLog(@"kvo should not observer this one !");
    }
}
- (NSString *)description {
    return [NSString stringWithFormat:@"name:%@, age:%ld, female:%@, state:%lu",_name,(long)_age,_isFemale?@"YES":@"NO",(unsigned long)_state];
}

@end
