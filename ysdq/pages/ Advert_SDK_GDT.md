 Advert_SDK_GDT
 需同步GDT广告问题描述。

### 测试信息补充
* 手机系统：         iOS 11.3.1 
* 手机型号：         iPhone 6s Plus
* SDK版本：         v4.7.9  
* 广告位id：        4010530346353877
* 广告类型：        原生广告(GDTNativeAd)
* 问题描述：        见《操作流程及问题描述》问题 1，2，3
* 发生时间：        20180904 ~ 
* 是否必现：        偶现
* 复现流程：        按照描述中操作流程反复操作。
* 是否有崩溃日志：   已附在文档中。
* APP包名：        影视大全，对应bundleID【com.ysdqTV.iphone.client】 
* APP版本：        v2.5.7


### 操作流程及问题描述

#### 操作流程：
    在app页面点击GDT原生广告进行跳转，进入广告落地页后点击关闭广告，再回到app页面后刷新广告，立即点击重新渲染在界面的广告，快速重复此操作。

#### 发现问题：
##### 1. 快速反复操作流程，偶现广告点击无响应。
    > 会收到回调信息，调用函数nativeAdFailToLoad:(NSError *)error，【errorCode=4006：广告未曝光】.

##### 2. 跳转广告落地页（GDTStoreProductController）有2s左右时长的跳转延迟。
    

##### 3. 在快速频繁重复点击广告跳转和关闭过程中，会偶现跳转崩溃问题，log如下：

```
2018-09-05 10:32:36.649288+0800 [240:6906] Attempt to present <GDTStoreProductController: 0x105e5c480> on <DetailViewController: 0x106074000> which is waiting for a delayed presention of <GDTStoreProductController: 0x112e34ea0> to complete
```


### 补充对于第1个问题的判断追踪：

>（4006：广告未曝光）GDTNativeAd –> attach:toView:方法告知广点通广告已经渲染完毕并 曝光。
 
1. 上诉函数已经在点击广告前(本地渲染广告完成后)进行调用，所以推断是SDK中该函数调曝光时序存在延迟。

2. 广告id：【4010530346353877】





### 手机信息
* 手机系统：         iOS 10.3.3 
* 手机型号：         iPhone 5s
* SDK版本：          v4.7.9  
* 广告位id：        1080215124193862
* 广告类型：        原生广告(GDTNativeAd)
* 问题描述：        广告点击无响应。
* 发生时间：        20180905 ~ 
* 是否必现：        必现。
* 复现流程：        必现。
* 是否有崩溃日志：   无。
* APP包名：        影视大全，对应bundleID【com.ysdqTV.iphone.client】 | GDT_demo 
* APP版本：        v2.5.7


发现一个新问题，一台Phone 5s   ，iOS 10.3.3，  将demo程序运行上去，发现所有广告点击都无响应，也没有log信息输出；找来4.7.5版本的demo运行了也是如此。 


