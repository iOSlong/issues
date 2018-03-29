## 目标
* 让你的代码更精致美观 【 **可读性高** | **代码应当易于理解** ——让另一个人可以花最少的时间理解你的代码】

> 虽然整个工程结构以及所使用的设计模式等很重要，不过基础的东西才是每一天的每一块代码中都要接触的，我们花费在这些基础内容上的精力才是最多的，因此它很重要。譬如：命名变量，写一个循环或小算法，或者解决一些函数层次的问题等。

## 第一章 代码应当易于理解
### 是什么让代码变得更好？

* *其中 依靠直觉和灵感来决定如何编程*

> 有的情况代码优劣比较容易判断，譬如下面展示相同功能的代码中，code_A1 要比 Code_B1优秀

```C
//Code_A1
for (Node* node = list->head; node != NULL; node = node->next) 
    Print(node->data);
```

```C
//Code_B1
Node* node = list->head;
if (node == NULL) return;
while (node->next != NULL) {   
   Print(node->data);     
   node = node->next; 
} 
if (node != NULL) Print(node->data);
```

> 有的情况下，代码是各有千秋，譬如下面展示代码该如何抉择？

```C
//Code_A2  【紧凑】
return exponent >= 0 ? mantissa * (1 << exponent) : mantissa / (1 << -exponent);
```

```C
//Code_AB  【直白】
if (exponent >= 0) { 
    return mantissa * (1 << exponent);
} else {
    return mantissa / (1 << -exponent); 
}
```
### 可读性基本定理
**关键思想： 
代码的写法应该使别人理解它所需要的时间最小化**

> 也许这段代码无别人参与，但是这个别人包括半年之后的你，所以对自己好一点就是对别人好一点，反之亦然，you are not along。


### 总是越小越好吗？

> 有时候对一行代码理解所花的时间会更久

```
assert((!(bucket = FindBucket(key))) || !bucket->IsOccupied());
```
```
bucket = FindBucket(key);
if (bucket != NULL) {
   assert(!bucket->IsOccupied());
}
```
> 相似的，有时添加一条评论注释增加了'代码量'，但是可以使你更快的理解代码

```
// Fast version of "hash = (65599 * hash) + c" 
hash = (hash << 6) + (hash << 16) - hash + c;
```

> 所以减小代码量是一个目标，也是一个手段，把理解代码所需时间最小化才是最重要的。

### 理解代码耗时少是否与其他目标有冲突？
你可能会想，其他约束呢？譬如代码效率，架构设计，易测性等，这些会否有时与目标代码易于理解冲突？
> 相信我，无论是你写基础代码或者多么高级的代码，易读性原则必然能更好的助力于你的代码效率、设计架构、代码容易测试等。

> 最难的部分: 经常去思考他人是否容易理解你的代码，这会让你变得更好。


# 第一部分 表面层次的改进
*【选择好的名字】* *【写好的注释】* *【好的代码整洁格式】* ……
> 这些东西将会影响你代码的每一行。



## 第二章 把信息装到名字里

**关键思想： 
把信息装到名字里**
> 本章包括六个专题：

* 选择专业的词
* 避免tmp和retval这样泛泛地名字(要知道什么时候使用它)
* 用具体的名字代替抽象的名字
* 使用前缀或后缀来给名字附带更多信息
* 决定名字的长度
* 利用名字的格式来表达含义

### 选择专业的词

例 1:

```
def getPage(url): ……
```
> get这个词没有表达更多信息，譬如有来自缓存、数据库、来自网络的数据,可以针对性有专业一点的词：

```
fetchPage()
downloadPage()
```

-------

例 2:


```
class BinaryTree { 
    int Size();    
    ...
```
> Size()没有包含更多关于返回值的信息，到底是节点数，树高，或者树内存占空间…… 譬如可以有下面是比较合理的命名

```
Height(), 
NumNodes()
MemoryBytes()
```

-------

例 3:

```
class Thread {
    void Stop(); 
    ... 
};
```
> Stop()是可以的，但是还可更具情况更具体一点，譬如这是一个重量级不可恢复的操作可以用'Kill()', 或者如果有一个Resume()方法相配合的话，用Pause()更合适

#### 找到更有表现力的词
**关键思想： 
清晰和精确是可爱的**

表意词汇 |  更多选项
--------- | -------
send    |   deliver, dispatch, announce, distribute, route   
find    |   search, extract, locate, recover
start   |   launch, create, begin, open
make    |   create, set up, build, generate, compose, add, new
 

### 避免tmp和retval这样泛泛地名字(要知道什么时候使用它)

* 建议： **选择一个能够描述实体值属性或者目的的名字**

-------
例 1：

