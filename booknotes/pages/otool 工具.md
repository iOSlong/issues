## otool 工具
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
### 1. 依赖的库查询：

在iOS开发中，通常我们Xcode工程的一个最终的Product是app格式，而如果你在Finder中点击“显示包内容”看看app里都有什么，你会看到里面的好多东西，有nib、plist、mobileprovision和各种图片资源等，而其中最重要的一个文件就是被标为“Unix可执行文件”(用file查看是Mach-O executable arm)类型的文件。我们的代码逻辑都在这里面。

比如我们需要分析 钉钉 这个应用所用到的一些系统库、支持的架构信息及版本号：(部分)

otool -L DingTalk
DingTalk (architecture armv7):

### 2. 汇编码
其实，查看依赖系统库仅仅是其中的一小功能。otool命令配上不同的参数可以发挥很强大的功用。如果使用 otool -tV ex 则整个ARM的汇编码就都显示出来了。能看到ARM的汇编码，那接下来怎么用就看大家的了，想象空间无限啊:

otool -tV DingTalk
DingTalk (architecture armv7):


### 3. 查看该应用是否砸壳
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

### 4. Mach-O头结构等

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

#### 段（segment）
> 查看某section内容, 使用otool命令 -s选项. 

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

OS X 动态链接器/usr/lib/dyld, 负责加载依赖的共享库, 导入变量符号和函数，与当前进程的绑定。进程首次运行时, 链接器所做的就是把共享库导入到进程地址空间。取决于程序的build方式, 实际绑定也足执行不同的方式。 
载入后立即绑定—— load-time绑定. 
当符号引用时—— just-in-time绑定. 
预绑定 
如未指定绑定类型, 使用 just-in-time绑定. 

应用程序仅仅当所有需要的符号和段从不同的目标文件解决是才能继续运行。为了寻找库和框架, 标准动态链接器/usr/bin/dyld, 将搜索预定义的目录集合. 要修改目录, 或提供回滚路径, 可以设置DYLD_LIBRARY_PATH或DYLD_FALLBACK_LIBRARY_PATH环境变量


