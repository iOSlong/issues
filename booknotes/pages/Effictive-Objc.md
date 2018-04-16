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
若有发生可使整个应用程序崩溃的严重错误时，才应该使用异常。
在错误不那么严重的情况下，可以指派“委托方法”来处理错误，也可以把错误信息放在NSError对象里，经由“输出参数”返回给调用者。

### 第22条：理解NSCopying协议
若想令自己所写的对象具有拷贝功能，则需实现NSCopying协议，

## 第四章 协议与分类

### 第23条：通过委托与数据源协议进行对象间通信
此模式丰富了对象之间的交互通信方式，还可以将数据与业务逻辑解耦，常用有委托模式与数据源模式(delegate 与 dataSource)

### 第24条：将类的实现代码分散到便于管理的数个分类之中
分类是一种管理代码的好办法，将代码归入不同的“功能区”。同时还便于调试：对于某个分类中的所有方法来说，分类名称都会出现在其符号中。
使用分类机制把类的实现代码划分成易于管理的小块
将应该视为“私有”的方法归入名叫Private的分类中，以隐藏实现细节。

### 第25条：总是为第三方类的分类名称加前缀
> 放置覆盖冲突

### 第26条：勿在分类中声明属性
> 分类机制可以理解为一种手段，目标在于拓展类的功能，而非封装数据。

### 第27条：使用“class-continuation分类”隐藏实现细节
> 常言道:匿名分类

### 第28条：通过协议提供匿名对象
* 协议可在某种程度上提供匿名类型。具体的对象类型可以淡化成遵从某些一的id类型，协议里规定了对象所应实现的方法。
* 使用匿名对象来隐藏类型名称（或类名）。
* 如果具体类型不重要，重要的是对象能够相应（定义在协议里的）特定方法，那么可会用匿名对象来表示。

```
@property (nonatomic, weak)id<XXXDelegate> delegate;
```


## 第五章 内存管理

### 第30条： 以ARC简化引用计数
变量的内存管理语义：
    `__strong`: 默认语义，保留此值
    `__weak`: 不保留此值，但是变量可以安全使用，因为如果系统把这个对象回收了，那么变量也会自动清空，它修饰的属性则指向nil。
    `__unsafe_unretained`: 不保留此值，这么做可能不安全，因为等到再次使用变量时,其对象可能已经回收了，当时它所修饰的属性依然指向那个已经回收的实例。
> 注意：CoreFoundation 对象不归ARC管理，开发者必须适时调用CFRetain/CFRelease.

### 第31条：在dealloc方法中只释放引用并解除监听
* 在dealloc方法里，应该做的事情就是释放指向其他对象的引用，并取消原来订阅的“键值观测(KVO)”或NSNotificationCenter等通知，不要做其他事情。
* 如果对象持有文件描述符等系统资源，那么应该专门编写一个方法来释放此种资源。这样的类要和其使用者约定：用完资源后必须调用close方法。
* 执行异步任务的方法不应再dealloc里调用；只能在正常状态下执行的那些方法也不应再dealloc里调用，因为此对象已经处于正在回收的状态了。

### 第32条：编写“异常安全代码”时留意内存管理问题
* 捕获异常时，一定要注意将try块内所创立的对象清理干净。
* 在默认情况下(OC代码中，只有当应用程序必须因异常状态而终止时才应抛出异常，参看第21条，此时是否内存泄漏已经无关紧要了)，ARC不生成安全处理异常所需的清理代码。开启编译器标志(-fobjc-arc-exceptions)后,可生成这种代码，不过会导致应用程序变大，而且会降低运行效率。

### 第33条：以弱应用避免保留环
将某些引用设为weak，可以避免出现“保留环”。参考第30条。
weak的自动清空是随着ARC而引入的新特性，由运行时系统来实现。在具备自动清空功能的弱引用上，可以随意读取其数据，因为这种引用不会指向已经回收过的对象。