```
var euclidean_norm = function (v) {
     var retval = 0.0;
     for (var i = 0; i < v.length; i += 1)
          retval += v[i] * v[i];
     return Math.sqrt(retval);
 };
```
> retval只能看出是一个返回值，这里看出其目的是存储一个值得平方累加，sum_squares.将更合适。再譬如将内部代码写成retval += v[i] 对比 sum_squares += v[i]，bug缺陷看起来也就更明显了('square 哪里去了？')。

#### tmp

* 建议： **tmp只用于短期存在且临时性为其主要存在因素的变量**

-------
例 2：

```
if (right < left) {     
tmp = right;     
right = left;     
left = tmp; 
}
```
> 此处tmp使用没有任何问题， 因为它的作用就是一个用于交换值的临时变量，并且生命周期就在这个函数中这几行代码，并无其它意义和用处。

```
String tmp = user.name();
tmp += " " + user.phone_number(); 
tmp += " " + user.email(); 
... 
template.set("user_info", tmp);
```
> 此处tmp的临时存储作用反而在其次，如果使用user_info这样的名字就更具有描述性。接着看下面的代码。

```
tmp_file = tempfile.NamedTemporaryFile() 
... 
SaveData(tmp_file, ...)
```
> 设想此处如果tmp_file改用tmp，那我们将无法确定SaveDate(tmp,...)中，tmp到底是文件，是文件名，还是一个被写入的数据？

#### 循环迭代器
当，i 、j、k，虽然这些名字比较空泛，但是大家看见他们时候就知道，这是在自报家门"我是一个迭代器"，通常如果用其它描述性的词汇来替代反而会使代码混乱。
> 有时候也会出现比 i , j , k更贴切的名字：

例 3：

```
for (int i = 0; i < clubs.size(); i++)  
   for (int j = 0; j < clubs[i].members.size(); j++)     
       for (int k = 0; k < users.size(); k++)             
          if (clubs[i].members[k] == users[j])
             cout << "user[" << j << "] is in club[" << i << "]" << endl;
```
> 上面代码中members[k]和users[j]用错了索引，但是单独看if (clubs[i].members[k] == users[j]) 时候bug并不明显，这种情况可以使用更精确的描述命名：(club_i, members_i, users_i) 或者更精简一点的 (ci, mi, ui).

```
if (clubs[ci].members[ui] == users[mi])  # Bug! 第一个字符不匹配.
if (clubs[ci].members[mi] == users[ui])  # OK. First letters match.
```
#### 对空泛名字的裁定

* 建议： **如果打算用一个像tmp，it，retval这样的空泛命名，需要有一个好的使用它的理由**

> 不要因为懒惰而滥用命名，养成一个习惯多花几秒钟想个好名字，习惯成自然"命名能力"就会提升。

### 用具体的名字代替抽象的名字
例 1：检测服务器是否可以监听某个给定的TCP/IP端口

```
ServerCanStart()    // 有点抽象
CanListenOnPort()   // 相对更具体，直接描述了这个方法要做的事情。
```
例 2：本地运行 - run_locally
如果是与运行环境有关(比如区分测试环境和线上环境，run_locally标识开发测试环境)，又或者要标识使用一个特殊的本地数据库，那么可以将标志更明确一点如:

```
- extra_logging
- use_local_database
```
> 尽管使用了两个标志，但是标志非常明确，不会混淆两个正交的含义，并且可以明确的选择一个。

*--YSDQ中这样的案例 如：backAction，back，等命名都是比较抽象的，没有dismissOnlinePlayer、popOut……来的具体*

### 使用前缀或后缀来给名字附带更多信息
> 变量名就像一个小小注释，所以应该好好应用

```
string id; //Example:"af84ef845de1"
```
譬如上面，你有一个十六进制格式的字符串变量,如果要强调这一点，那么用"hex_id"替换将会更好。
#### 带单位的值

```
var start = (new Date()).getTime();  // top of the page ...
var elapsed = (new Date()).getTime() - start;  // bottom of the page 
document.writeln("Load time was: " + elapsed + " seconds");
```
> 上面JS代码不能执行，并且没有明显的错误，其实就是因为getTime()返回的是ms单位时间。所以代码可以矫正如下：

```
var start_ms = (new Date()).getTime();  // top of the page ...
var elapsed_ms = (new Date()).getTime() - start_ms;  // bottom of the page 
document.writeln("Load time was: " + elapsed_ms / 1000 + " seconds");
```

*罗列部分带单位的与无单位参数：*

函数参数    |   带单位的参数
------- |--------
 Start(int delay )  |   delay →  delay_secs  
 CreateCache(int size )   | size →  size_mb  
 ThrottleDownload(float limit)  |   limit →  max_kbps  
 Rotate(float angle)  | angle →  degrees_cw
 
#### 附带其他重要属性
给名字附带额外信息的技巧不仅限于单位，对于这个变量存在危险或者意外的任何时候都应该采用它。
> 示例列表：

 Situation  |   Variable name   |   Better name 
