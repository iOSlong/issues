Xcode8+ Install Alcatraz plugin manager
	ref: https://github.com/johntmcintosh/xcunsign
   http://blog.csdn.net/zhongtiankai/article/details/72598467

first ，unsigned Xcode： reference follow link， unsigned your Xcode， then you install Article  can be true。

then， download and install Article， then follow the link ，get Xocde ID to Article’s itemLists.


1. [通过xcunsign 反签名一下Xcode](https://github.com/johntmcintosh/xcunsign)

    > 可能会在terminal遇见permission denied的情况，su 切换到root权限，再执行文档中的关联以及反签名
    > 继续参考：
     [1. XVim/INSTALL_Xcode8.md](https://github.com/XVimProject/XVim/blob/master/INSTALL_Xcode8.md)
     [2.update_xcode_plugins](https://github.com/inket/update_xcode_plugins)
     [3.https://gems.ruby-china.com/](https://gems.ruby-china.com/)
    
    

2. [下载安装Alcatraz](https://github.com/alcatraz/Alcatraz) 

    > 安装之后并不会在Xcode》Windows下产生Package Manager目录

3. 进行DVTPlugInCompatibilityUUID 注册
* 复制Xcode的DVTPlugInCompatibilityUUID，然后添加到Plugin<插件>的DVTPlugInCompatibilityUUIDs列表中
    > 注意，这个时候需要权限是Xcode安装拥有者权限，可能不是root权限，重新启动一个terminal就好了。
    > Xcode插件安装路径：~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/

* 获取Xcode的DVTPlugInCompatibilityUUID：显示包内容，打开Info.plist文件
* 打开插件的DVTPlugInCompatibilityUUIDs列列表:显示包内容，打开Info.plist

4. 其他插件的安装过程打底也是如此，Xcode8之后都需要主动将Xcode的DVTPlugInCompatibilityUUID添加到对应插件Plugin的DVTPlugInCompatibilityUUIDs列表中

6. 最后一个步骤，重启Xcode，会弹出Unexpected code Bundle弹框，选择Load Bundle就好了。


另附一个参考文档：http://blog.csdn.net/zhongtiankai/article/details/72598467



