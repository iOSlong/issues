## 第一章 熟悉 Objc
### 第一条：了解Objc语言的起源
> 来自C所以利用好C的语言特性， 消息机制， smalltalk

### 第二条：在类的头文件中尽量少引入其他头文件
在编译一个类时候，不需要知道它全部的细节。头文件引入延迟，只在需要时候才引入，减少类的使用者所需引入头文件数量，节约编译时间。

> 利用 `向前声明(forward declaring)` 
> 1. 处理一些头文件延迟引入问题。 
> 2. 它还可以解决两个类的相互引用问题。

```
classFile.h  
    @class XXXOBJ

classFile.m  
    #import XXXOBJ
```

> 有时无法使用向前声明，比如要声明某个类遵循一项协议。这种情况下，尽量把”该类遵循某协议“的这条声明移至”class-continuation分类“中。
> 或者如果有必要，就把协议单独放在一个头文件中，然后将其引入。

### 第三条：多用字面量语法，少用与之等价的方法。
> 使用字面量语法，可以省去`alloc - init ` 或者 `new` ,让代码更加精简易读。

```
NSString *someString = @"Effective Objc-2.0";
NSNumber *someNumber = @99.9f;
NSArray  *animals    = @[@"cat",@"dog",@"mouse"];
NSString *mouse      = animals[2];
NSDictionary *person = @{@"firstName" : @"Bruce"};
```
> 字面量语法是OC中的一种”语法糖“，可用于`字符串`，以及Foundation框架下的 `数值` `数组` `字典` `下标用法`。
有一定局限性：
1. 自定义的继承类不可用 *不过相信一般不会对数值 数组 字典 再做继承了，他们已经够你使用*
2. 创建的对象都是不可变的，可以拷贝一下实现可变: `NSMutableArray *mutable = [@[@1,@2,@3] mutableCopy];`

### 第四条 多用类型常量，少用#define 预处理指令
宏定义方式是拷贝替换操作，无法确定常量类型信息。编译器也无警告，存在被重定义导致应用中常量值不一致的风险。



> 在.m 文件中使用 `static const` 定义"只在编译单元内可见的常量"。此常量不在全局符号表中，无须为命名加类前缀区分。

>`Objective-C语境中，”编译单元“一词通常指类的实现文件(.m)`

>`static`修饰意味着变量只在定义的该变量的编译单元中可见。

```
classFile.m 

static const NSTimeInterval kAnimationDuration = 0.3;

@implementation XXXAnimationView
- (void)animate {
    [UIView animateWithDuration:kAnimationDuration 
            animations:^{
        //Perform animations
    }];
}
@end
 
```
> 在头文件中使用`extern`来声明全局变量，在实现文件中定义其值。这种常量要出现在全局符号表中，所以其名称应该加以区分，通常是与之相关的类名做前缀。

```
UIKIT_EXTERN NSNotificationName const UIApplicationDidFinishLaunchingNotification;
```

```
//XXXLoginManager.h
#import<Foundation/Foundation.h>
  
extern NSString *const XXXLoginManagerDidLoginNotification;

//XXXLoginManager.m
#import "XXXLoginManager.h"
NSString *const XXXLoginManagerDidLoginNotification = @"XXXLoginManagerDidLoginNotification";
    
@implementation XXXLoginManager
@end
```

### 第五条：用枚举标识状态、选项、状态码
每种状态都用一个便于理解的值来表示，所写出的代码易读、易维护。

```
typedef NS_ENUM(NSUInteger, <#MyEnum#>) {
    <#MyEnumValueA#>,
    <#MyEnumValueB#>,
    <#MyEnumValueC#>,
};
```
>  如果多个选项可以同时使用，那么就将各个选项按照2的幂进行向左移位，以便通过位操作符组合使用。

```
typedef NS_OPTIONS(NSUInteger, <#MyEnum#>) {
    <#MyEnumValueA#> = 1 << 0,
    <#MyEnumValueB#> = 1 << 1,
    <#MyEnumValueC#> = 1 << 2,
};
```
> 在处理枚举类型的`switch`语句中不要实现default分支。这样的话，加入新枚举之后，编译器就会提示开发者：switch语句并未处理所有的枚举。


## 第二章 对象、消息、运行时
1. 不一定要在接口中把全部的实例变量都声明好，可以将某些变量从接口的public区段里移走，以便保护与实现有关的内部信息。
2. 使用点语法访问类属性。
3. 若不想让编译器自动合成存取方法，可以使用`@dynamic`关键字，然后自己实现存取方法。dynamic会告诉编译器这些方法会在运行时找到，编译时候发现访问其修饰的属性编译器也不会报错。