------- |-------- | ----------
 村文本格式密码，需要加密后使用    |   password    |   plaintext_password  
 需要转义后才能使用显示的用户注释   |  comment   |  unescaped_comment  
 已转为UTF-8格式的html字节  | html  |   html_utf8  
 以"url方式编码"的输入数据    |   data   |  data_urlenc

> 微软内部广泛使用的 HUNGARIAN notation【匈牙利标识法】，它是一种正式严格的例子，关注于特有的一系列属性：

 Name   |   Meaning
------- |--------
 pLast  |   指向某数据结构最后一个元素的指针
 pszBuffer  |   指向一个以零结尾(z)的字符串(s)的指针(p)
 cch    |   一个字符(ch)计数(c)
 mpcopx |   指向颜色的指针(pco)和指向x轴长度指针(px)之间的一个映射
 
> 对于系统严格的暂且作为参考， 我们提倡的是更广泛、非正式的系统，标识变量的任何属性，如果有需要就以易读的方式加入名字中，可以称之为"英语标识法"


### 决定名字的长度
名字不应该太长，太长了不容易记住，占地方，还会产生换行。但名字也不能走另外一个极端，用单个单词甚或字母。那么该如何平衡呢，这里有一些指导原则：

* 在小的作用域里可以使用短的名字
    
    ```
    if (debug) {
        map<string,int> m;
        LookUpNamesNumbers(&m);     
        Print(m); 
    }
    ```
    > 此处m这个名字没包含很多信息，但是这段代码信息已经清楚，所以没问题。 但是假设m是一个全局变量，那么代码就不好读了，因为m的类型和目的不明确。
    因此如果一个标识符有较大的作用域，那么它的名字需要保护足够多的信息以便含义更清楚。
    
* 首字母缩略词和缩写
    **团队新成员是否能够理解这个名字的含义？**
    1. 系统或项目特有缩写 FB-FaceBook，NS-NextStep, DQ-YSDQ, ……
    2. 比较广泛通用易于理解的 eval-evaluation，doc-document，str-string ……
    3. 纯词意缩写，BEManager-BackEndManager， 
   
    > 经验原则是：*团队新成员是否能够理解这个名字的含义？* 如上使用中，新人对FormatStr()可能比较理解，理解BackEndManager就比较困难了。

* 丢掉没用的词
    > 对于函数或变量如果拿掉某个词不影响任何意义，那么就拿掉吧
    
    例： 
        convertToString()可以直接用toString，语义毫无缺失
        DoServeLoop()置换为ServeLoop，也同样清晰明白的

### 利用名字的格式来表达含义
对于 **下划线**、**连字符**、**大小写** 等格式的使用方式可以把更多信息装到名字中。就像语法高亮一样便于阅读理解代码。

一些通用的示例：

*   驼峰样例来标识类名（CamelCase）
*   小写字母下划线分隔用作变量名（lower_seperated）
*   常量格式：kConstantName 而不是 CONSTANT_NAME. 这样做的好处是易于和#define宏区分开来，宏的规范是：MACRO_NAME.
*   其它格式规范
    
    

## 第三章 不会误解的名字
**关键思想： 
自己多审视这个问题："这个名字会被被人理解成其它的含义吗？"**
#### Example: Filter()

```
results = Database.all_objects.filter("year <= 2011")
```
> 由于单词filter是一个二义性的单词，所以results现在包含信息有两个：
    1. 年份小于或等于2011的所有对象, 此时是选择包含，用select()会更好
    2. 年费大于2011的所有对象，此时是选择选择排除，用exclude()会更好。
    
#### Example: Clip(text, length)

```
# Cuts off the end of the text, and appends "..."
def Clip(text, length):
... 
```

 Clip()可能有两重意思：
    1. 从尾部删除掉length的长度
    2. 切掉最大长度为length某一段
    
> 如果是第二个意思，那么用Truncate(text,length)会更高。然而此时参数length又存在异议，改为max_length会更清晰一些。但是什么长度还是会有歧义：
1. 是字节数(max_bytes)  
2. 是字符数(max_chars)
3. 是单词数(max_words)

#### 推荐使用min和max来表示(包含)极限
* 建议： **命名极限最清楚的方式是在要限制的东西前加上max_或min_.**

#### 推荐用first和last来标识包含的范围

```
print integer_range(start=2, stop=4) # Does this print [2,3] or [2,3,4] (or something else)?
```
> start是合理的，但是stop无法确定是否包含边界条件4. 此时first/last就是比较好的一组选择：

```
set.PrintKeys(first="Bart", last="Maggie")
```

#### 推荐用begin和end来标识包含/排除范围
> 人总是会有习惯性思维方式，如从始到终，从左到右，从小到大，尤达表达式违规等。 下面两行代码中第一种写法就是比较遵循这种规律的。

