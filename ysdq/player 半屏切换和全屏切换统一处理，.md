#player 半屏切换和全屏切换统一处理，
1. 屏幕切换时机
    1. 屏幕旋转监听
    2. 用户操作切换
    3. 注意处理播放器进行了锁屏的情况，【优先级 > (1 & 2)】

2. 屏幕切换需处理功能切换
    1. UIDevice， currentOrientation变换 
    2. APPlication  statusBar
    
3. 规则描述：
    1. 将相关设备级别以及应用级别的处理封装为为更方便的接口
    2. player2不直接调用，而是发送消息，让控制player2显示的控制器(detailViewController | locolPlayerViewController)去调用。

4. player2中关于横竖屏切换的代码
    1. 存在statusbar代码  
    2. 强制旋转屏@selector(forceToOrientation:)
    3. 调用@selector(forceToOrientation:)的函数
        1. *halfScreenBackBtnAction:*
            1. 调用时机：用户点击播放器上面的返回按钮
            2. 作用：
                * 当处在横屏播放模式的时候，进行竖屏设置，
                * 当已经是竖屏模式时候，退出播放器(导航控制器pop推出)
        2. *enterFullScreenMode:*
            1. 调用时机：detail页面中的浮层控件[分享，剧集，下载]取消之后
            2. 作用：detail浮层出现时候是禁止旋屏的，当浮层消失之后如果设备处在旋转横屏位置，并且不处在锁屏状态，那么app进行横屏设置。
        3. *fullScreenBtnAction*
            1. 调用时机：竖屏播放模式下点击全屏播放按钮
            2. 作用：设置横屏播放模式(设备横屏设置)
        4. *fullScreenAction:*
            1. 调用时机：第三方播放器要求进入全屏模式<目前只有tencent播放器-广告播放使用到>
            2. 作用：设置横屏播放模式(设备横屏设置)

    
    ```
    1. statusbar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    ```
    
    ```
    2. forceToOrientation：
    - (void)forceToOrientation:(UIDeviceOrientation)orientation {
      [Dispatch after:0.3 execute:^{
        [UIDevice setOrientation:orientation];
     }];
    }//<!--> 这个0.3秒延时需要处理验证-->
    ```
    
    ```
    3.1
    - (void)halfScreenBackBtnAction:(UIButton*)btn {
     UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (statusBarOrientation == UIInterfaceOrientationPortrait) {
            [self backAction:btn];<!--为什么不是调用dismiss？ ：detail中pop调用的是dismiss-->
            [self.navigationController popViewControllerAnimated:YES];
        } else {
         [self forceToOrientation:UIDeviceOrientationPortrait];
     }
    }
    ```
    
    ```
    3.2
    - (void)enterFullScreenMode:(UIDeviceOrientation)orientation {
        [self forceToOrientation:orientation];
    }
    ```
    ```
    3.3
    - (void)fullScreenBtnAction {
     [self forceToOrientation:UIDeviceOrientationLandscapeLeft];
    }
    ```
    ```
    3.4
    - (void)fullScreenAction:(LePlayerView*)playerView {
     [self forceToOrientation:UIDeviceOrientationLandscapeLeft];
    }
    ```
    
    
#修改具体建议
1. 关于4.1， 代码移动到detailVC|locolPlayerVC中处理
2. 关于设备旋转处理封装如下

```
UIDevice +
+ (void)setOrientation:(UIDeviceOrientation)orientation {
    NSNumber *orientationUnknown = @(UIInterfaceOrientationUnknown);
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *orientationTarget = @(orientation);
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
```
2. 关于4.2 根据现有逻辑，*可以直接从player2中移除，在detail中处理即可*。
3. 关于3.3相关处理如下：
    1. playerViewController2 添加事件枚举 *代码参考3.1*
    2. DQPlayerViewController2Delegate 添加代理函数，
    3. 【将3.1 ~ 3.4】通过代理处理到detail|localPlayer中处理。*代码参考3.2*
        
    ```
    3.1 
    typedef NS_ENUM(NSUInteger, SASPlayerEvent) {
        SASPlayerEventFullScreenClicked,
        SASPlayerEventBackbuttonClicked,
       SASPlayerEventComplainbuttonClicked,
       SASPlayerEventNeedRetry,
       <!--more-->
    };
    ```
    ```
    3.2 实现如下
    - (void)playerViewController:(UIViewController *)viewController playerEvent:(SASPlayerEvent)event {
    if (event == SASPlayerEventBackbuttonClicked) {
         UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
           if (statusBarOrientation == UIInterfaceOrientationPortrait) {
                [self.playerViewController backAction:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
               [self forceToOrientation:UIDeviceOrientationPortrait];
            }
       }
       <!--more-->
    }
   
    - (void)playerViewController:(UIViewController *)viewController actionOrientation:(UIDeviceOrientation)oritation {
     [self forceToOrientation:oritation];
}
```



