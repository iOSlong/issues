## otool 工具
### Mac OS X下的ldd工具
Linux下经常会用到ldd查看程序使用了哪些共享链接库，很方便的一个工具，在Mac OS X上没有这个命令，如果想在Mac OS X查看程序使用了哪些链接库可以用otool 来代替。

OS X 不使用 ELF二进制文件,在OS X获得可执行文件所依赖的共享库列表，需要使用 otool 工具.

> otool(object file displaying tool)
针对目标文件的展示工具，用来发现应用中使用到了哪些系统库，调用了其中哪些方法，使用了库中哪些对象及属性，它是Xcode自带的常用工具。下面是一些常用的命令：

```
bogon:tempFiles lxw$ otool -help
error: /Library/Developer/CommandLineTools/usr/bin/otool: unknown char `p' in flag -help

Usage: /Library/Developer/CommandLineTools/usr/bin/otool [-arch arch_type] [-fahlLDtdorSTMRIHGvVcXmqQjCP] [-mcpu=arg] [--version] <object file> ...
	-f print the fat headers
	-a print the archive header
	-h print the mach header
	-l print the load commands
	-L print shared libraries used
	-D print shared library id name
	-t print the text section (disassemble with -v)
	-p <routine name>  start dissassemble from routine name
	-s <segname> <sectname> print contents of section
	-d print the data section
	-o print the Objective-C segment
	-r print the relocation entries
	-S print the table of contents of a library
	-T print the table of contents of a dynamic shared library
	-M print the module table of a dynamic shared library
	-R print the reference table of a dynamic shared library
	-I print the indirect symbol table
	-H print the two-level hints table
	-G print the data in code table
	-v print verbosely (symbolically) when possible
	-V print disassembled operands symbolically
	-c print argument strings of a core file
	-X print no leading addresses or headers
	-m don't use archive(member) syntax
	-B force Thumb disassembly (ARM objects only)
	-q use llvm's disassembler (the default)
	-Q use otool(1)'s disassembler
	-mcpu=arg use `arg' as the cpu for disassembly
	-j print opcode bytes
	-P print the info plist section as strings
	-C print linker optimization hints
	--version print the version of /Library/Developer/CommandLineTools/usr/bin/otool
```
### 依赖的库查询：

在iOS开发中，通常我们Xcode工程的一个最终的Product是app格式，而如果你在Finder中点击“显示包内容”看看app里都有什么，你会看到里面的好多东西，有nib、plist、mobileprovision和各种图片资源等，而其中最重要的一个文件就是被标为“Unix可执行文件”(用file查看是Mach-O executable arm)类型的文件。我们的代码逻辑都在这里面。

比如我们需要分析 钉钉 这个应用所用到的一些系统库、支持的架构信息及版本号：(部分)

otool -L DingTalk
DingTalk (architecture armv7):

### 汇编码
其实，查看依赖系统库仅仅是其中的一小功能。otool命令配上不同的参数可以发挥很强大的功用。如果使用 otool -tV ex 则整个ARM的汇编码就都显示出来了。能看到ARM的汇编码，那接下来怎么用就看大家的了，想象空间无限啊:

otool -tV DingTalk
DingTalk (architecture armv7):


### 查看该应用是否砸壳
> 在App Store中下载的应用，都是经过苹果加密的文件，如果想分析应用的组成以及应用所包含的头文件和应用中的方法，必须把苹果加密的这层壳给砸掉。

```
otool -l DingTalk | grep -B 2 crypt
          cmd LC_ENCRYPTION_INFO
      cmdsize 20
     cryptoff 16384
    cryptsize 40239104
      cryptid 0
--
          cmd LC_ENCRYPTION_INFO_64
      cmdsize 24
     cryptoff 16384
    cryptsize 45400064
      cryptid 0
```
cryptid 0（砸壳） 1（未砸壳）

### Mach-O头结构等

其实otool文档本身的介绍就是：otool是对目标文件或者库文件的特定部分进行展示。这里举个例子，看一下其头部的内容是怎样的：

otool -h DingTalk
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
 0xfeedface      12          9  0x00           2    71       7148 0x00218085
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
 0xfeedfacf 16777228          0  0x00           2    71       7832 0x00218085
至于各字段的含义，可参看 loader.h


### OS X 支持三种运行时环境: 
1. dyld 运行时环境:基于 dyld库管理器的推荐环境. 
2. CFM 运行时环境: OS 9遗留环境. 实际用来设计需要使用 OS X新特色, 但还没完全移植到dyld的应用程序. 
3. The Classic环境: OS 9 (9.1 or 9.2) 程序无需修改直接在OS X运行. 

> 本文主要关注于Dyld 运行时环境. 
为了支持Dyld 运行时环境, 所有文件应该编译成Mach-O 可执行文件格式. 


## Mach-O
我们知道Windows下的文件都是PE文件，同样在OS X和iOS中可执行文件是Mach-o格式的。
Mach-O 是 Mach object 文件格式的缩写，它是一种用于记录可执行文件、对象代码、共享库、动态加载代码和内存转储的文件格式。作为 a.out 格式的替代品，Mach-O 提供了更好的扩展性，并提升了符号表中信息的访问速度。

大多数基于 Mach 内核的操作系统都使用 Mach-O。NeXTSTEP、OS X 和 iOS 是使用这种格式作为本地可执行文件、库和对象代码的例子。

我们用 Xcode 构建一个程序的过程中，会把源文件 (.m 和 .h) 文件转换为一个可执行文件。这个可执行文件中包含的字节码会将被 CPU (iOS 设备中的 ARM 处理器或 Mac 上的 Intel 处理器) 执行。

### Mach-O概述
Mach-O 可执行文件格式在 OS X, 几乎所有的包含可执行代码的文件，如：应用程序、框架、库、内核扩展……, 都是以Mach-O文件实现. Mach-O 是一种文件格式，也是一种描述可执行文件如何被内核加载并运行的ABI (应用程序二进制接口)
Mach-O 不是新事物. 最初由开放软件基金会 (OSF) 用于设计基于 Mach 微内核OSF/1 操作系统. 后来移植到 x86 系统OpenStep. 

专业一点讲, 它告诉系统: 

* 使用哪个动态库加载器 
* 加载哪个共享库. 
* 如何组织进程地址空间. 
* 函数入口点地址，等. 

### Mach-O 文件的组织
Mach-O 文件分为三个区域: 头部、载入命令区Section和原始段数据. 头部和载入命令区描述文件功能、布局和其他特性；原始段数据包含由载入命令引用的字节序列。为了研究和检查 Mach-O 文件的各部分, OS X 自带了一个很有用的程序otool，其位于/usr/bin目录下. 

接下来, 将使用 otool来了解 Mach-O 文件如何组织的.

#### 头部（header structure）
头部的结构如下：

```
/*
 * The 32-bit mach header appears at the very beginning of the object file for
 * 32-bit architectures.
 */
struct mach_header {
	uint32_t	magic;		       /* mach magic number identifier */
	cpu_type_t	cputype;	       /* cpu specifier */
	cpu_subtype_t	cpusubtype;	/* machine specifier */
	uint32_t	filetype;         /* type of file */
	uint32_t	ncmds;		       /* number of load commands */
	uint32_t	sizeofcmds;       /* the size of all the load commands */
	uint32_t	flags;		       /* flags */
};
```