```
PrintEventsInRange("OCT 16 12:00am", "OCT 17 12:00am")
// 写成下面的情况就比较难琢磨了
PrintEventsInRange("OCT 16 12:00am", "OCT 16 11:59:59.9999pm")
```

#### 给布尔值命名
当为布尔变量或者返回布尔值的函数选择名字时，要确保返回true和false的意义很明确。
例：

```
bool read_password = true;
// 这里布尔变量存在二义性
    1. 需要读取密码
    2. 密码已经被读取
```
> 这里最好避开"read", 根据上下文重命名参考为：need_password 或者 user_is_authenticated。

* 通常，添加 **is，has，can，shoud ……** 这些单词可以使得布尔值更清楚。比如函数SpaceLeft()像是返回一个数字，如果本意是返回一个布尔值，那HasSpaceLeft()更合适。
* 最好避免使用反义名字:
    
    ```
    bool disable_ssl = false;
     //更简单易读并且紧凑的方式是：  
    bool use_ssl = true;
    ```
#### 与使用者的期望相匹配
写什么样的名字，它的功用应该与其含义相匹配。

-------

例子：get*()
> 我们常将get开始的方法当做"轻量级访问器"这样的用法，它只会做简单的运算和返回，如果违背这个习惯可能会误导使用者。

```
public class StatisticsCollector {
    public void addSample(double x) { ... }     public double getMean() {
        // 遍历所有数据并计算中值 / num_samples
      }
       ...
  }
```
> 如果有大量数据，getMean这部操作将会很昂贵，但是容易轻信get*习惯的程序员可能会随意调用getMean而以为毫无代价。
> 这种种情况下，可以用computeMean来替代，让人感觉此操作还是有些代价的。
> 或者实现getMean并真正使他成为一个轻量级的方法。

-------
例子:list:size() 
> 曾经的一个C++标准库中的例子，这个缺陷导致一台服务器蜗牛般运行

```
void ShrinkList(list<Node>& list, int max_size) {
    while (list.size() > max_size) {
         FreeNode(list.back());
         list.pop_back();
    }
}
```
> "bug"是作者不知道当时list.size()时间复杂度为是O(n)，这样实际上ShrinkList()的时间复杂度就成了O(n^2 ),而当在外部ShrinkList()被用于百万级量的元素列表上，耗时很长很长~。
> 假使size()的名字是countSize()或者countElements(),就很可能避免这样的失误。

*最新的C++标准库中size()已经被做成了O(1)*

#### 如何权衡多个备选名字
根据情况而定

```
// Origin
experiment_id: 100 
description: "increase font size to 14pt" traffic_fraction: 5% ...
```
> 加入有这样的场景，需要同样的对象中含有两一个Origin对象的experiment_id。那么the_other_experiment_id_I_want_to_reuse该怎么命名？

```
// reuseidFrom Origin
experiment_id: 100 
the_other_experiment_id_I_want_to_reuse: 100
description: "increase font size to 14pt" traffic_fraction: 5% ...
```
> 关于属性 the_other_experiment_id_I_want_to_reuse 可选倾向：
    1. template 
    2. reuse
    3. copy 
    4. inherit
综合考虑下来，copy_experiment 和 inherit_from_experiment_id是较好的选择。



## 第四章 审美
**好代码养眼**,在这一章中，主要展示了如何使用空格符，对齐方式，以及排序规则来让代码变得更易阅读。

三条原则：

* 使用一致的布局，让读者很快习惯这种风格
* 让相似的代码看起来相似
* 对相关代码行进行分组，形成代码块。

#### 为什么审美那么重要

```
1. 混乱代码示例：
class StatsKeeper {
public: 
// A class for keeping track of a series of doubles    
 void Add(double d);  // and methods for quick statistics about them 
 private:   int count;        /* how many so    far  */
 public:         
        double Average(); 
private:   double minimum; 
list<double>
   past_items
          ;double maximum; 
}; 
========================
2. 整洁代码示例
// A class for keeping track of a series of doubles 
// and methods for quick statistics about them. 
class StatsKeeper {
   public:
        void Add(double d);
        double Average();
   private:
        list<double> past_items;
        int count;  // how many so far  
           
        double minimum;     
        double maximum; 
 };
```
> 很明显，**使用从优美让人愉悦的代码更容易** 编程大部分时间都是花费在阅读代码上，代码越容易阅读，那么也越就容易使用。

#### 重新安排换行来保持一致和紧凑

> 一段评估不同网络环境连接速度下的行为，有TcpConnectionSimulator类，这里假设需要三个TcpConnectionSimulator实例：

