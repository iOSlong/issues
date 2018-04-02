## 第一章 熟悉 Objc
### 第1条：了解Objc语言的起源
> 来自C所以利用好C的语言特性， 消息机制， smalltalk

### 第2条：在类的头文件中尽量少引入其他头文件
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

### 第3条：多用字面量语法，少用与之等价的方法。
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

### 第4条 多用类型常量，少用#define 预处理指令
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

### 第5条：用枚举标识状态、选项、状态码
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

### 第6条：理解”属性“这一概念
原子性 读写权限 内存管理语义 方法名 ~
> 开发iOS程序时候，应该使用nonatomic属性，因为atomic会严重影响性能。

### 第7条：在对象内部尽量直接访问实例变量
1. 在对象内部读取数据时，直接通过实例变量来读，而写入数据时，则应该通过属性来写。
2. 在初始化方法及dealloc方法中，总是应该直接通过实例变量那个来读写数据。
3. 有时会使用惰性初始化(懒加载)技术配置某份数据，这种情况下，需要通过属性来读取数据。

### 第8条：理解”对象等同性“这一概念
不同于 `==` 比较，应为它是比较两个指针本身，并不是其所指的对象。
譬如NSString 有自己的方法 `isEqualToString`
NSObject协议中有两个用于判断等同性的关键方法：

```
- (BOOL)isEqual:(id)object;
- (NSUinterger)hash;
```
> 相同的对象必须具有相同的哈希码，但是两个哈希码相同的对象未必相同
> 编写hash方法时，应该使用计算速度快，而且哈希码碰撞几率低的算法。

### 第9条：以”类族模式(class cluster)“隐藏实现细节
* 类族模式可以把实现细节隐藏在一套简单的公共接口后面
    
```
+ (UIButton *)buttoWithType:(UIButtonType)type
```
* 系统框架中常用的类族
   
   > 大部分的collection类都是类族。
   
* 从类族的公共抽象基类钟继承子类时要当心。
   
   > 譬如对于Cocoa中NSArray这样的类族来说：
    子类应该继承自类族中的抽象基类，
    子类应该定义自己的数据存储方式
    子类应当覆写超类文档中指明需要覆写的方法 

### 第10条：在既有类中使用关联对象存放自定义数据
对象关联类型：

关联类型    |   等效的@property属性
---------   |   -----------
 OBJC_ASSOCIATION_ASSIGN    |   assign   
 OBJC_ASSOCIATION_RETAIN_NONATOMIC  |   nonatomic retain                               
 OBJC_ASSOCIATION_COPY_NONATOMIC    |   nonatomic copy                                 
 OBJC_ASSOCIATION_RETAIN    |   retain                               
 OBJC_ASSOCIATION_COPY  |   copy
                                  
管理关联对象：

方法名 |   描述
---------   |   -----------
`objc_setAssociatedObject(id object, const void *key,id value, objc_AssociationPolicy policy)`  |  根据键值和策略对对象设置关联
`objc_getAssociatedObject(id object, const void *key)`  |   获取关联对象值
`objc_removeAssociatedObjects(id object)`  |   移除指定对象的全部关联对象

> 在其他做法不可行的时候可以选用关联对象，这种做法通常会引入难于查找的bug

### 第11条：理解objc_msgSend 的作用
> 消息的传递机制。

```
void printHello(){
    printf("hello!");
}
void printGoodbye() {
    printf("good bye!");
}
// 
void doTheThing(int type){
    if(type == 0) {
        printHello();
    }else {
        printGoodbye();
    }
    return 0;
}
```

```
// "动态绑定(dynamic binding)"效果
void doTheThing(int type){
    void (*func)();
    if(type == 0) {
        func = printHello;
    }else {
        func = printGoodbye;
    }
    func();
    return 0;
}
```
消息由接受者、方法选择器及参数构成。给某对象发送消息，相当于在该对象上调用方法
发给某对象的全部消息，都要由”动态消息派发系统(dynamic message dispatch system)“来处理，该系统会查出对应的方法，并执行其代码。

