### LaunchTime：
> 启动有冷启动与热启动，此处只针对冷启动。因为热启动时候应用已经在内存中处于就绪状态，随时可运行，不做讨论。

#### 1. Pre-main
> 所有发生在**main()**之前的过程
> 文件加载相关：‘ref-001’
> 加载解析所有可执行文件，自身App的所有.o文件集合(所有类文件会被编译为.o)，
> 动态链接库执行加载，运行所有的初始化方法。


##### 核心方向
###### Do less!

* Embed fewer dylibs
* Declare fewer classes/methods
* Use fewer initializers

###### Use more Swift

* No initializers
* Swift size improvements

###### Static initializer tracing 【Instruments ->device -> application】

New in iOS 11 and macOS High Sierra
Provides precise timing for each static initializer
Available through Instruments

* Initializer Calls
* CPU Usage(Time Profiler)


##### 优化点：

###### 1. Dylib Loading
###### 2. Rebase/Binding
###### 3. ObjC Setup 
###### 4. Initializers
###### 5. Measure launch times with DYLD_PRINT_STATISTICS

• Embedding fewer dylibs
• Consolidating Objective-C classes
• Eliminating static initializers


##### TODO:
* 遍历工程，（工具及人工查漏）清除所有冗余文件(类、图片)，库。
* [使用 +initialize 来替代 +load](https://stackoverflow.com/questions/13326435/nsobject-load-and-initialize-what-do-they-do)
* [load VS initialize](https://blog.csdn.net/u013378438/article/details/52060925)

##### 可以删除类文件
###### 1. [fui tool  check project and delete rubish files](https://github.com/dblock/fui)：



###### 2. [iOS项目冗余资源扫描脚本](https://www.cnblogs.com/Boohee/p/5598313.html)：

```#!/bin/sh

##### several cases that the scripts does not work:
##### 1) there is space or slash in the resources file, such as "aaa .png" 资源文件名中含有空格或者/
##### 2) reference resources in commented code 资源引用代码被注释了
##### 3) you need to manually checked the resources one by one in the result 对于脚本检查结果，最好人工检查一遍
##### 4) you can add some other types more than png, jpg, gif, wav, m4a 如果需要检查其他资源，请自行修改脚本；
##### 5)默认文件后缀都是如@2x.png格式，如果后缀格式不同，请自行修改脚本；

#### set parameters：PrjPath为项目工程所在目录，包含.m .xib文件；ResPath为被扫描的资源文件目录，包含.png .wav
#### xcodeprojPath为工程xcodeproj位置
PrjPath=/Users/lxw/Desktop/ntc/repositories/ysdq/Le123PhoneClient
ResPath=/Users/lxw/Desktop/ntc/repositories/ysdq/Le123PhoneClient
xcodeprojPath=/Users/lxw/Desktop/ntc/repositories/ysdq/Le123PhoneClient.xcodeproj

if [ -f ~/Desktop/resource_san_result.txt ];then
rm -f ~/Desktop/resource_san_result.txt
fi

cd $PrjPath
files=$(find . -name "*.m" -o -name "*.xib" -o -name "*.mm" -o -name "*.plist")

cd $ResPath
for png in $(find . -name "*.png" -o -name "*.jpg" -o -name "*.gif" -o -name "*.wav" -o -name "*.m4a")
do

basename='basename/'$png
basename=${basename##*/}
# echo $basename

if [ "${basename##*.}" == "png" ];then

echo $basename|grep -q @2x.png

if [ $? -eq 0 ];then
name=${basename%%@2x.png}
else
echo $basename|grep -q @3x.png
if [ $? -eq 0 ];then
name=${basename%%@3x.png}
else
name=${basename%.png}
fi
fi

elif [ "${basename##*.}" == "jpg" ];then
echo $basename|grep -q @2x.jpg
if [ $? -eq 0 ];then
name=${basename%%@2x.jpg}
else
echo $basename|grep -q @3x.jpg
if [ $? -eq 0 ];then
name=${basename%%@3x.jpg}
else
name=${basename%%.jpg}
fi
fi

elif [ "${basename##*.}" == "gif" ];then
echo $basename|grep -q @2x.gif
if [ $? -eq 0 ];then
name=${basename%%@2x.gif}
else
echo $basename|grep -q @3x.gif
if [ $? -eq 0 ];then
name=${basename%%@3x.gif}
else
name=${basename%%.gif}
fi
fi

elif [ "${basename##*.}" == "wav" ];then
name=${basename%%.wav}

elif [ "${basename##*.}" == "m4a" ]; then
name=${basename%%.m4a}

else
name=''
fi


if [ ${#name} -gt 0 ];then
# # name=${name%%[0-9]*}

cd $PrjPath
if grep -q $name $files;then
echo "$png" is used

else
cd $xcodeprojPath
if grep -q $name project.pbxproj;then
echo "$png" is not used >> ~/Desktop/resource_san_result.txt
else
echo "$png" is not packaged
fi
fi
else
echo name is empty
fi

done


if [ -f ~/Desktop/resource_san_result.txt ]; then
echo ***************the end of scan. Please see result from resource_san_result.txt
else
echo ***************the end of scan, everything is OK
fi
```

> 扫描结果输出很多，局部截图如下，可以根据结果进行确认，并将确认的无用资源文件从工程中进行删除：




###### 3. 工具探查遗漏冗余文件，这部分只能发现（开发过程，review过程中）一个移除一个：

1. import "NSDictionary+FakeBundleIdentifier.h"
2. import "DQTencentPlayerView.h"
3. import "LeXiuTanService.h
4. import "SupportCollectionViewModel.h"




##### 库文件，开发模式补充说明
###### 工程中并无使用，建议移除
1. pod FSMachine   
2. pod 'libextobjc/EXTKeyPathCoding'  
3. pod 'HTHorizontalSelectionList'
4. pod 'NJKWebViewProgress' 
5. pod 'StyledPageControl'


###### Debug环境下引入的库可以再release版本中进行移除,记得刷新
1.  pod 'FBMemoryProfiler', :configurations => ['Debug']
2.  pod 'LumberjackConsole', :configurations => ['Debug']

###### 待验证或可替代三方库
1. 确定可以替代移除库
    pod 'UIColor-Utilities'  (colorWithHexString 可当度添加接口)
    pod 'NSString-Hashes'   （接口合并到Ninty库中）
    pod 'OpenUDID'          （接口合并到Ninty库中）         

2. 待进一步确认：
    pod 'libextobjc/EXTScope' 
    pod 'libextobjc/EXTKeyPathCoding'
     [研究参考](https://www.aliyun.com/jiaocheng/353328.html) 
    
    pod 'CocoaLumberjack'
     [研究参考](https://www.jianshu.com/p/107c3ba8e325)


##### 预期效果
1. 减少启动pre-main() 耗时。
2. 减小工程包大小。



#### 2. didFinishLaunchingWithOptions

##### 优化点：
> 处理好优先顺序，前后台任务分类：

###### 1. 初始化工具库
###### 2. 第三方库
###### 3. 配置APP运行环境 
###### 4. 任务线程管理

 

### reference
001. [iOS启动时间优化](http://www.zoomfeng.com/blog/launch-time.html)
002. [动态库-静态库](https://www.cnblogs.com/junhuawang/p/7598236.html)


