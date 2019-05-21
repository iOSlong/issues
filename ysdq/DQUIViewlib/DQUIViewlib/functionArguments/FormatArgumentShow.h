//
//  FormatArgumentShow.h
//  DQUIViewlib
//
//  Created by lxw on 2019/5/20.
//  Copyright © 2019 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormatArgumentShow : NSObject

+ (void)formatArgumentsShow;
+ (NSString *)appendBaseUrlWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);



#pragma mark - attribute Clang/LLVM
/*
 reference:
 http://ju.outofmemory.cn/entry/296591
 */
+ (void)deprecatedMethod1 DEPRECATED_ATTRIBUTE;
+ (void)deprecatedMethod2 __attribute__((deprecated("deprecatedMethod1已经被弃用，请使用^^^")));
+ (void)deprecatedMethod3 __attribute__((availability(ios,introduced=3_0,deprecated=6_0,obsoleted=7_0,message="iOS3到iOS7版本可用，iOS7不能用")));

@end

NS_ASSUME_NONNULL_END