### 第34条：以“自动释放池块”降低内存峰值
自动释放池排布在栈中，对象收到autorelease消息后，系统将其放入最顶端的池里。
合理运用自动释放池，可以降低因公程序的内存峰值。
@autoreleasepool 这种写法能够创建出更为轻便的自动释放池。

### 第35条：用“僵尸对象”调试内存管理问题
系统在回收对象时，可以不将其真的回收，而是把它转化为僵尸对象。通过环境变量NSZombieEnabled可开启此功能。
系统会修饰对象的isa指针，令其指向特殊的僵尸类，从而使该对象变为僵尸对象。僵尸对象能够响应所有的选择子，响应方式为：打印一条包含消息内容及其接受者的消息，然后终止应用程序。

### 第36条：不要使用retainCount


## 第六章 块与大中枢派发
### 第37条：理解“块”这一概念

```
return_type(^block_name)(parameters)
```

* 块的基础知识 
* 块的内部结构
* 全局块、栈块及堆块

> 块是C、C++、Objective-C中的司法闭包。可以接受参数，也可返回值
> 块可以分配在栈或堆上，也可以是全局的。分配在栈上的块可拷贝到堆里，这样的话，就和标准的Objective-C对象一样，具备引用计数了。

### 第38条：为常用的块类创建typedef
以typedef重定义块类型，可令块变量用起来更加简单
定义新类型时应遵从现有的命名习惯，勿使其名称与别的类型相冲突
不妨为同一个块签名定义多个类型别名。如果要重构的代码使用了块类型的某个别名，那么只需要修改响应的typedef中的块签名即可，无须改动其他typedef。

```
typedef <#returnType#>(^<#name#>)(<#arguments#>);
```
> IDE(集成开发环境)可以自动将类型定义展开

### 第39条：用handler块降低代码分散程度


### 第40条：用块引用其所属对象时不要出现保留环
* 如果块所捕获的对象直接或间接地保留了块本身，就得当心保留环问题
* 一定要找个适当的时机解除保留环，而不能把责任推给API的调用者。(or  weak)

### 第41条：多用派发队列，少用同步锁
* 派发队列可用来表述同步语义(synchronization sementic),这种做法比使用@ynchronized块或NSLock对象更简单。
* 将同步与异步派发结合起来，可以实现与普通加锁机制一样的同步行为，而这么做不会阻塞执行异步派发的线程。
* 使用同步队列及栅栏块，可以令同步行为更加高效。

### 第42条：多用GCD，少用performSelector系列方法
* performSelector系列方法在内存管理方面容易疏失。它无法确定将要执行的选择子具体是什么，因而ARC编译器也无法插入适当的内存管理方法。
* performSelector系列方法所能处理的选择子太过局限了，选择子的返回值类型及发送给方法的参数个数都受到了限制。
* 如果想要把任务放在另一个线程上执行，那么最好不要用performSelector系列方法，而是应该把任务封装到快里，然后调用大中枢派发机制的相关方法来实现。

### 第43条：掌握GCD及操作队列的使用时机
* 在解决多线程与任务管理问题时，派发队列并非唯一方案。
* 操作队列提供了一套高层的Objective-C API(NSOpreration)，能实现存GCD所具备的绝大部分功能，而且还能完成一些更为复杂的操作，那些操作若改用GCD来实现，则需另外编写代码。

### 第44条：通过Dispatch Group机制，根据系统资源状况来执行任务

### 第45条：使用dispatch_once来执行只需要运行一次的线程安全代码

### 第46条：不要使用dispatch_get_current_queue


## 第七章 系统框架
### 第47条：熟悉系统框架

### 第48条：多用块枚举，少用for循环

### 第49条：对自定义其内存管理语义的collection使用无缝桥接

### 第50条：构建缓存时选用NSCache而非NSDictionary

### 第51条：精简initialize 与 load 的实现代码

### 第52条：别忘了NSTimer会保留其目标对象
















