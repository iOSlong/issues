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
    2. 留意确定函数调用时序调整优化启动时长时候对程序业务需求的影响。
    

3. UI构建处理
    1. Recommend，首次默认推荐，
    2. 再次init，找缓存
    
4. TODO:将请求Request的回调放置在异步线程，在特定用法出再回归到主线程进行UI操作，


#### 启动请求
1. 【版本检查】BZXUpgradeRequest : BZXJSONRequest : BZXGetRequest : BZXRequestBase
    a. 依赖函数 ：
    evaluateCurrentApp
    

2. 【根据ip获取运营商apid】BZXOperatorRequest : BZXJSONRequest
    a. 获取[BZXGlobalSingelton shared].operatorID， 用于请求公共参数"ipid" 
    > ipid为每个get请求中存有的公参，推导逻辑上这个请求应该取到值之后才能进行别的请求，然而事实非如此，所以不能确定哪些请求是不需要该参数的。
    另譬如对于提升启动时长业务，就需要知道init接口，header接口，广告接口等是否对此参数有必然依赖？
    
    
3. 【Init配置请求】BZXProjectConfigRequest : BZXJSONRequest
    a. 获取信息
        1. 是否提审状态
        2. 是否在进入前台的时候支持开屏广告 
        3. 获取tags值（用于个推tags设置， 又作为请求公参上传）
        4. 获取法律条款地址:ppocy（用户查看的@"协议与隐私";）
        5. configSplash;// 保存服务器给会splash配置字段（logical：开屏图地址）``iOS暂时未使用``
        6. phoneNumPattern;// 手机号匹配规则
        7. tagArgs, 评分|tab红点|逻辑
        
    > 确定与启动广告请求是否无必要关联？。
   
4. 【js文件更新】BZXExtractjsnewRequest : BZXDictionayRequest
    [[BZXGetNewLocalJSRequest shared] updateLocalJs];
    > 为处理后期的js处理播放流讯息，其实在进入播放之前完成即可，因此可以降低优先级，异步执行处理。
 
    
5. 【城市地理信息上传】BZXLocationRequest : BZXJSONRequest
    -->applicationWillEnterForeground:
    -->fetchAppInitInfo
      -->locationApp:
          -->fetchLocationInfo:

    --> networkErrorRefresh:[RecommendVC]
      --> checkInitAndCityAPI:
          ---> fetchAppInitInfo ---> checkCity:
          ---> checkCity:
                ---> forceCallCityAPI:
> 确定改请求优先级可以降低，不影响启动时长的优化。

    
6. 【CDE服务启动】BZXUtpStatusRequest : BZXGetRequest
    --> applicationDidBecomeActive:
    >  确定改请求优先级不影响启动时长的优化。


7. 【开屏广告请求】BZXV1ADRequest : BZXJSONRequest
    > 处理与init配置接口不存在依赖关系，则逻辑理论实践上均可以将开屏广告提前展示，达到再用户视角优化开屏时长的效果



9. 【获取首页频道列表】BZXIndexHeaderListRequest : BZXJSONRequest
    --> loadRecommendModules
    > 可以将频道加载的PageVC中对每一个VC的加载控制，将CPU主线程处理腾空，以达到优化UI体验的效果。
    

10. 【获取用户收藏影片更新信息-确定小红点显示】BZXAlbumUpdateRequest : BZXJSONRequest
     --> [AppService fetchFavorateAlbumUpdateInfo]
    > 可以作调整，UI操作部分异步到主线程队列中等待执行。
    
    





4. BZXLocalDataUploadManager
    


# TODO：
## 冗余文件
LeXiuTanService