```
public class PerformanceTester {
     public static final TcpConnectionSimulator wifi = new TcpConnectionSimulator(
              500, /* Kbps */         
              80, /* millisecs latency */         
              200, /* jitter */         
              1 /* packet loss % */);     
     public static final TcpConnectionSimulator t3_fiber =  new TcpConnectionSimulator(
                  45000, /* Kbps */             
                  10, /* millisecs latency */             
                  0, /* jitter */             
                  0 /* packet loss % */); 
     public static final TcpConnectionSimulator cell = new TcpConnectionSimulator(
              100, /* Kbps */         
              400, /* millisecs latency */         
              250, /* jitter */         
              5 /* packet loss % */);
}
```
> 通过加入换行处理，让相似的代码看上去相似，同时让注释对齐。

```
public class PerformanceTester {
     public static final TcpConnectionSimulator wifi =
        new TcpConnectionSimulator(
              500,   /* Kbps */         
              80,    /* millisecs latency */         
              200,   /* jitter */         
              1      /* packet loss % */);     
     public static final TcpConnectionSimulator t3_fiber =
        new TcpConnectionSimulator(
              45000, /* Kbps */             
              10,    /* millisecs latency */             
              0,     /* jitter */             
              0      /* packet loss % */); 
     public static final TcpConnectionSimulator cell =
        new TcpConnectionSimulator(
              100,   /* Kbps */         
              400,   /* millisecs latency */         
              250,   /* jitter */         
              5      /* packet loss % */);
}
```
> 上面的已经很清朗，不过还是纵向占空间多，注释重复。

```
public class PerformanceTester {
     // TcpConnectionSimulator(throughput, latency, jitter, packet_loss)     
     //                            [Kbps]   [ms]    [ms]    [percent]    
      
     public static final TcpConnectionSimulator wifi =         
        new TcpConnectionSimulator(500,    80,     200,    1);    
     public static final TcpConnectionSimulator t3_fiber =         
        new TcpConnectionSimulator(45000,  10,     0,      0);     
     public static final TcpConnectionSimulator cell =         
        new TcpConnectionSimulator(100,    400,    250,    5);
}
```


#### 用方法来整理不规则的东西
> 整理过后，可能不只是觉着看上去漂亮，它可能会帮你把代码结构做的更好

#### 在需要时使用列对齐
> 使得代码结构清晰，带来的好处包括了便于发现问题

```
# Extract POST parameters to local variables 
details  = request.POST.get('details') 
location = request.POST.get('location') 
phone    = equest.POST.get('phone') // 可以很快发现代码中的问题
email    = request.POST.get('email') 
url      = request.POST.get('url')
```

#### 选一个有意义的顺序，始终一致地使用它
> 譬如一组变量，不要随机的排序，可以参考一些处理顺序的想法：

1. 让变量的顺序与对应使用顺序相匹配
2. 从 "最重要" 到 "最不重要" 排序
3. 按字母顺序排序

> 选定一个顺序之后，整个代码中最好对这种顺序保持一致。

#### 把声明按块组织起来

```
class FrontendServer {
   public:
        FrontendServer();     
        ~FrontendServer();     
        // Handlers     
        void ViewProfile(HttpRequest* request);     
        void SaveProfile(HttpRequest* request);     
        void FindFriends(HttpRequest* request);     
        
        // Request/Reply Utilities     
        string ExtractQueryParam(HttpRequest* request, string param);    
        void ReplyOK(HttpRequest* request, string html);     
        void ReplyNotFound(HttpRequest* request, string error);     
        
        // Database Helpers     
        void OpenDatabase(string location, string user);     
        void CloseDatabase(string location);
 };
```

#### 把代码分成"段落"
分段落可解释为如下几个原因：

1. 它是一种把相似的想法放在一起，并与其他想法分开的方法
2. 它提供了可见的"脚注标记"，没有它容易丢失自己的阅读进度
3. 便于段落之间的导航

```
def suggest_new_friends(user, email_password):
    # Get the user's friends' email addresses.     
    friends = user.friends()     
    friend_emails = set(f.email for f in friends) 
    
    # Import all email addresses from this user's email account.     
    contacts = import_contacts(user.email, email_password)     
    contact_emails = set(c.email for c in contacts)     
    
    # Find matching users that they aren't already friends with.     
    non_friend_emails = contact_emails - friend_emails     
    suggested_friends = User.objects.select(email__in=non_friend_emails)     
    
    # Display these lists on the page.     
    display['user'] = user   
    display['friends'] = friends     
    display['suggested_friends'] = suggested_friends 
    return render("suggested_friends.html", display)
```

#### 个人风格与一致性
**关键思想： 
保持一致的风格比，"正确"的风格更重要**
> 当选择了某一种风格之后，代码中应当都是用统一的风格

```
class Logger {
     ... 
}; 
//或者
class Logger
{ 
     ... 
};
```


## 第五章 怎样写注释
**关键思想： 
注释的目的是尽量帮助读者了解和作者一样多。**

