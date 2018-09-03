## [Optimizing App Startup Time](https://developer.apple.com/videos/play/wwdc2016/406)

### Theory

• Everything that happens before main()

• Mach-O format

• Virtual Memory basics

• How Mach-O binaries are loaded and prepared

### Practical

• How to measure

• Optimizing start up time


### Mach-O Terminology
#### File Types:

• **Executable** — Main binary for application

• **Dylib** — Dynamic library (aka DSO or DLL)

• **Bundle** — Dylib that cannot be linked, only dlopen(), e.g. plug-ins 
**Image** — An executable, dylib, or bundle 
**Framework** — Dylib with directory for resources and headers

### Mach-O Image File
File divided into segments

• Uppercase names 

All segments are multiples of page size

• 16KB on arm64

• 4KB elsewhere


Sections are a subrange of a segment

• Lowercase names Common segments:

• __TEXT has header, code, and   read-only constants

• __DATA has all read-write content:   globals, static variables, etc

• __LINKEDIT has "meta data” about   how to load the program
 
### Mach-O Universal Files
Fat Header

• One page in size

• Lists architectures and oﬀsets 

Tools and runtimes support fat mach-o ﬁles

### Virtual Memory
Virtual Memory is a level of indirection 

Maps per-process addresses to physical RAM (page granularity) 

Features:

• Page fault

• Same RAM page appears in multiple processes

• File backed pages
 — mmap()
 — lazy reading

• Copy-On-Write (COW)

• Dirty vs. clean pages

• Permissions: rwx

### Mach-O Image Loading


### Security

ASLR

• Address Space Layout Randomization

• Images load at random address Code Signing

• Content of each page is hashed

• Hash is veriﬁed on page-in


### exec() to main()

#### exec()


Kernel maps your application into   
new address space 

Start of your app is random 

Low memory is marked inaccessible

• 4KB+ for 32-bit process

• 4GB+ for 64-bit processes

• Catches NULL pointer usage

• Catches pointer truncation errors


#### What About Dylibs?

Kernel loads helper program

• Dyld (dynamic loader)

• Executions starts in dyld 

Dyld runs in-process

• Loads dependent dylibs

• Has same permissions as app


#### Dyld Steps

Map all dependent dylibs, recurse 

Rebase all images 

Bind all images 

ObjC prepare images 

Run initializers

**[Load] >> [dylibs] >> [Rebase] >> [Bind] >> [ObjC] >> [Initializers]**

#### Loading Dylibs

Parse list of dependent dylibs 

Find requested mach-o ﬁle 

Open and read start of ﬁle 

Validate mach-o 

Register code signature 

Call mmap() for each segment

#### Recursive Loading
All your app's direct dependents are loaded 

Plus any dylib's needed by those dylibs 

Rinse and repeat 

Apps typically load 100 to 400 dylibs!

• Most are OS dylibs

• We’ve optimized loading of OS dylibs

#### Fix-ups

Code signing means instructions cannot be altered 

Modern code-gen is dynamic PIC (Position Independent Code)

• Code can run loaded at any address and is never altered

• Instead, all ﬁx ups are in __DATA


#### Rebasing and Binding

Rebasing: Adjusting pointers to within an image 

Binding: Setting pointers to outside image

#### Rebasing

Rebasing is adding a "slide" value to each internal pointer 

Slide = actual_address - preferred_address 

Location of rebase locations is encoded in LINKEDIT 

Pages-in and COW page

Rebasing is done in address order, so kernel starts prefetching


#### Binding

All references to something in another dylib are symbolic 

Dyld needs to ﬁnd symbol name 

More computational than rebasing 

Rarely page faults

#### Notify ObjC Runtime

Most ObjC set up done via rebasing and binding 

All ObjC class deﬁnitions are registered 

Non-fragile ivars oﬀsets updated 

Categories are inserted into method lists 

Selectors are uniqued

#### Initializers

C++ generates initializer for statically allocated objects 

ObjC +load methods 

Run "bottom up" so each initializer can call dylibs below it 

Lastly, Dyld calls main() in executable

#### Pre-main() Summary

Dyld is a helper program

• Loads all dependent dylibs

• Fixes up all pointers in DATA pages

• Runs all initializers


### Putting Theory into Practice

#### Improving Launch Times
> Goals

Launch faster than animation

• Duration varies on devices

• 400ms is a good target 

Don’t ever take longer than 20 seconds

• App will be killed Test on the slowest supported device


> Launch recap

Parse images 

Map images 

Rebase images 

Bind images 

Run image initializers 

Call main()

Call UIApplicationMain() 

Call applicationWillFinishLaunching


> Warm vs. cold launch

Warm launch

• App and data already in memory 

Cold launch

• App is not in kernel buﬀer cache 

Warm and cold launch times will be diﬀerent

• Cold launch times are important

• Measure cold launch by rebooting


> Measurements

Measuring before main() is diﬃcult 

Dyld has built in measurements 

• DYLD_PRINT_STATISTICS environment variable

- Available on shipping OSes 

- Signiﬁcantly enhanced in new OSes 

- Available in seed 2

Debugger pauses every dylib load

• Dyld subtracts out debugger time

• Console times less than wall clock


#### Dylib Loading

Embedded dylibs are expensive 

Use fewer dylibs

• Merge existing dylibs

• Use static archives 

Lazy load, but…

• dlopen() can cause issues ertwert

• Actually more work overall

#### Rebase/Binding

Reduce __DATA pointers 

Reduce Objective C metadata

• Classes, selectors, and categories 

Reduce C++ virtual 

Use Swift structs 

Examine machine generated code

• Use oﬀsets instead of pointers

• Mark read only


#### ObjC Setup

Class registration 

Non-fragile ivars oﬀsets updated 

Category registration 

Selector uniquing


#### Initializers

> Explicit

ObjC +load methods sdfgsd 

• Replace with +initiailize sdfgsdfg

C/C++ __attribute__((constructor))

Replace with call site initializers

• dispatch_once()

• pthread_once()

• std::once()


> Implicit

C++ statics with non-trivial constructors

• Replace with call site initializers

• Only set simple values (PODs)

• -Wglobal-constructors

• Rewrite in Swift 

Do not call dlopen() in initializers 168121ASDF

Do not create threads in initializers



### TL;DR

Measure launch times with DYLD_PRINT_STATISTICS 

Reduce launch times by

• Embedding fewer dylibs

• Consolidating Objective-C classes

• Eliminating static initializers 

Use more Swift 

dlopen() is discouraged

• Subtle performance and deadlock issues