> 查看文件的 Mach-O头部, 使用otool 命令的 -h参数 

```
evil:~ mohit$ otool -h /bin/ls 
/bin/ls: 
Mach header 
magic cputype cpusubtype filetype ncmds sizeofcmds flags 
0xfeedface 18 0 2 11 1608 0x00000085 
```

* 头部首先指定的是魔数（magic number）. 魔数标明文件是32位还是64位的Mach-O 文件. 也标明 CPU字节顺序. 魔数的解释,参看`/usr/include/mach-o/loader.h.` 
* 头部也指定文件的目标架构. 这样就允许内核确保该代码不会在不是为此处理器编写的CPU上运行。例如, 在上面的输出, cputype 设成18, 它代表CPU_TYPE_POWERPC, 在 `/usr/include/mach/machine.h`中定义. 
* 从上两项信息，我们推断出此二进制文件用于32-位基于PowerPC 的系统. 
* 有时二进制文件可能包含不止一个体系的代码。通常称为Universal Binaries, 通常以 fat_header这额外的头部开始。检查 fat_header内容, 使用otool命令的 -f开关参数. 
* cpusubtype 属性制定了CPU确切模型, 通常设成CPU_SUBTYPE_POWERPC_ALL 或 CPU_SUBTYPE_I386_ALL. 
* filetype 指出文件如何对齐如何使用。实际上它告诉你文件是库、静态可执行文件、core file等。上面的 filetype等于MH_EXECUTE,
* 接下来的两个属性涉及到载入命令区段, 指定了命令的数目和大小. 
* 最后, 获得了状态信息, 这些可能在装载和执行时被内核使用。 
* 载入命令载入命令区段包含一个告知内核如何载入文件中的各个原始段的命令列表。典型的描述如何对齐，保护每个段及各段在内存中的布局. 

#### 加载命令（load command）
> 查看文件中的载入命令列表, 使用otool 命令的 -l开关参数. 

```
evil:~/Temp mohit$ otool -l /bin/ls 
/bin/ls: 
Load command 0 
cmd LC_SEGMENT 
cmdsize 56 
segname __PAGEZERO 
vmaddr 0x00000000 
vmsize 0x00001000 
fileoff 0 
filesize 0 
maxprot 0x00000000 
initprot 0x00000000 
nsects 0 
flags 0x4 
Load command 1 
.......
.......
Load command 10
.......
```
上面的文件在头部下有11 加载命令直接定位, 从 0 到 10. 

* 前四个命令(LC_SEGMENT), 从 0 到 3, 定义了文件中的段如何映射到内存中去。段定义了Mach-O binary 二进制文件中的字节序列, 可以包含零个或更多的 sections. 稍候我们谈谈段。 
* Load command 4 (LC_LOAD_DYLINKER) 指定使用哪个动态链接器. 几乎总是设成OS X默认动态链接器 /usr/lib/dyld。 
* Commands 5 and 6 (LC_LOAD_DYLIB) 指定文件需要链接的共享库。它们由command 4规定的动态链接器载入。 
* Commands 7 and 8 (LC_SYMTAB, LC_DYNSYMTAB) 指定由文件和动态链接器分别使用的符号表. Command 9 (LC_TWOLEVEL_HINTS) 包含两级名称空间的hint table。最后, command 10 (LC_UNIXTHREAD), 定义进程主线程的初始状态. 该命令仅仅包含在可执行文件里。 

> Segments and Sections 

上面涉及到的大多数加载命令都引用了文件中的段. 段是Mach-O文件直接被内核和动态链接器映射到虚拟内存中的一系列字符序列. 头部和加载命令区域认为是文件的首段。一个典型的 OS X 可执行文件通常由下列五段：: 
__PAGEZERO : 定位于虚拟地址0，无任何保护权利。此段在文件中不占用空间，访问NULL导致立即崩溃. 
__TEXT : 包含只读数据和可执行代码. 
__DATA : 包含可写数据. 这些 section通常由内核标志为copy-on-write . 
__OBJC : 包含Objective C 语言运行时环境使用的数据。 
__LINKEDIT :包含动态链接器用的原始数据. 
__TEXT和 __DATA段可能包含0或更多的section. 每个section由指定类型的数据, 如, 可执行代码, 常量, C 字符串等组成. 

##### 接下来是Cmd的作用

Cmd	    |   作用
----------|------------
LC_SEGMENT/LC_SEGMENT_64 | 将对应的段中的数据加载并映射到进程的内存空间去
LC_SYMTAB	| 符号表信息
LC_DYSYMTAB	|   动态符号表信息
LC_LOAD_DYLINKER	|  启动动态加载连接器/usr/lib/dyld程序
LC_UUID	|   唯一的 UUID，标示该二进制文件，128bit
LC_VERSION_MIN_IPHONEOS/MACOSX	|    要求的最低系统版本（Xcode中的Deployment Target）
LC_MAIN	|   设置程序主线程的入口地址和栈大小
LC_ENCRYPTION_INFO	|    加密信息
LC_LOAD_DYLIB	| 加载的动态库，包括动态库地址、名称、版本号等
LC_FUNCTION_STARTS	|    函数地址起始表
LC_CODE_SIGNATURE   |  	代码签名信息

使用命令 otool -l 可执行文件 可以查看加载命令区，
grep cryptid 可以查看是否加密。

##### 补充：LC_DYSYMTAB符号表

LC_DYSYMTAB符号表有非常大的作用，捕获到线上 Crash 或者 卡顿 堆栈的地址信息时，需要进行符号还原，进而确认卡顿、崩溃的具体位置，这个使用就要使用到LC_DYSYMTAB符号表；

LC_DYSYMTAB符号表定义如下：

```
struct symtab_command {
    uint32_t    cmd;        /* LC_SYMTAB */
    uint32_t    cmdsize;    /* sizeof(struct symtab_command) */
    uint32_t    symoff;        /* symbol table offset */
    uint32_t    nsyms;        /* number of symbol table entries */
    uint32_t    stroff;        /* string table offset */
    uint32_t    strsize;    /* string table size in bytes */
};
```
符号表在 Mach-O目标文件中的地址可以通过LC_SYMTAB加载命令指定的 symoff找到，对应的符号名称在stroff，总共有nsyms条符号信息

根据 ` Frame Pointer 拿到函数调用的地址（address），然后用address` 、符号表、字符串表的对应关系找到对应的函数名，这就是符号解析的思路；


#### 段（segment）
> 查看某section内容, 使用otool命令 -s选项. 
> 可以拥有多个段（segment），每个段可以拥有零个或多个区域（section）。每一个段（segment）都拥有一段虚拟地址映射到进程的地址空间。