#### 什么不需要注释
**关键思想： 
不要为那些从代码本身就能【快速】推断的事实写注释。**

```
// The class definition for Account 
class Account {
   public:
        // Constructor
        Account();  
           
        // Set the profit member to a new value     
        void SetProfit(double profit);    
         
        // Return the profit from this Account     
        double GetProfit(); 
};
```
> 上面的注释，没有任何代码本身可传达之外的新信息，也没有帮助读者理解代码，所以是不值当的。

不需要 "拐杖式注释" ！ 好代码 > 坏代码 + 好注释

```
// Releases the handle for this key. This doesn't modify the actual registry. 
void DeleteRegistry(RegistryKey* key);
```

一个更加自我说明的名字，就像：

```
void ReleaseRegistryHandle(RegistryKey* key);
```
> 不要给不好的名字加注释 —— 应该把名字改好。（一个好的名字比一个好的注释更重要）


#### 记录你的思想
1. 加入 "导演评论"
    

2. 伪代码中的瑕疵写注释

    标记    |   通常的意义
    ------- |--------
    TODO:  |   还没有处理的事情  
    FIXME:   | 已知无法运行的代码
    HACK:   | 对一个问题不得不采用一粗糙的解决方案
    XXX:    | 危险！这里有重要的问题


3. 给常量加注释
    
    
#### 站在读者的角度,想象他们需要知道什么
1. 意料之中的提问
2. 公布可能的陷阱
3. "全局观" 注释
4. 总结性注释

> 鼓励做任何对读者理解代码更容易的事情，这可能就是添加注释说明 **是什么** **怎么做** 或者 **为什么**（或者全部说明）

#### 最后的思考——客服"作者心里阻滞"
> 如果觉得写注释麻烦，可以把这件事才分几个简单的步骤

1. 写下脑海中任何的想法作为注释
2. 阅读以下注释，看有没有可以改进的地方
3. 不断的改进。


## 第六章 写出言简意赅的注释
**关键思想： 
注释应该有很高的 信息&空间 效率**

#### 让注释保持紧凑

```
// The int is the CategoryType. 
// The first float in the inner pair is the 'score', 
// the second is the 'weight'. 
typedef hash_map<int, pair<float, float> > ScoreMap;
```
> 没必要三行注释：

```
// CategoryType -> (score, weight) 
typedef hash_map<int, pair<float, float> > ScoreMap;
```

#### 避免使用不明确的代词


#### 润色粗糙的句子
> 一个关于网页爬虫的例子

```
# Depending on whether we've already crawled this URL before, give it a different priority. 

This sentence might seem okay, but compare it to this version: 

# Give higher priority to URLs we've never crawled before.
```

#### 精确地描述函数的行为


#### 用输入/输出例子来说明特别的情况
```
// Remove the suffix/prefix of 'chars' from the input 'src'. 
String Strip(String src, String chars) { ... }
```
> 下面的注释更加直白明了

```
// ... 
// Example: Strip("abba/a/ba", "ab") returns "/a/" 
String Strip(String src, String chars) { ... }
```

#### 声明代码的意图

#### "具名函数参数" 的注释

```
void Connect(int timeout, bool use_encryption) { ... } 

// Call the function with commented parameters 
Connect(/* timeout_ms = */ 10, /* use_encryption = */ false);
```

#### 采用信息含量高德词

# 第二部分 简化循环和逻辑

## 第七章
如何把代码中的控制流变得易读。
**关键思想： 
把条件、循环以及其他对控制流的改变做的越"自然"越好，不要让读者停下来重读你的代码**

#### 条件语句中参数的顺序
> 在判断语句中，你是如何确定 `a < b`  或者 `b < a` 哪一个更好的
这里有一些有用的指导:

比较的左侧 | 比较的右侧
--------|---------
被询问者，它的值更趋于变化    |   被比较者，更趋于常量

> 这是一种语言习惯逻辑，好比"如果你不小于18岁" 比 "如果18岁小于或等于你的年龄" 更自然。

关于友达表示式 `if(NULL == obj) ···` 已经过时。
> 这种表达其实是违法了自然语言习惯的， 当初是为了避免 `obj=null` 的错写， 如今的编译器已经可以发现并给予条件句中的这个错误写法警告， 所以它已经过时。

#### if/else语句块的顺序
> 一些参考思路

* 优先处理正逻辑的情况，例如： 用`if(debug)` 而不是 `if(!debug)`。
* 先出掉简单的情况，这还会使得 `if` 和 `else` 在屏幕内可见，是件好事。
* 先处理掉有趣的或者是可疑的情况。

> 总而言之，不要使得 if/else 感觉别扭。

#### ？：条件表达式("三目运算符")
**关键思想： 
相对于最求代码函数少，一个更好的度量标准是 最小化理解这块代码所需要的时间**

* 建议： **默认情况下都用if/else. 三目运算符 ？：只有在最简单的情况下使用**

