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
+ (NSString *)appendBaseUrlWithFormat:(nonnull NSString *)format, ... NS_FORMAT_FUNCTION(1,2);



#pragma mark - attribute Clang/LLVM
/*
 attribute是GNU C特色之一,在iOS用的比较广泛.系统中有许多地方使用到. attribute可以设置函数属性（Function Attribute ）、变量属性（Variable Attribute ）和类型属性（Type Attribute)等.
 reference:
 http://ju.outofmemory.cn/entry/296591
 https://www.jianshu.com/p/29eb7b5c8b2d
 */
+ (void)deprecatedMethod1 DEPRECATED_ATTRIBUTE;
+ (void)deprecatedMethod2 __attribute__((deprecated("deprecatedMethod1已经被弃用，请使用^^^")));
+ (void)deprecatedMethod3 __attribute__((availability(ios,introduced=3_0,deprecated=6_0,obsoleted=7_0,message="iOS3到iOS7版本可用，iOS7不能用")));







/**
 *  Flags accompany each log. They are used together with levels to filter out logs.
 */
typedef NS_OPTIONS(NSUInteger, DDLogFlag){
    /**
     *  0...00001 DDLogFlagError
     */
    DDLogFlagError      = (1 << 0),
    
    /**
     *  0...00010 DDLogFlagWarning
     */
    DDLogFlagWarning    = (1 << 1),
    
    /**
     *  0...00100 DDLogFlagInfo
     */
    DDLogFlagInfo       = (1 << 2),
    
    /**
     *  0...01000 DDLogFlagDebug
     */
    DDLogFlagDebug      = (1 << 3),
    
    /**
     *  0...10000 DDLogFlagVerbose
     */
    DDLogFlagVerbose    = (1 << 4)
};

/**
 *  Log levels are used to filter out logs. Used together with flags.
 */
typedef NS_ENUM(NSUInteger, DDLogLevel){
    /**
     *  No logs
     */
    DDLogLevelOff       = 0,
    
    /**
     *  Error logs only
     */
    DDLogLevelError     = (DDLogFlagError),
    
    /**
     *  Error and warning logs
     */
    DDLogLevelWarning   = (DDLogLevelError   | DDLogFlagWarning),
    
    /**
     *  Error, warning and info logs
     */
    DDLogLevelInfo      = (DDLogLevelWarning | DDLogFlagInfo),
    
    /**
     *  Error, warning, info and debug logs
     */
    DDLogLevelDebug     = (DDLogLevelInfo    | DDLogFlagDebug),
    
    /**
     *  Error, warning, info, debug and verbose logs
     */
    DDLogLevelVerbose   = (DDLogLevelDebug   | DDLogFlagVerbose),
    
    /**
     *  All logs (1...11111)
     */
    DDLogLevelAll       = NSUIntegerMax
};

/*
*  @param format       the log format
*/
+ (void)log:(BOOL)asynchronous
      level:(DDLogLevel)level
       flag:(DDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id __nullable)tag
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(9,10);
/*
 #define NS_FORMAT_FUNCTION(F,A) __attribute__((format(__NSString__, F, A)))
 format (archetype, string-index, first-to-check)
 第一参数需要传递“archetype”指定是哪种风格,这里是 NSString；“string-index”指定传入函数的第几个参数是格式化字符串；“first-to-check”指定第一个可变参数所在的索引.
*/

@end

NS_ASSUME_NONNULL_END