### 第12条：理解消息转发机制
> 对象在收到无法解读的消息之后会发生什么情况

* 动态方法解析

> 通过运行时的动态方法解析功能，可以在需要用到的某个方法时再将其加入类中。
> 对象在收到无法解读的消息后，首先调用其所属类的下列类方法：

```
+ (BOOL)resolveInstanceMethod:(SEL)sel  //实例方法
+ (BOOL)resolveClassMethod:(SEL)sel     //类方法
```
* 备援接受者

> 当前接受者还有第二次机会处理未知的方法选择，这一步中，运行时系统会问它:能不能把这条消息转给其他接收者来处理。

```
- (id)forwardingTargetForSelector:(SEL)aSelector
```
* 完整的消息转发

```
- (void)forwardInvocation:(NSInvocation *)anInvocation
```

* 消息转发全流程

```flow
st=>start: msg_send
op1=>operation: resolveInstanceMethod
op2=>operation: forwardingTargetForSelector
op3=>operation: forwardInvocation
op4=>operation: 消息未能处理
cond=>condition: 处理？
cond1=>condition: 处理？
cond2=>condition: 处理？
e=>end: 消息已处理


st->op1->cond
cond(no)->op2->cond1
cond1(no)->op3->cond2
cond2(no)->op4
cond2(yes)->e
cond1(yes)->e
cond(yes)->e
```

### 第13条：用”方法调配技术(method swizzling)“调试”黑和方法“
> 在运行时，可以向类中新增或者替换选择方法`@selector`对应的方法实现
> 一般来说，只有调试衡虚的时候才需要在运行时修改方法实现，这种做法不宜滥用。

```
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
```

### 第14条：理解”类对象“的用意
> “在运行时检查对象类型”这一操作也叫做“类型信息查询(introspection,'内省')”,这个强大有用的特性内置于Foundation框架的NSObject协议里。

```
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;
#if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
#endif
} OBJC2_UNAVAILABLE;
```

## 第三章 接口与API设计

### 第15条：用前缀避免命名空间冲突
> 所选前缀可以是与公司、应用程序或二者皆有关联的名字。使用Cocoa创建应用时候，Apple已经宣称保留所有“两个字母前缀”，那么自己的项目最好用三个字母前缀。
> 若自己所开发的程序中用到了第三方库，则应为其中的名称加上前缀，特别是自己的应用代码会成为别人的第三方库的时候。

### 第16条：提供“全能初始化方法”
* 在类中提供一个全能初始化方法，并于文档里指明。其他初始化方法均应调用此方法
* 若全能初始化方法与超类不同，则需覆写超类中的对应方法。
* 如果超类的初始化方法不适用于子类，那么应该覆写这个超类方法，并且在其中抛出异常。

> 有一个全能初始化方法，当需要对接口做调整的时候，特别是底层逻辑实现，只需要修改此方法的代码就好啦。

### 第17条：实现description方法
> description方法应该返回一个有意义的字符串，用意描述该实例
> 若想在调试时打印出更详尽的对象描述信息，则应该实现debugDescription方法(默认直接调用description)。

### 第18条：尽量使用不可变对象
> 若某属性仅可于对象内部修改，则在“class-continuation分类”中将其由readonly属性拓展为readwrite属性。
> 不要把可变的collection作为属性公开，而应提供相关方法，以此修改对象中的可变collection。

### 第19条：使用清晰而协调的命名方式
> 起名时应遵从Objective-C的命名规范
> 参考《易读代码编写艺术》，易读性很重要

### 第20条：为私有方法名加前缀
* 这样可以很容易地将其同公共方法区分开来
* 不要用一个下划线做私有方法的前缀，因为这种做法是预留给苹果公司用的。

### 第21条：理解Objective-C 错误模型