```
evil:~/Temp mohit$ otool -sv __TEXT __cstring /bin/ls 
/bin/ls: 
Contents of (__TEXT,__cstring) section 
00006320 00000000 5f5f6479 6c645f6d 6f645f74 
00006330 65726d5f 66756e63 73000000 5f5f6479 
00006340 6c645f6d 616b655f 64656c61 7965645f 
00006350 6d6f6475 6c655f69 6e697469 616c697a 
__SNIP__ 
```

> 反汇编__text section, 使用 the -tv 开关参数. 

```
evil:~/Temp mohit$ otool -tv /bin/ls 
/bin/ls: 
(__TEXT,__text) section 
00001ac4 or r26,r1,r1 
00001ac8 addi r1,r1,0xfffc 
00001acc rlwinm r1,r1,0,0,26 
00001ad0 li r0,0x0 
00001ad4 stw r0,0x0(r1) 
00001ad8 stwu r1,0xffc0(r1) 
00001adc lwz r3,0x0(r26) 
00001ae0 addi r4,r26,0x4 
__SNIP__ 
```

在 __TEXT段里, 存在四个主要的 section: 
__text : 编译后的机器码。 
__const : 通用常量数据. 
__cstring : 字面量字符串常量. 
__picsymbol_stub : 动态链接器使用的位置无关码stub 路由. 
这样保持了可执行的和不可执行的代码在段里的明显隔离. 

运行应用程序既然知道了Mach-O 文件的格式, 接下来看看OS X 如何载入并运行应用程序的。运行应用程序时, shell首先调用fork()系统调用. fork 创建调用进程(shell) 逻辑拷贝并准备好执行. 子进程然后调用execve()系统调用，当然需要提供要执行的程序路径. 

内核载入指定的文件, 检查其头部验证是否是合法的Mach-O 文件. 然后开始解释载入命令，将子进程地址空间替换成文件中的各段。同时,内核也执行有二进制文件指定的动态链接器, 着手加载、链接所有依赖库。在绑定了运行所必备的各个符号后，调用entry-point 函数. 

在build应用程序时entry-point 函数通常从/usr/lib/crt1.o静态链接（标准函数）. 此函数初始化内核环境，调用可执行文件的main()函数. 

#### 链接信息
动态链接器 
一个完整的用户级Mach-o文件的末端是链接信息。其中包含了动态加载器用来链接可执行文件或者依赖库所需使用的符号表，字符串表等等。

OS X 动态链接器/usr/lib/dyld, 负责加载依赖的共享库, 导入变量符号和函数，与当前进程的绑定。进程首次运行时, 链接器所做的就是把共享库导入到进程地址空间。取决于程序的build方式, 实际绑定也足执行不同的方式。 
载入后立即绑定—— load-time绑定. 
当符号引用时—— just-in-time绑定. 
预绑定 
如未指定绑定类型, 使用 just-in-time绑定. 

应用程序仅仅当所有需要的符号和段从不同的目标文件解决是才能继续运行。为了寻找库和框架, 标准动态链接器/usr/bin/dyld, 将搜索预定义的目录集合. 要修改目录, 或提供回滚路径, 可以设置DYLD_LIBRARY_PATH或DYLD_FALLBACK_LIBRARY_PATH环境变量

---------------

