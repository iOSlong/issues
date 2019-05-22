//
//  Student.m
//  DQUIViewlib
//
//  Created by lxw on 2019/4/25.
//  Copyright © 2019 lxw. All rights reserved.
//
#import "Student.h"


#define LOG_OBJC_MAYBE(async, frmt, ...) [Student macroAppendText:async format:(frmt), ## __VA_ARGS__]
#define DDLogVerbose(frmt, ...) LOG_OBJC_MAYBE((1), frmt, ##__VA_ARGS__)

/*
 【宏定义中的##操作符和... and _ _VA_ARGS_ _】
 
 https://www.cnblogs.com/zhoug2020/p/5981120.html
 */


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

+ (void)macroAppendText:(int)flag format:(NSString *)format,... NS_FORMAT_FUNCTION(2,3) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSLog(@" message: %@",message);
}

- (NSString *)description {
    DDLogVerbose(@"%@,%@,%@,%@",@"1",@"2",@3,@4);

    
    return [NSString stringWithFormat:@"name:%@, age:%ld, female:%@, state:%lu",_name,(long)_age,_isFemale?@"YES":@"NO",(unsigned long)_state];
}



@end
