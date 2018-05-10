### 一、CollectionView系列表元素曝光上报问题
【UITableView】【UICollectionView】

#### 适用集合组页面
1. 首页推荐，
2. 搜索结果页面
3. 频道列表
4. 专题及专题详情
5. 排行榜
6. 详情页推荐

> 用户有点击趋势的Album

#### 上报需求（场景）描述
* 曝光
    1. 每一个专辑或视频或搜藏历史等内容（后泛用Album）显示在界面可见，视作曝光
* 曝光上报
    1. 对发生曝光的Album进行数据上报记录】
* 曝光上报时机场景
    1. 通常是界面发生可见的内容变化（首次加载内容，内容刷新，内容滚动发生移位）
* 曝光状态-去重补充
    1.  已经曝光：在曝光时机场景中，Album已经进行过一次曝光
    2.  未曝光：在曝光时机场景中，Album没有进过曝光
    3.  曝光上报去重：经过相邻两次的曝光时机场景变换中，同一个Album两次都在界面上可视作曝光状态，那么第二次Album应该处在已经曝光状体，并且不要再重复进行曝光上报。
    
> 存在异议处与产品确认。

#### 上报机制处理

##### 1.上报时机监听 及 监听函数（上报时机监听机制）
1. 说明一般曝光上报时机处理，监听函数以及监听函数之间的合作补充。
2. 从一个页面初始化开始整个流程，【页面初始并进入，进入后页面操作，页面离开处理，再次回到页面处理】
3. 用例场景补充测试【用户从后台直接回到当时页面，处理监听】

4. UIPageViewController与NTYPageViewController处理
> 存在其他特殊场景的待补充 

##### 2. 几个可以运用的监听函数

```
// 1.UITableViewDelegate|UICollectionViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion;


// 2.UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;//<!--可以处理到DidEndDragging:-->

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;


// 3.VC.ViewActiveNoti|VC.viewAppearStateFunction
UIKIT_EXTERN NSNotificationName const UIApplicationDidBecomeActiveNotification;

- (void)viewDidAppear:(BOOL)animated;

- (void)viewDidDisappear:(BOOL)animated;
```

> 为实现上报需求，需要添加处理的代码以及运算的量挺多。


##### 3.在上报时机监听机制中，进行上报去重处理逻辑

* 代码设计示例。

* 示例核心代码组成
    1. **几个可以运用的监听函数系列** 
    2. 附加几个辅助变量：
    
     ```    
    @property (nonatomic) BOOL  reportFilterReduplicativeSwith;//去重开关
    @property (nonatomic) BOOL  havAllCellDisplayOverMark;//cell列表加载完成标记
    @property (nonatomic) NSMutableSet *reportIndexPathSet;//去重IndexPath容器
    ```
    
    3. 示例上报函数接口样式，
       
```
// 根据CellDisplay 的 IndexPath单条处理，
- (void)reportCellDisplayedInIndexPath:(NSIndexPath *)indexPath;
// 根据批量判断的上报时机进行上报的函数
- (void)reportCellsDisplayedWithoutReduplicative;
```  


        

* 根据现有示例子思路 => **后期优化处理**
     1. 利用继承关系，抽取共有部分，为相关的TableView和Collection的代理视图（ViewContorller）添加上报监听相关函数及变量。
     2. TableView 和 CollectionView 的处理异同。
     3. 更多精简代码的设计思路？


#### 上报流量优化

```
//NOW：
    ReportItem {
        String：id，
        String：aid，
        String：name，
        ……
    }
//上报JSON：
    {
        ReportItem.new[0]{
            id   = id_0,
            aid  = aid_0,
            name = name_0,
            ……
        }
        ReportItem.new[1]{
            id   = id_1,
            aid  = aid_1,
            name = name_1,
            ……
        }
        ……
        publicPro1，
        publicPro2，
        ……
        publicProN，

    }

//TODO：
    CombinReportItem {
        StringArr：id[n]，
        StringArr：aid[n]，
        StringArr：name[n]，
        ……
    }
//上报JSON：
    {
        ReportItem.new[n+1]{
            id   = [id_0,id_1,……,id_n],
            aid  = [aid_0,aid_1,……,aid_n],
            name = [name_0,name_1,name_n],
            ……
        }
        publicPro1，
        publicPro2，
        ……
        publicProN，
    }
```

### 二、页面曝光问题处理
1. 上报页面曝光包含页面相邻页面跳转关系【ref_url  cur_url】
2. wiki说明

### 三、播放器播放相关曝光（现有处理完成可用）
1. 错误码
2. 播放启动
3. 播放状态
4. wiki说明

### 四、广告曝光
1. 广告曝光特别是涉及SDK部分处理考虑ap逻辑，另需兼顾SDK曝光规律。参看wiki文档， [AdvertBusiness.md](http://wiki.shandianshipin.cn:8090/pages/viewpage.action?pageId=1152373&preview=%2F1152373%2F1152401%2FadvertBusiness_md.pdf)
2. wiki说明

### 五、app启动曝光
1. wiki说明