#### do/while循环
C++ 的开创者Bjarne Stroustrup 《C++程序设计语言》 ：
> 我的经验是， do语句是错误和困惑的来源，……我倾向于把条件放在“前面我能看到的地方”。其结果是，我倾向于避免使用do语句。

#### 从函数中提前返回

```
public boolean Contains(String str, String substr) {
     if (str == null || substr == null) return false;     
     if (substr.equals("")) return true;
          ... 
}
```
#### 臭名昭著的goto

#### 最小化嵌套
* 嵌套是如何累计而成的

**关键思想： 
当你对代码做改动时，从全新的角度审视它，把它作为一个整体来看待。**

* 通过提早返回来减少嵌套

```
if (user_result != SUCCESS) {
     reply.WriteErrors(user_result);     
     reply.Done();     
     return; 
}
if (permission_result ！= SUCCESS) {
     reply.WriteErrors(permission_result);     
     reply.Done();
     return; 
} 
reply.WriteErrors(""); 
reply.Done();
```
* 减少循环内的嵌套

```
for (int i = 0; i < results.size(); i++) { 
    if (results[i] != NULL) {         
        non_null_count++;         
        if (results[i]->name != "") {
         cout << "Considering candidate..." << endl;             
         ...         
        }     
    }
   }
```
> 与 `if(···)return;` 在函数中所扮演的保护语句一样，利用`if(···)continue;` 作为循环中的保护与句，减少嵌套。

```
for (int i = 0; i < results.size(); i++) {
    if (results[i] == NULL) continue;     
    non_null_count++;
    if (results[i]->name == "") continue;     
    cout << "Considering candidate..." << endl;    
    ... 
 }
```

#### 你能理解执行的流程吗

## 第八章 拆分超长的表达式
> 简而言之，代码中的表达式越长，它就越难以理解
**关键思想： 
把你的超长的表达式拆分成更容易理解的小块。**

#### 用作解释的变量

```
Here is an example: if line.split(':')[0].strip() == "root":     ... 
```

> 额外的变量有时叫做”解释变量“，它可以帮组理解字表达式的含义。

```
username = line.split(':')[0].strip() 
if username == "root":
     ...
```
#### 总结变量

```
if (request.user.id == document.owner_id) {
     // user can edit this document... 
} 
... 
if (request.user.id != document.owner_id) {
      // document is read-only... 
}
```
> `if(user_owns_document)` 更容易理解，并且定义之后，可提前告知读者”这是在整个函数中都会应用的一个概念“

```
final boolean user_owns_document = (request.user.id == document.owner_id); 
if (user_owns_document) {
    // user can edit this document... 
} 
... 
if (!user_owns_document) {
     // document is read-only... 
}
```

#### 使用德摩根定理
*    ! (a || b || c)   ⇔   (! a) && (! b) && (! c) 
*    ! (a && b && c)   ⇔   (! a) || (! b) && (not c)

> 可以运用这个法则让布尔表达式更具有可读性

```
if (!(file_exists && !is_protected)) 
Error("Sorry, could not read file."); 
// It can be rewritten to: 
if (!file_exists || is_protected) 
Error("Sorry, could not read file.");
```

#### 滥用短路逻辑
**关键思想： 
要小心”智能“的小代码段 —— 他们往往在以后让人阅读起来感到困惑。**


```
assert((!(bucket = FindBucket(key))) || !bucket->IsOccupied());
```
> 上面短路判断容易成为思维上的减速带，让阅读感到困惑！ 推荐模式:

```
bucket = FindBucket(key); 
if (bucket != NULL) assert(!bucket->IsOccupied());
```
#### 例子: 与复杂的逻辑战斗
* 找到更优雅的方式

#### 拆分巨大的语句

#### 另一个简化表达式的创意方法
* 利用宏代码处理相同的代码

```
void AddStats(const Stats& add_from, Stats* add_to) {
     add_to->set_total_memory(add_from.total_memory() + add_to->total_memory());     
     add_to->set_free_memory(add_from.free_memory() + add_to->free_memory());     
     add_to->set_swap_memory(add_from.swap_memory() + add_to->swap_memory());     
     add_to->set_status_string(add_from.status_string() + add_to->status_string());     
     add_to->set_num_processes(add_from.num_processes() + add_to->num_processes());     
     ... 
 }
```
> 不过引入宏的方式应该小心注意权衡可读性，它会让代码变得令人困惑并且引入细微的bug。

```
void AddStats(const Stats& add_from, Stats* add_to) {
     #define ADD_FIELD(field) add_to->set_##field(add_from.field() + add_to->field()) 
         
     ADD_FIELD(total_memory);     
     ADD_FIELD(free_memory);     
     ADD_FIELD(swap_memory);     
     ADD_FIELD(status_string);     
     ADD_FIELD(num_processes);     
     ...     
     #undef ADD_FIELD 
   }
```

