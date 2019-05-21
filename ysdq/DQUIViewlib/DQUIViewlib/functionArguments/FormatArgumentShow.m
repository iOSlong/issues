//
//  FormatArgumentShow.m
//  DQUIViewlib
//
//  Created by lxw on 2019/5/20.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "FormatArgumentShow.h"
/**
 *  可变参数用到以下宏函数
 * [1]  原型： void va_start(va_list arg_ptr,prev_param);
 *      功能： 以固定参数的地址为起点确定变参的内存起始地址，获取第一个参数的首地址
 *      返回值：无
 *
 * [2]  原型：va_list 类型的变量，va_list arg_ptr ,这个变量是指向参数地址的指针，因为得到参数的地址之后，再结合参数的类型，才能得到参数的值。
 *
 * [3]  原型：type va_arg(va_list arg_ptr,type);
 *      功能：获取下一个参数的地址
 *      返回值：根据传入参数类型决定返回值类型
 *
 * [4]  原型：void  va_end(va_list arg_ptr);
 *      功能：将arg_ptr指针置0
 *      返回值：无
 *
 *
 *
 *
 ⑴在程序中将用到以下这些宏:
 
 void va_start( va_list arg_ptr, prev_param );
 type va_arg( va_list arg_ptr, type );
 void va_end( va_list arg_ptr );
 
 va在这里是variable-argument(可变参数)的意思.
 这些宏定义在stdarg.h中,所以用到可变参数的程序应该包含这个头文件.
 ⑵.函数里首先定义一个va_list型的变量,这里是arg_ptr,这个变量是指向参数地址的指针.因为得到参数的地址之后，再结合参数的类型，才能得到参数的值。
 ⑶.然后用va_start宏初始化⑵中定义的变量arg_ptr,这个宏的第二个参数是可变参数列表的前一个参数,也就是最后一个固定参数。
 ⑷.然后依次用va_arg宏使arg_ptr返回可变参数的地址,得到这个地址之后，结合参数的类型，就可以得到参数的值。然后进行输出。
 ⑸.设定结束条件，这里的条件就是判断参数值是否为-1。注意被调的函数在调用时是不知道可变参数的正确数目的，程序员必须自己在代码中指明结束条件。至于为什么它不会知道参数的数目，读者在看完下面这几个宏的内部实现机制后，自然就会明白。
 
 《透析C语言可变参数问题》http://www.cnblogs.com/wangyonghui/archive/2010/07/12/1776068.html
 
 *
 *
 **/

//variable-argument

void ar_cnt(int cnt,...);
void ar_cst(char const *s,...);

/* 1、整型数据的输出 */
void ar_cnt(int cnt,...)
{
    int value1=0;
    int i=0;
    va_list arg_ptr;  /* points to each unnamed arg in turn */
    va_start(arg_ptr,cnt);  /* make arg_ptr point to 1st unnamed arg */
    for(i=0;i<cnt;i++)
    {
        value1 = va_arg(arg_ptr,int);
        printf("posation %d=%d\n",value1,i+1);
    }
    va_end(arg_ptr);
}

/* 2、字符串的输出*/
void PrintLines(char *first,...)
{
    char *str;
    va_list v1;
    str = first;
    va_start(v1,first);
    do
    {
        printf("%s\n",str);
        str = va_arg(v1, char*);
    } while (str != NULL );
    va_end(v1);
}

/* 3、找出最大数*/
int FindMax(int amount,...)
{
    int i,val,great;
    va_list v1;
    va_start(v1,amount);
    great = va_arg(v1,int);
    for(i=1;i<amount;i++)
    {
        val = va_arg(v1,int);
        great=(great>val)?great:val;
    }
    va_end(v1);
    return great;
}


void caseArcnt(void)
{
    int in_size = sizeof(int);
    printf("int_size=%d\n",in_size);
    ar_cnt(5,1,2,3,4);
    
    
    PrintLines("First","Second","Third","Fourth",NULL);
    
    
    int max = FindMax(6,100,20,456,102,4,500);
    printf("The Max one is %d\n",max);
}




@implementation FormatArgumentShow

+ (void)formatArgumentsShow {
    
    
    caseArcnt();
    
    [[self class] appendBaseUrlWithFormat:@"%@,%@,%d", @"arg1",@"arg2",100];
    [[self class] showFunctionParms:@"firstP",@"arg2",@"100",@"200",@"end",nil];
    
//    [[self class] deprecatedMethod1];
//    [[self class] deprecatedMethod2];
//            [[self class] deprecatedMethod3];

}

+ (NSArray *)showFunctionParms:(NSString *)firstP,... {
    NSMutableArray *parms = [NSMutableArray array];
    va_list argumentList;
    if (firstP) {
        va_start(argumentList, firstP);                // 从firstP的下一个元素开始
        NSString * eachObject = firstP;                   // 参数列表中的元素
        do {
            [parms addObject:eachObject];            // 如果这个元素不是nil，就把它加进数组里
            // 返回参数列表中指针所指的参数，返回的类型是NSString *
            eachObject = va_arg(argumentList, NSString *);
        } while (eachObject); //参数中需要有一个结束标志，-1，nil，等都可以。
        va_end(argumentList);                           // 结束
    }
    return parms;
}

+ (NSString *)appendBaseUrlWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
    va_list args;
    va_start(args, format);
    NSString *appendStr = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSLog(@"appendStr:\n%@",appendStr);
    return appendStr;
}

@end