## Mack-O 可执行文件
> [英文链接：](https://www.objc.io/issues/6-build-tools/mach-o-executables/#arbitrary-sections)

我们用 Xcode 构建一个程序的过程中，会把源文件 (.m 和 .h) 文件转换为一个可执行文件。这个可执行文件中包含的字节码会将被 CPU (iOS 设备中的 ARM^[1] 处理器或 Mac 上的 Intel 处理器) 执行。

本文将介绍一下上面的过程中编译器都做了些什么，同时深入看看可执行文件内部是怎样的。实际上里面的东西要比我们第一眼看到的多得多。

这里我们把 Xcode 放一边，将使用命令行工具 (command-line tools)。当我们用 Xcode 构建一个程序时，Xcode 只是简单的调用了一系列的工具而已。Florian 对工具调用是如何工作的做了更详细的讨论。本文我们就直接调用这些工具，并看看它们都做了些什么。

真心希望本文能帮助你更好的理解 iOS 或 OS X 中的一个可执行文件 (也叫做 Mach-O executable) 是如何执行，以及怎样组装起来的。

### xcrun
先来看一些基础性的东西：这里会大量使用一个名为 xcrun 的命令行工具。看起来可能会有点奇怪，不过它非常的出色。这个小工具用来调用别的一些工具。原先，我们在终端执行如下命令：

`$ clang -v`
现在我们用下面的命令代替：

`$ xcrun clang -v`
在这里 xcrun 做的是定位到 clang，并执行它，附带输入 clang 后面的参数。

我们为什么要这样做呢？看起来没有什么意义。不过 xcode 允许我们: (1) 使用多个版本的 Xcode，以及使用某个特定 Xcode 版本中的工具。(2) 针对某个特定的 SDK (software development kit) 使用不同的工具。如果你有 Xcode 4.5 和 Xcode 5，通过 xcode-select 和 xcrun 可以选择使用 Xcode 5 中 iOS SDK 的工具，或者 Xcode 4.5 中的 OS X 工具。在许多其它平台中，这是不可能做到的。查阅 xcrun 和 xcode-select 的主页内容可以了解到详细内容。不用安装 Command Line Tools，就能使用命令行中的开发者工具。

### 不使用 IDE 的 Hello World
回到终端 (Terminal)，创建一个包含一个 C 文件的文件夹：
`% mkdir ~/Desktop/objcio-command-line
 % cd !$
 % touch helloworld.c`

接着使用你喜欢的文本编辑器来编辑这个文件 -- 例如 TextEdit.app：
`% open -e helloworld.c`

输入如下代码：

```
#include <stdio.h>
int main(int argc, char *argv[])
{
    printf("Hello World!\n");
    return 0;
}
```
保存并返回到终端，然后运行如下命令：

`% xcrun clang helloworld.c
 % ./a.out`
现在你能够在终端上看到熟悉的 Hello World!。这里我们编译并运行 C 程序，全程没有使用 IDE。

上面我们到底做了些什么呢？我们将 helloworld.c 编译为一个名为 a.out 的 Mach-O 二进制文件。注意，如果我们没有指定名字，那么编译器会默认的将其指定为 a.out。

这个二进制文件是如何生成的呢？实际上有许多内容需要观察和理解。我们先看看编译器吧。

#### Hello World 和编译器
时下 Xcode 中编译器默认选择使用 clang(读作 /klæŋ/)。关于编译器，Chris 写了更详细的文章。

简单的说，编译器处理过程中，将 helloworld.c 当做输入文件，并生成一个可执行文件 a.out。这个过程有多个步骤/阶段。我们需要做的就是正确的执行它们。

* **预处理**

    符号化 (Tokenization)
    宏定义的展开
    `#include` 的展开
* **语法和语义分析**

    将符号化后的内容转化为一棵解析树 (parse tree)
    解析树做语义分析
    输出一棵抽象语法树（Abstract Syntax Tree* (AST)）
* **生成代码和优化**

    将 AST 转换为更低级的中间码 (LLVM IR)
    对生成的中间码做优化
    生成特定目标代码
    输出汇编代码
* **汇编器**

    将汇编代码转换为目标对象文件。
* **链接器**
    将多个目标对象文件合并为一个可执行文件 (或者一个动态库)
    
    我们来看一个关于这些步骤的简单的例子。
    
    
##### 预处理

编译过程中，编译器首先要做的事情就是对文件做处理。预处理结束之后，如果我们停止编译过程，那么我们可以让编译器显示出预处理的一些内容：

`% xcrun clang -E helloworld.c`
喔喔。 上面的命令输出的内容有 413 行。我们用编辑器打开这些内容，看看到底发生了什么：

`% xcrun clang -E helloworld.c | open -f`
在顶部可以看到的许多行语句都是以 # 开头 (读作 hash)。这些被称为 行标记 的语句告诉我们后面跟着的内容来自哪里。如果再回头看看 helloworld.c 文件，会发现第一行是：

`#include <stdio.h>`
我们都用过 #include 和 import。它们所做的事情是告诉预处理器将文件 stdio.h 中的内容插入到 #include 语句所在的位置。这是一个递归的过程：stdio.h 可能会包含其它的文件。

由于这样的递归插入过程很多，所以我们需要确保记住相关行号信息。为了确保无误，预处理器在发生变更的地方插入以 # 开头的 行标记。跟在 # 后面的数字是在源文件中的行号，而最后的数字是在新文件中的行号。回到刚才打开的文件，紧跟着的是系统头文件，或者是被看做为封装了 extern "C" 代码块的文件。

如果滚动到文件末尾，可以看到我们的 helloworld.c 代码：

```
# 2 "helloworld.c" 2
int main(int argc, char *argv[])
{
 printf("Hello World!\n");
 return 0;
}
```
在 Xcode 中，可以通过这样的方式查看任意文件的预处理结果：Product -> Perform Action -> Preprocess。注意，编辑器加载预处理后的文件需要花费一些时间 -- 接近 100,000 行代码。

##### 编译
下一步：分析和代码生成。我们可以用下面的命令让 clang 输出汇编代码：

`% xcrun clang -S -o - helloworld.c | open -f`
我们来看看输出的结果。首先会看到有一些以点 . 开头的行。这些就是汇编指令。其它的则是实际的 x86_64 汇编代码。最后是一些标记 (label)，与 C 语言中的类似。

我们先看看前三行：

```
.section    __TEXT,__text,regular,pure_instructions
.globl  _main
.align  4, 0x90
```
这三行是汇编指令，不是汇编代码。.section 指令指定接下来会执行哪一个段。

第二行的 .globl 指令说明 _main 是一个外部符号。这就是我们的 main() 函数。这个函数对于二进制文件外部来说是可见的，因为系统要调用它来运行可执行文件。

.align 指令指出了后面代码的对齐方式。在我们的代码中，后面的代码会按照 16(2^4) 字节对齐，如果需要的话，用 0x90 补齐。

接下来是 main 函数的头部：

```
_main:                                  ## @main
    .cfi_startproc
## BB#0:
    pushq   %rbp
Ltmp2:
    .cfi_def_cfa_offset 16
Ltmp3:
    .cfi_offset %rbp, -16
    movq    %rsp, %rbp
Ltmp4:
    .cfi_def_cfa_register %rbp
    subq    $32, %rsp
```
上面的代码中有一些与 C 标记工作机制一样的一些标记。它们是某些特定部分的汇编代码的符号链接。首先是 _main 函数真正开始的地址。这个符号会被 export。二进制文件会有这个位置的一个引用。

.cfi_startproc 指令通常用于函数的开始处。CFI 是调用帧信息 (Call Frame Information) 的缩写。这个调用 帧 以松散的方式对应着一个函数。当开发者使用 debugger 和 step in 或 step out 时，实际上是 stepping in/out 一个调用帧。在 C 代码中，函数有自己的调用帧，当然，别的一些东西也会有类似的调用帧。.cfi_startproc 指令给了函数一个 .eh_frame 入口，这个入口包含了一些调用栈的信息（抛出异常时也是用其来展开调用帧堆栈的）。这个指令也会发送一些和具体平台相关的指令给 CFI。它与后面的.cfi_endproc 相匹配，以此标记出 main() 函数结束的地方。

接着是另外一个 label ## BB#0:。然后，终于，看到第一句汇编代码：pushq %rbp。从这里开始事情开始变得有趣。在 OS X上，我们会有 X86_64 的代码，对于这种架构，有一个东西叫做 ABI ( 应用二进制接口 application binary interface)，ABI 指定了函数调用是如何在汇编代码层面上工作的。在函数调用期间，ABI 会让 rbp 寄存器 (基础指针寄存器 base pointer register) 被保护起来。当函数调用返回时，确保 rbp 寄存器的值跟之前一样，这是属于 main 函数的职责。pushq %rbp 将 rbp 的值 push 到栈中，以便我们以后将其 pop 出来。

接下来是两个 CFI 指令：.cfi_def_cfa_offset 16 和 .cfi_offset %rbp, -16。这将会输出一些关于生成调用堆栈展开和调试的信息。我们改变了堆栈和基础指针，而这两个指令可以告诉编译器它们都在哪儿，或者更确切的，它们可以确保之后调试器要使用这些信息时，能找到对应的东西。

接下来，movq %rsp, %rbp 将把局部变量放置到栈上。subq $32, %rsp 将栈指针移动 32 个字节，也就是函数会调用的位置。我们先将老的栈指针存储到 rbp 中，然后将此作为我们局部变量的基址，接着我们更新堆栈指针到我们将会使用的位置。

之后，我们调用了 printf()：

```
leaq    L_.str(%rip), %rax
movl    $0, -4(%rbp)
movl    %edi, -8(%rbp)
movq    %rsi, -16(%rbp)
movq    %rax, %rdi
movb    $0, %al
callq   _printf
```
首先，leaq 会将 L_.str 的指针加载到 rax 寄存器中。留意 L_.str 标记在后面的汇编代码中是如何定义的。它就是 C 字符串"Hello World!\n"。 edi 和 rsi 寄存器保存了函数的第一个和第二个参数。由于我们会调用别的函数，所以首先需要将它们的当前值保存起来。这就是为什么我们使用刚刚存储的 rbp 偏移32个字节的原因。第一个 32 字节的值是 0，之后的 32 字节的值是 edi寄存器的值 (存储了 argc)。然后是 64 字节 的值：rsi 寄存器的值 (存储了 argv)。我们在后面并没有使用这些值，但是编译器在没有经过优化处理的时候，它们还是会被存下来。

现在我们把第一个函数 printf() 的参数 rax 设置给第一个函数参数寄存器 edi 中。printf() 是一个可变参数的函数。ABI 调用约定指定，将会把使用来存储参数的寄存器数量存储在寄存器 al 中。在这里是 0。最后 callq 调用了 printf() 函数。

```
 movl    $0, %ecx
 movl    %eax, -20(%rbp)         ## 4-byte Spill
 movl    %ecx, %eax
```
上面的代码将 ecx 寄存器设置为 0，并把 eax 寄存器的值保存至栈中，然后将 ect 中的 0 拷贝至 eax 中。ABI 规定 eax 将用来保存一个函数的返回值，或者此处 main() 函数的返回值 0：

```
    addq    $32, %rsp
    popq    %rbp
    ret
    .cfi_endproc
```
函数执行完成后，将恢复堆栈指针 —— 利用上面的指令 subq $32, %rsp 把堆栈指针 rsp 上移 32 字节。最后，把之前存储至 rbp中的值从栈中弹出来，然后调用 ret 返回调用者， ret 会读取出栈的返回地址。 .cfi_endproc 平衡了 .cfi_startproc 指令。

接下来是输出字符串 "Hello World!\n":

```
    .section    __TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
    .asciz   "Hello World!\n"
```
同样，.section 指令指出下面将要进入的段。L_.str 标记运行在实际的代码中获取到字符串的一个指针。.asciz 指令告诉编译器输出一个以 ‘\0’ (null) 结尾的字符串。

__TEXT __cstring 开启了一个新的段。这个段中包含了 C 字符串：

```
L_.str:                                 ## @.str
    .asciz     "Hello World!\n"
```
上面两行代码创建了一个 null 结尾的字符串。注意 L_.str 是如何命名，之后会通过它来访问字符串。

最后的 .subsections_via_symbols 指令是静态链接编辑器使用的。

更过关于汇编指令的资料可以在 苹果的 [OS X Assembler Reference](https://developer.apple.com/library/content/documentation/DeveloperTools/Reference/Assembler/000-Introduction/introduction.html) 中看到。AMD 64 网站有关于 ABI for x86 的文档。另外还有Gentle Introduction to x86-64 Assembly。

重申一下，通过下面的选择操作，我们可以用 Xcode 查看任意文件的汇编输出结果：Product -> Perform Action -> Assemble.

##### 汇编器
汇编器将可读的汇编代码转换为机器代码。它会创建一个目标对象文件，一般简称为 对象文件。这些文件以 .o 结尾。如果用 Xcode 构建应用程序，可以在工程的 derived data目录中,Objects-normal 文件夹下找到这些文件。可以使用otool工具查看。

Xcode缓存DerivedData [~/Library/Developer/Xcode/DerivedData/] 
> 如果你很久没有删除xcode的缓存文件，由于你每天要运行新的xcode文件，那么你的硬盘空间会越来越小，位于/Users/jssj/Library/Developer/Xcode/DerivedData下的缓存文件占了很大的内存空间，可以删除;
 
> 另外，查资料得到，Xcode无提示解决方案就可以删除/Users/用户名/Library/Developer/Xcode/DerivedData 路径下的缓存文件,重启xcode即可

> 很多用户发现Xcode 4中找不到Build目录以及编译出来的应用文件了，其实是Xcode 4做了修改，你可以在以下目录找到对应程序的文件
> /Users/用户名/Library/Developer/Xcode/DerivedData/产品名称-fylcrwghjxojxcgaejhixgwinhus/Build/Products/
> 在这个目录下就能找到了编译出来的app了

##### 链接器
稍后我们会对链接器做更详细的介绍。这里简单介绍一下：链接器解决了目标文件和库之间的链接。什么意思呢？还记得下面的语句吗：
`callq   _printf`
printf() 是 libc 库中的一个函数。无论怎样，最后的可执行文件需要能需要知道 printf() 在内存中的具体位置：例如，_printf的地址符号是什么。链接器会读取所有的目标文件 (此处只有一个) 和库 (此处是 libc)，并解决所有未知符号 (此处是 _printf) 的问题。然后将它们编码进最后的可执行文件中 （可以在 libc 中找到符号 _printf），接着链接器会输出可以运行的执行文件：a.out。

### Section
就像我们上面提到的一样，这里有些东西叫做 section。一个可执行文件包含多个段，也就是多个 section。可执行文件不同的部分将加载进不同的 section，并且每个 section 会转换进某个 segment 里。这个概念对于所有的可执行文件都是成立的。

我们来看看 a.out 二进制中的 section。我们可以使用 size 工具来观察：

```
% xcrun size -x -l -m a.out 
Segment __PAGEZERO: 0x100000000 (vmaddr 0x0 fileoff 0)
Segment __TEXT: 0x1000 (vmaddr 0x100000000 fileoff 0)
    Section __text: 0x37 (addr 0x100000f30 offset 3888)
    Section __stubs: 0x6 (addr 0x100000f68 offset 3944)
    Section __stub_helper: 0x1a (addr 0x100000f70 offset 3952)
    Section __cstring: 0xe (addr 0x100000f8a offset 3978)
    Section __unwind_info: 0x48 (addr 0x100000f98 offset 3992)
    Section __eh_frame: 0x18 (addr 0x100000fe0 offset 4064)
    total 0xc5
Segment __DATA: 0x1000 (vmaddr 0x100001000 fileoff 4096)
    Section __nl_symbol_ptr: 0x10 (addr 0x100001000 offset 4096)
    Section __la_symbol_ptr: 0x8 (addr 0x100001010 offset 4112)
    total 0x18
Segment __LINKEDIT: 0x1000 (vmaddr 0x100002000 fileoff 8192)
total 0x100003000
```
如上代码所示，我们的 a.out 文件有 4 个 segment。有些 segment 中有多个 section。

当运行一个可执行文件时，虚拟内存 (VM - virtual memory) 系统将 segment 映射到进程的地址空间上。映射完全不同于我们一般的认识，如果你对虚拟内存系统不熟悉，可以简单的想象虚拟内存系统将整个可执行文件加载进内存 -- 虽然在实际上不是这样的。VM 使用了一些技巧来避免全部加载。

当虚拟内存系统进行映射时，segment 和 section 会以不同的参数和权限被映射。

上面的代码中，__TEXT segment 包含了被执行的代码。它被以只读和可执行的方式映射。进程被允许执行这些代码，但是不能修改。这些代码也不能对自己做出修改，因此这些被映射的页从来不会被改变。

__DATA segment 以可读写和不可执行的方式映射。它包含了将会被更改的数据。

第一个 segment 是 __PAGEZERO。它的大小为 4GB。这 4GB 并不是文件的真实大小，但是规定了进程地址空间的前 4GB 被映射为 不可执行、不可写和不可读。这就是为什么当读写一个 NULL 指针或更小的值时会得到一个 EXC_BAD_ACCESS 错误。这是操作系统在尝试防止引起系统崩溃。

在 segment中，一般都会有多个 section。它们包含了可执行文件的不同部分。在 __TEXT segment 中，__text section 包含了编译所得到的机器码。__stubs 和 __stub_helper 是给动态链接器 (dyld) 使用的。通过这两个 section，在动态链接代码中，可以允许延迟链接。__const (在我们的代码中没有) 是常量，不可变的，就像 __cstring (包含了可执行文件中的字符串常量 -- 在源码中被双引号包含的字符串) 常量一样。

__DATA segment 中包含了可读写数据。在我们的程序中只有 __nl_symbol_ptr 和 __la_symbol_ptr，它们分别是 non-lazy 和lazy 符号指针。延迟符号指针用于可执行文件中调用未定义的函数，例如不包含在可执行文件中的函数，它们将会延迟加载。而针对非延迟符号指针，当可执行文件被加载同时，也会被加载。

在 _DATA segment 中的其它常见 section 包括 __const，在这里面会包含一些需要重定向的常量数据。例如 char * const p = "foo"; -- p 指针指向的数据是可变的。__bss section 没有被初始化的静态变量，例如 static int a; -- ANSI C 标准规定静态变量必须设置为 0。并且在运行时静态变量的值是可以修改的。__common section 包含未初始化的外部全局变量，跟 static 变量类似。例如在函数外面定义的 int a;。最后，__dyld 是一个 section 占位符，被用于动态链接器。

苹果的 [OS X Assembler Reference](https://developer.apple.com/library/content/documentation/DeveloperTools/Reference/Assembler/000-Introduction/introduction.html) 文档有更多关于 section 类型的介绍。

#### Section 中的内容
> 下面，我们用 otool(1) 来观察一个 section 中的内容：

```
% xcrun otool -s __TEXT __text a.out 
a.out:
(__TEXT,__text) section
0000000100000f30 55 48 89 e5 48 83 ec 20 48 8d 05 4b 00 00 00 c7 
0000000100000f40 45 fc 00 00 00 00 89 7d f8 48 89 75 f0 48 89 c7 
0000000100000f50 b0 00 e8 11 00 00 00 b9 00 00 00 00 89 45 ec 89 
0000000100000f60 c8 48 83 c4 20 5d c3 
```
上面是我们 app 中的代码。由于 -s __TEXT __text 很常见，otool 对其设置了一个缩写 -t 。我们还可以通过添加 -v 来查看反汇编代码：

```
% xcrun otool -v -t a.out
a.out:
(__TEXT,__text) section
_main:
0000000100000f30    pushq   %rbp
0000000100000f31    movq    %rsp, %rbp
0000000100000f34    subq    $0x20, %rsp
0000000100000f38    leaq    0x4b(%rip), %rax
0000000100000f3f    movl    $0x0, 0xfffffffffffffffc(%rbp)
0000000100000f46    movl    %edi, 0xfffffffffffffff8(%rbp)
0000000100000f49    movq    %rsi, 0xfffffffffffffff0(%rbp)
0000000100000f4d    movq    %rax, %rdi
0000000100000f50    movb    $0x0, %al
0000000100000f52    callq   0x100000f68
0000000100000f57    movl    $0x0, %ecx
0000000100000f5c    movl    %eax, 0xffffffffffffffec(%rbp)
0000000100000f5f    movl    %ecx, %eax
0000000100000f61    addq    $0x20, %rsp
0000000100000f65    popq    %rbp
0000000100000f66    ret
```
上面的内容是一样的，只不过以反汇编形式显示出来。你应该感觉很熟悉，这就是我们在前面编译时候的代码。唯一的不同就是，在这里我们没有任何的汇编指令在里面。这是纯粹的二进制执行文件。

同样的方法，我们可以查看别的 section：

```
% xcrun otool -v -s __TEXT __cstring a.out
a.out:
Contents of (__TEXT,__cstring) section
0x0000000100000f8a  Hello World!\n
//或:
% xcrun otool -v -s __TEXT __eh_frame a.out 
a.out:
Contents of (__TEXT,__eh_frame) section
0000000100000fe0    14 00 00 00 00 00 00 00 01 7a 52 00 01 78 10 01 
0000000100000ff0    10 0c 07 08 90 01 00 00
```
##### 性能上需要注意的事项
从侧面来讲，__DATA 和 __TEXT segment对性能会有所影响。如果你有一个很大的二进制文件，你可能得去看看苹果的文档：关于代码大小性能指南。将数据移至 __TEXT 是个不错的选择，因为这些页从来不会被改变。

##### 任意的片段
使用链接符号 -sectcreate 我们可以给可执行文件以 section 的方式添加任意的数据。这就是如何将一个 Info.plist 文件添加到一个独立的可执行文件中的方法。Info.plist 文件中的数据需要放入到 __TEXT segment 里面的一个 __info_plist section 中。可以将 -sectcreate segname sectname file 传递给链接器（通过将下面的内容传递给 clang）：

`-Wl,-sectcreate,__TEXT,__info_plist,path/to/Info.plist`
同样，-sectalign 规定了对其方式。如果你添加的是一个全新的 segment，那么需要通过 -segprot 来规定 segment 的保护方式 (读/写/可执行)。这些所有内容在链接器的帮助文档中都有，例如 ld(1)。

我们可以利用定义在 /usr/include/mach-o/getsect.h 中的函数 getsectdata() 得到 section，例如 getsectdata() 可以得到指向 section 数据的一个指针，并返回相关 section 的长度。

#### Mach-O
在 OS X 和 iOS 中可执行文件的格式为 Mach-O：

```
% file a.out 
a.out: Mach-O 64-bit executable x86_64
```
对于 GUI 程序也是一样的：

```
% file /Applications/Preview.app/Contents/MacOS/Preview 
/Applications/Preview.app/Contents/MacOS/Preview: Mach-O 64-bit executable x86_64
```
关于 Mach-O 文件格式 苹果有详细的介绍。

我们可以使用 otool(1) 来观察可执行文件的头部 -- 规定了这个文件是什么，以及文件是如何被加载的。通过 -h 可以打印出头信息：

```
% otool -v -h a.out           a.out:
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL LIB64     EXECUTE    16       1296   NOUNDEFS DYLDLINK TWOLEVEL PIE
```
cputype 和 cpusubtype 规定了这个可执行文件能够运行在哪些目标架构上。ncmds 和 sizeofcmds 是加载命令，可以通过 -l 来查看这两个加载命令：

```
% otool -v -l a.out | open -f
a.out:
Load command 0
      cmd LC_SEGMENT_64
  cmdsize 72
  segname __PAGEZERO
   vmaddr 0x0000000000000000
   vmsize 0x0000000100000000
...
```
加载命令规定了文件的逻辑结构和文件在虚拟内存中的布局。otool 打印出的大多数信息都是源自这里的加载命令。看一下 Load command 1 部分，可以找到 initprot r-x，它规定了之前提到的保护方式：只读和可执行。

对于每一个 segment，以及segment 中的每个 section，加载命令规定了它们在内存中结束的位置，以及保护模式等。例如，下面是 __TEXT __text section 的输出内容：

```
Section
  sectname __text
   segname __TEXT
      addr 0x0000000100000f30
      size 0x0000000000000037
    offset 3888
     align 2^4 (16)
    reloff 0
    nreloc 0
      type S_REGULAR
attributes PURE_INSTRUCTIONS SOME_INSTRUCTIONS
 reserved1 0
 reserved2 0
```
上面的代码将在 0x100000f30 处结束。它在文件中的偏移量为 3888。如果看一下之前 xcrun otool -v -t a.out 输出的反汇编代码，可以发现代码实际位置在 0x100000f30。

我们同样看看在可执行文件中，动态链接库是如何使用的：

```
% otool -v -L a.out
a.out:
    /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 169.3.0)
    time stamp 2 Thu Jan  1 01:00:02 1970
```
上面就是我们可执行文件将要找到 _printf 符号的地方。

### 一个更复杂的例子

```
bogon:astcheck lxw$ vim Foo.h
bogon:astcheck lxw$ ls
Foo.h		a.out		helloworld.c	test.c		test.dSYM
bogon:astcheck lxw$ vim Foo.m
bogon:astcheck lxw$ ls
Foo.h		a.out		test.c
Foo.m		helloworld.c	test.dSYM
bogon:astcheck lxw$ vim helloworld.c 
bogon:astcheck lxw$ vim helloworld.m
bogon:astcheck lxw$ ls
Foo.h		a.out		helloworld.m	test.dSYM
Foo.m		helloworld.c	test.c
bogon:astcheck lxw$ xcrun clang -c Foo.m
bogon:astcheck lxw$ xcrun clang -c helloworld.m
bogon:astcheck lxw$ file helloworld.o Foo.o
helloworld.o: Mach-O 64-bit object x86_64
Foo.o:        Mach-O 64-bit object x86_64
bogon:astcheck lxw$ xcrun clang helloworld.o Foo.o -Wl,`xcrun --show-sdk-path`/System/Library/Frameworks/Foundation.framework/Foundation
bogon:astcheck lxw$ ./a.out 
2018-04-17 16:24:42.941 a.out[38074:3543439] lxw
bogon:astcheck lxw$ 
```
我们来看看有三个文件的复杂例子：

> Foo.h:

```
#import <Foundation/Foundation.h>

@interface Foo : NSObject

- (void)run;

@end
```

> Foo.m:

```
#import "Foo.h"

@implementation Foo

- (void)run
{
    NSLog(@"%@", NSFullUserName());
}

@end
```

> helloworld.m:

```
#import "Foo.h"
int main(int argc, char *argv[])
{
    @autoreleasepool {
        Foo *foo = [[Foo alloc] init];
        [foo run];
        return 0;
    }
}
```
#### 编译多个文件
在上面的示例中，有多个源文件。所以我们需要让 clang 对输入每个文件生成对应的目标文件：

`% xcrun clang -c Foo.m
 % xcrun clang -c helloworld.m`
我们从来不编译头文件。头文件的作用就是在被编译的实现文件中对代码做简单的共享。Foo.m 和 helloworld.m 都是通过 #import 语句将 Foo.h 文件中的内容添加到实现文件中的。

最终得到了两个目标文件：

`% file helloworld.o Foo.o
 helloworld.o: Mach-O 64-bit object x86_64
 Foo.o:        Mach-O 64-bit object x86_64`
为了生成一个可执行文件，我们需要将这两个目标文件和 Foundation framework 链接起来：

`xcrun clang helloworld.o Foo.o -Wl,`xcrun --show-sdk-path`/System/Library/Frameworks/Foundation.framework/Foundation`
现在可以运行我们的程序了:

`% ./a.out 
 2013-11-03 18:03:03.386 a.out[8302:303] Daniel Eggert`

#### 符号表和链接
我们这个简单的程序是将两个目标文件合并到一起的。Foo.o 目标文件包含了 Foo 类的实现，而 helloworld.o 目标文件包含了 main() 函数，以及调用/使用 Foo 类。

另外，这两个目标对象都使用了 Foundation framework。helloworld.o 目标文件使用了它的 autorelease pool，并间接的使用了 libobjc.dylib 中的 Objective-C 运行时。它需要运行时函数来进行消息的调用。Foo.o 目标文件也有类似的原理。

所有的这些东西都被形象的称之为符号。我们可以把符号看成是一些在运行时将会变成指针的东西。虽然实际上并不是这样的。

每个函数、全局变量和类等都是通过符号的形式来定义和使用的。当我们将目标文件链接为一个可执行文件时，链接器 (ld(1)) 在目标文件盒动态库之间对符号做了解析处理。

可执行文件和目标文件有一个符号表，这个符号表规定了它们的符号。如果我们用 nm(1) 工具观察一下 helloworld.0 目标文件，可以看到如下内容：

```
% xcrun nm -nm helloworld.o
                 (undefined) external _OBJC_CLASS_$_Foo
0000000000000000 (__TEXT,__text) external _main
                 (undefined) external _objc_autoreleasePoolPop
                 (undefined) external _objc_autoreleasePoolPush
                 (undefined) external _objc_msgSend
                 (undefined) external _objc_msgSend_fixup
0000000000000088 (__TEXT,__objc_methname) non-external L_OBJC_METH_VAR_NAME_
000000000000008e (__TEXT,__objc_methname) non-external L_OBJC_METH_VAR_NAME_1
0000000000000093 (__TEXT,__objc_methname) non-external L_OBJC_METH_VAR_NAME_2
00000000000000a0 (__DATA,__objc_msgrefs) weak private external l_objc_msgSend_fixup_alloc
00000000000000e8 (__TEXT,__eh_frame) non-external EH_frame0
0000000000000100 (__TEXT,__eh_frame) external _main.eh
```
上面就是那个目标文件的所有符号。_OBJC_CLASS_$_Foo 是 Foo Objective-C 类的符号。该符号是 undefined, external 。External 的意思是指对于这个目标文件该类并不是私有的，相反，non-external 的符号则表示对于目标文件是私有的。我们的 helloworld.o 目标文件引用了类 Foo，不过这并没有实现它。因此符号表中将其标示为 undefined。

接下来是 _main 符号，它是表示 main() 函数，同样为 external，这是因为该函数需要被调用，所以应该为可见的。由于在 helloworld.o 文件中实现了 这个 main 函数。这个函数地址位于 0处，并且需要转入到 __TEXT,__text section。接着是 4 个 Objective-C 运行时函数。它们同样是 undefined的，需要链接器进行符号解析。

如果我们转而观察 Foo.o 目标文件，可以看到如下输出：

```
% xcrun nm -nm Foo.o
0000000000000000 (__TEXT,__text) non-external -[Foo run]
                 (undefined) external _NSFullUserName
                 (undefined) external _NSLog
                 (undefined) external _OBJC_CLASS_$_NSObject
                 (undefined) external _OBJC_METACLASS_$_NSObject
                 (undefined) external ___CFConstantStringClassReference
                 (undefined) external __objc_empty_cache
                 (undefined) external __objc_empty_vtable
000000000000002f (__TEXT,__cstring) non-external l_.str
0000000000000060 (__TEXT,__objc_classname) non-external L_OBJC_CLASS_NAME_
0000000000000068 (__DATA,__objc_const) non-external l_OBJC_METACLASS_RO_$_Foo
00000000000000b0 (__DATA,__objc_const) non-external l_OBJC_$_INSTANCE_METHODS_Foo
00000000000000d0 (__DATA,__objc_const) non-external l_OBJC_CLASS_RO_$_Foo
0000000000000118 (__DATA,__objc_data) external _OBJC_METACLASS_$_Foo
0000000000000140 (__DATA,__objc_data) external _OBJC_CLASS_$_Foo
0000000000000168 (__TEXT,__objc_methname) non-external L_OBJC_METH_VAR_NAME_
000000000000016c (__TEXT,__objc_methtype) non-external L_OBJC_METH_VAR_TYPE_
00000000000001a8 (__TEXT,__eh_frame) non-external EH_frame0
00000000000001c0 (__TEXT,__eh_frame) non-external -[Foo run].eh
```
第五行至最后一行显示了 _OBJC_CLASS_$_Foo 已经定义了，并且对于 Foo.o 是一个外部符号 -- ·Foo.o· 包含了这个类的实现。

Foo.o 同样有 undefined 的符号。首先是使用了符号 NSFullUserName()，NSLog()和 NSObject。

当我们将这两个目标文件和 Foundation framework (是一个动态库) 进行链接处理时，链接器会尝试解析所有的 undefined 符号。它可以解析 _OBJC_CLASS_$_Foo。另外，它将使用 Foundation framework。

当链接器通过动态库 (此处是 Foundation framework) 解析成功一个符号时，它会在最终的链接图中记录这个符号是通过动态库进行解析的。链接器会记录输出文件是依赖于哪个动态链接库，并连同其路径一起进行记录。在我们的例子中，_NSFullUserName，_NSLog，_OBJC_CLASS_$_NSObject，_objc_autoreleasePoolPop 等符号都是遵循这个过程。

我们可以看一下最终可执行文件 a.out 的符号表，并注意观察链接器是如何解析所有符号的：

```
% xcrun nm -nm a.out 
                 (undefined) external _NSFullUserName (from Foundation)
                 (undefined) external _NSLog (from Foundation)
                 (undefined) external _OBJC_CLASS_$_NSObject (from CoreFoundation)
                 (undefined) external _OBJC_METACLASS_$_NSObject (from CoreFoundation)
                 (undefined) external ___CFConstantStringClassReference (from CoreFoundation)
                 (undefined) external __objc_empty_cache (from libobjc)
                 (undefined) external __objc_empty_vtable (from libobjc)
                 (undefined) external _objc_autoreleasePoolPop (from libobjc)
                 (undefined) external _objc_autoreleasePoolPush (from libobjc)
                 (undefined) external _objc_msgSend (from libobjc)
                 (undefined) external _objc_msgSend_fixup (from libobjc)
                 (undefined) external dyld_stub_binder (from libSystem)
0000000100000000 (__TEXT,__text) [referenced dynamically] external __mh_execute_header
0000000100000e50 (__TEXT,__text) external _main
0000000100000ed0 (__TEXT,__text) non-external -[Foo run]
0000000100001128 (__DATA,__objc_data) external _OBJC_METACLASS_$_Foo
0000000100001150 (__DATA,__objc_data) external _OBJC_CLASS_$_Foo
```
可以看到所有的 Foundation 和 Objective-C 运行时符号依旧是 undefined，不过现在的符号表中已经多了如何解析它们的信息，例如在哪个动态库中可以找到对应的符号。

可执行文件同样知道去哪里找到所需库：

```
% xcrun otool -L a.out
a.out:
    /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation (compatibility version 300.0.0, current version 1056.0.0)
    /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1197.1.1)
    /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 855.11.0)
    /usr/lib/libobjc.A.dylib (compatibility version 1.0.0, current version 228.0.0)
```
在运行时，动态链接器 dyld(1) 可以解析这些 undefined 符号，dyld 将会确定好 _NSFullUserName 等符号，并指向它们在 Foundation 中的实现等。

我们可以针对 Foundation 运行 nm(1)，并检查这些符号的定义情况：

```
% xcrun nm -nm `xcrun --show-sdk-path`/System/Library/Frameworks/Foundation.framework/Foundation | grep NSFullUserName
0000000000007f3e (__TEXT,__text) external _NSFullUserName 
```

#### 动态链接编辑器
有一些环境变量对于 dyld 的输出信息非常有用。首先，如果设置了 DYLD_PRINT_LIBRARIES，那么 dyld 将会打印出什么库被加载了：

% (export DYLD_PRINT_LIBRARIES=; ./a.out )
dyld: loaded: /Users/deggert/Desktop/command_line/./a.out
dyld: loaded: /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
dyld: loaded: /usr/lib/libSystem.B.dylib
dyld: loaded: /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
dyld: loaded: /usr/lib/libobjc.A.dylib
dyld: loaded: /usr/lib/libauto.dylib
[...]
上面将会显示出在加载 Foundation 时，同时会加载的 70 个动态库。这是由于 Foundation 依赖于另外一些动态库。运行下面的命令：

% xcrun otool -L `xcrun --show-sdk-path`/System/Library/Frameworks/Foundation.framework/Foundation
可以看到 Foundation 使用了 15 个动态库。

#### dyld 的共享缓存
当你构建一个真正的程序时，将会链接各种各样的库。它们又会依赖其他一些 framework 和 动态库。需要加载的动态库会非常多。而对于相互依赖的符号就更多了。可能将会有上千个符号需要解析处理，这将花费很长的时间：一般是好几秒钟。

为了缩短这个处理过程所花费时间，在 OS X 和 iOS 上的动态链接器使用了共享缓存，共享缓存存于 /var/db/dyld/。对于每一种架构，操作系统都有一个单独的文件，文件中包含了绝大多数的动态库，这些库都已经链接为一个文件，并且已经处理好了它们之间的符号关系。当加载一个 Mach-O 文件 (一个可执行文件或者一个库) 时，动态链接器首先会检查 共享缓存 看看是否存在其中，如果存在，那么就直接从共享缓存中拿出来使用。每一个进程都把这个共享缓存映射到了自己的地址空间中。这个方法大大优化了 OS X 和 iOS 上程序的启动时间。


## 参考文档
##### [1. otool-detail](http://blog.163.com/zhangshouyin_good/blog/static/137179437201741322221684/)
##### [2. otool-ex](https://www.jianshu.com/p/fc67f95eee41)
##### [3. Linux Tools Quick Tutorial](http://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/ldd.html)
##### [4. 浅谈ldd命令](https://blog.csdn.net/tenfyguo/article/details/5605120)
##### [otool 命令_otool瘦身_linux命令与shell命令](http://www.pc-fly.com/a/tongxinshuyu/article-42614-1.html)
##### [iOS安全–了解Mach-o文件结构](http://www.blogfshare.com/ioss-mach-o.html)
##### [Mach-O 可执行文件](https://objccn.io/issue-6-3/)
##### [Mach-O 学习](https://elliotsomething.github.io/2017/06/01/Mach-O%E5%AD%A6%E4%B9%A0/)
##### [iOS 安装包瘦身指南](http://www.zoomfeng.com/blog/ipa-size-thin.html)

## 专业词解释
* [1]ARM：
    ARM处理器是英国Acorn有限公司设计的低功耗成本的第一款RISC微处理器.(Advanced RISC Machine)
    RISC的英文全称是Reduced Instruction Set Computer，中文是精简指令集计算机
* [2]IDE:
    Integrated Development Environment
* [3]Mach-O: 
    Mach Object文件格式缩写