## 第九章 变量与可读性
1. 变量越多，越难以追踪它们的动向
2. 变量作用域越大，需要追踪它的时间越长
3. 变量值发生变化频率越高，越难追踪它的当前值

#### 减少变量
* 没有价值的临时变量

```
now = datetime.datetime.now() 
root_message.last_view_time = now
```
> 1. 没有拆封任何复杂的表达式
> 2. 没有做更多的澄清——表达式datetime.datetime.now()已经很清楚了
> 3. 它只用过一次，因此并没有压缩任何冗余代码

```
root_message.last_view_time = datetime.datetime.now()
```

* 减少中间结果

```
var remove_one = function (array, value_to_remove) {
     var index_to_remove = null; 
     for (var i = 0; i < array.length; i += 1) {
        if (array[i] === value_to_remove) {
              index_to_remove = i;
              break;         
         }     
     }     
     if (index_to_remove !== null) {
        array.splice(index_to_remove, 1);     
     }
 };
```
>  通常来讲 ”速战速决“ 是一个号策略:

```
var remove_one = function (array, value_to_remove) {
     for (var i = 0; i < array.length; i += 1) {
        if (array[i] === value_to_remove) {
            array.splice(i, 1);     
            return;         
         }     
     }     
 };
```

* 减少控制流变量
```
boolean done = false; while (/* condition */ && !done) {
     ...     
     if (...) {
        done = true;
        continue;
     }
}
```
> 像 done 这样的变量， 称为”控制流变量“ 可以通过更好的运用结构化编程而消除

```
while (/* condition */) {
     ...     
     if (...) {
        break;     
     } 
}
``` 

#### 缩小变量的作用域
**关键思想： 
让你的变量对尽量少的代码可见.**

* 权衡局部变量可以处理的不要写成全局变量
* 不要引入没有必要的解释型变量，譬如判断语句中
* 注意不同语言规则里嵌套的作用域问题
* 把定义向下移。

> 把变量移到一个有最少代码可以看到它的地方。眼不见，心不烦。

#### 只写一次的变量更好
**关键思想： 
操作一个变量的地方越多，越难确定它的当前值.**

> 那些只设置一次的变量（或者const、final、常量）使得代码更容易理解。

#### 最后的例子

# 第三部分 重新组织代码


## 第十章 抽取不相关的子问题

#### 介绍性的例子:findclosestlocation()
> 将复杂功能做函数封装从引用函数中抽取出去，让读者可以注重高层次目标，而不是耗时纠结那部分复杂的运算代码

#### 纯工具代码
> 像操作字符串、使用哈希表以及读写文件···等， 是大多数程序都会做的核心任务。通常这些 “基本工具” 是有编程语言内置的库实现的
> 否则，如果你在想 “我希望我们的库里有一个XYZ()函数”，那么就写一个。

#### 其他用途代码
> 抽取出的功能代码使得代码简单，并且抽出部分方便调用，而且它自成一体后改进它变得更容易。

#### 创建大量通用代码


#### 项目专有的功能


#### 简化已有接口
> 你永远都不要安于使用不理想的接口

#### 按需要重塑接口


#### 过犹不及


## 第十一章 一次只做一件事
**关键思想： 
应该将代码组织成一次只处理一件事情.**

#### 任务可以很小
假设一个投票选择按钮有【up | down】 注意一个选民可以是首次投票，或者是更改他的选票结果。那么这个一次投票分数运算的函数初始如下:

```
var vote_changed = function (old_vote, new_vote) {
     var score = get_score();
     if (new_vote !== old_vote) {
         if (new_vote === 'Up') {
             score += (old_vote === 'Down' ? 2 : 1);          } else if (new_vote === 'Down') { 
             score -= (old_vote === 'Up' ? 2 : 1); 
         } else if (new_vote === '') { 
             score += (old_vote === 'Up' ? -1 : 1);
         }
    }
       set_score(score);
  };
```
> 上面的代码做了两件事情，并且看着粗综复杂。 
    1. 把old_vote 和 new_vote 解析成数字值
    2. 更新分数。
  经过拆分处理如下，容易理解很多：
  
```
var vote_value = function (vote) {
    if (vote === 'Up') {    
         return +1;     
    }
    if (vote === 'Down') {    
         return -1;  
    }     
    return 0; 
};

var vote_changed = function (old_vote, new_vote) {  
   var score = get_score();     
   score -= vote_value(old_vote);  // remove the old vote     
   score += vote_value(new_vote);  // add the new vote     
   set_score(score); 
};
```

#### 从对象中抽取值


#### 更大型的例子


## 第十二章 把想法变成代码

## 第十三章 少写代码

# 第四部分 精选话题

## 第十四章 测试与可读性

## 第十五章 




    



