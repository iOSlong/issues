#optimize_luanchTime

### reference urls
1. [about llvm&clang 01](https://blog.csdn.net/majiakun1/article/details/79364258)
2. [[iOS]一次立竿见影的启动时间优化](https://www.jianshu.com/p/c1734cbdf39b) 
 

### get reference websites
1. [KyleWong, an software developer from China com.alibaba|didi|wangyi-](https://kangwang1988.github.io/#about)
    
    > [about llvm&clang,](https://kangwang1988.github.io/tech/2016/10/31/write-your-first-clang-plugin.html)   
    

2. [iOS 学习笔记](https://github.com/ming1016/study/wiki)

### mark
1. 程序启动相关网络请求
    a. init接口 【不可省】
    b. headersItems 接口【在非首次启动的情况下，可利用缓存策略和限制UI绘制策略优化】
    c. recommendPage 【判断】
2. 寻找关联，？

### Plan
1. 任务线程分割
    1. 与事件类型冲突的，以主线程任务优先
    2. [GCD-使用此法做一个整理](https://juejin.im/post/5a90de68f265da4e9b592b40)
    3. DQ: NTYTasksExecutor | BZXDispatch | YYDispatchQueuePool
    
2. 缓存效果处理
    1. 对部分request，添加init询问缓存逻辑。

3. UI构建处理
    1. Recommend，首次默认推荐，
    2. 再次init，找缓存


# TODO：
## 冗余文件
LeXiuTanService



