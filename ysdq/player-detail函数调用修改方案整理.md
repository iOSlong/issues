# player-detail函数调用修改方案整理

# part0-半屏切换和全屏切换统一处理

##player 半屏切换和全屏切换统一处理，
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
        1. 状态栏处理的代码@selecor(setStatusBarHidden:withAnimation:)
        2. 
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
            1. 调用时机：第三方播放器要求进入全屏模式<目前有tencent播放器-广告播放使用到+前贴片广告使用到>
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
    
    
## 修改具体建议
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
3. 关于4.3相关处理如下：
    1. playerViewController2 添加事件枚举 *代码参考3.1*
    2. DQPlayerViewController2Delegate 添加代理函数，
    3. 【将4.3.1 ~ 4.3.4】通过代理处理到detail|localPlayer中处理。*代码参考3.2*
        
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
    3.2 实现如下<!--注意LocolPlayer中的处理退出用的是dismissViewController方式退出播放页-->
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




# part1-Player2播放器页面退出api

## Player2播放器页面退出api
1. 页面退出时机
    1. 在video详情页面(DetailViewController),点击左上角返回按钮，调用popViewControllerAnimated方法。
    2. 在本地播放页面(LocolPlayerViewController)，点击左上角返回按钮，调用dismissViewController
    
2. 页面退出方式处理(根据代码进行逆推逻辑)
    1. popViewControllerAnimated
        1. 先进行[player backAction:], 然后pop<!--参看detail+player 调用退出-->
        2. 先进行[player dismiss], 然后pop<!--参看detail调用退出-->
    2. dismissViewControllerAnimated:YES completion:dissmissCompleteBlock
        1. 关于backaction:中的dissmissCompleteBlock_BackAction {}
        
         ```       
        [DQGlobalSingelton shared].bSomethingPlaying = NO;
        self.viewDismiss                             = YES;
         ```
         
        2. 关于[player dismiss]中的dissmissCompleteBlock_dismiss {}
        
            ```
             [DQGlobalSingelton shared].bSomethingPlaying = NO;
             self.viewDismiss = YES;
             [UIViewController attemptRotationToDeviceOrientation];                 <!--可以移除-->
             [self setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];   <!--可以移除-->
             if ([self.delegate respondsToSelector:@selector(openHtml:name:)]) {    <!--可以移除-->
                if (self.currentEpisode < (NSInteger)self.episodes.count) {
                    NSString *urlStr = [self.episodes[self.currentEpisode].episode url];
                    if (urlStr.length) {
                       [self.delegate openHtml:urlStr name:self.filmTitle];
                    } else {
                       NSLogError(@"!<播放>出错了 播放出错后跳h5但是url为空");
                    }
                }
              }
         ```
3. 退出行为结合代码正向逻辑推导：
    1. 本地播放退出行为
        1. 退出时机：点击返回按钮 | 进度条拖拽到最后 | 
        2. 调用方法：[player backAction:] ->dismissViewControllerAnimated    <!--if(isHalfScreenAtFirst)-->
        3. 得出结论：(1)本地播放不会调用[player dismiss];
    
    2. 在线详情播放退出行为
        1. 退出时机：
            1. 播放中点击返回按钮 <!--Player2+HalfScreenSupport-selector(halfScreenBackBtnAction)-->
                1. 会调用[player backAction:] 
            2. 播放最后一集结束 <!--Player2-selector(playerView:playbackChanged:)-->
                1. 会调用[player backAction:] 
            3. 错误页面点击返回按钮<!--Detail-selctor(back)-->
                1. 会调用[player dismiss]


##修改建议：
1. 关于backAction:的处理
    1. 修改函数selector(backAction:)，并且xib中的backButton不要removeAction重新添加，并在backAction函数中判断需要处理的halfScreenBackBtnAction:的情况
    2. 添加函数：playerQuitPrepare:(SASPlayerEvent)event，用于更清晰的处理事件，特别是将原始backAction:中与退出无关的代码转移到playerQuitPrepare:方法中去。
    3. player调用backAction:的地方，如果不是直接的返回按钮事件，可以切换为调用playerQuitPrepare:
    
2. 对于[Player dissmiss]方法的处理
    根据修改建议1 中的处理，可以将Dismiss方法替换为prayerQuitPrepare:,


# part2-横竖屏相关&本地|网络播放标记字段

## 横竖屏相关&本地|网络播放标记字段
1. 半屏标记字段：self.isHalfScreen
2. 本地播放字段：
    1. self.isHalfScreenAtFirst
    2. self.bIsLocalFile
    
## 返回按钮
1. @property (nonatomic, strong) UIButton *backBtn;     //!<半屏状态下的返回按钮
    1. 半屏播放的情况下显示，全屏播放的时候隐藏
    2. 调用方法：[self halfScreenBackBtnAction:sender];
    
2. @property (nonatomic, weak) IBOutlet UIButton        *backButton;
    1. backButton.superView  = ( topView:DQPlayerTopView)
    2. backButton的显示和隐藏同步于topView。
    3. 调用方法：[self halfScreenBackBtnAction:sender];

3. @property (nonatomic, strong) UIButton          *backButton;
    1. backButton.superView  = (Detail.view)
    2. 当页面进入播放启动状态(成功获取剧集信息-准备获取留地址播放)时候，backButton被移除。
    3. 调用方法[detail back]
    4. 使用几率：在player2没有完成初始化和网络处理之前出现，如果前面的情况执行了，那么就不会用到它了。
    > 根据现有逻辑判断，返回按钮3出现的几率是最低的，但是又不适合移除掉。
    
4. @property (nonatomic, strong) UIButton *backButton;
    1. backButton.superView = (FullPlayerWithBackOverlayView:FullPlayerOverlayView)
    2. 提示网络错误|爱奇艺|广告前贴|播放错误页面
    3. 调用方法：[self halfScreenBackBtnAction:sender];
    
5. 出现错误界面，导航条显示，点击导航条上的返回按钮

> 本地页面播放的情况，只会出现按钮2和按钮4.


## 注意
1. isHalfScreenAtFirst的set方法存在重写，关联backBtn按钮

```
- (void)setIsHalfScreenAtFirst:(BOOL)isHalfScreenAtFirst {
    _isHalfScreenAtFirst = isHalfScreenAtFirst;
    self.backBtn.hidden  = isHalfScreenAtFirst;
}
```

## 修改建议
1. 根据现有逻辑， 2.1和2.2两个字段中，应该可以移除isHalfScreenAtFirst字段。

2. 返回按钮2 IBOutlet backButton，没在网络播放时候没有必要使用重新添加action:@selector(fullScreenBtnAction)，而是修改backAction的函数实现，然后在backAction中判断是否需要调用fullScreenBtnAction。





# part3-player&detail原有代理

## player&detail原有代理处理

### DQPlayerViewController2Delegate协议添加到父视图控制器的代理函数
1. 协议代理函数——PartOne

```
- (void)needClearPlayerStateViewWhenChangeEpisode {
    [self choseBackgroundViewStyle:DQDetailPlayTypePlayOnly];
}

- (void)needGotoOfflineForCloud {
    [self choseBackgroundViewStyle:DQDetailPlayTypeOffline];
}

- (void)needOpenHtml:(NSString*)urlString withName:(NSString*)name {
    DQDetailPlayType playType = isEmpty(urlString)? DQDetailPlayTypeOffline:DQDetailPlayTypeHTMLOnly;
    [self choseBackgroundViewStyle:playType];
}

- (void)needRetry {
    [self choseBackgroundViewStyle:DQDetailPlayTypeRetry];
}

- (void)needOpenHtml:(NSString*)urlString withName:(NSString*)name JieLiuFaild:(BOOL)isJieLiuFaild {
    if (isJieLiuFaild) {
        [self choseBackgroundViewStyle:DQDetailPlayTypeRetry];
    }
}
```
> 这几个代理函数命名差异比较大，而实现方法中调用的函数是同一个函数。所以可以合并处理，带参映射DQDetailPlayType。

2. 关于函数choseBackgroundViewStyle 和  setPlayerBackgroundViewState:

```
- (void)choseBackgroundViewStyle:(DQDetailPlayType)playType {
    [self setPlayerBackgroundViewState:playType
                   playerContainerView:self.playerContainer
                              playerVC:self.playerViewController];
}

//设置播放器背景状态
- (void)setPlayerBackgroundViewState:(DQDetailPlayType)type
                 playerContainerView:(UIView*)contaniner
                            playerVC:(DQPlayerViewController2*)playerViewController {
    [playerViewController clearCurrentErrorOverlayView];
    [playerViewController clearCurrentAqyOverlayView];
    switch (type) {
    case DQDetailPlayTypePlayOnly:
    case DQDetailPlayTypePlayAndHTML: {
            if (self.isAddPlayer) {return;}
            self.isAddPlayer = YES;
            [contaniner addSubview:playerViewController.view];
            return;
        }
    case DQDetailPlayTypeRetry: {
            if (![self isCurrentSiteURLValide]) {
                type = DQDetailPlayTypeRetryWithoutWebsiteButton;
            }
            break;
        }
    case DQDeaillPlayTypeAqy: {
            self.playerViewController.playerType = DQPlayerTypeiQIYI;
            break;
        }
    default:
        //其他情况正常传指
        break;
    }
    self.backgroundView          = [playerViewController showBackgroundView:type];
    self.backgroundView.delegate = self;
}
```
> 由方法实现分析
    1. DQDetailPlayTypePlayAndHTML 这个case是添加播放器视图的
    2. [playerViewController showBackgroundView:type];这句函数可以知道展示背景页面只依赖type值，不依赖于detail。
    3. 对于1的情况可以将播放器视图player.view的添加处理在别的时机，结合2可以得出结论：播放器的特殊type页面显示可以不依赖与detail。
    

3. 协议代理函数——PartTwo

```
- (BOOL)isErrorViewShown {
    return [self isBackgroundViewShown];
}
```
> 根据现有代码逻辑，这个代理函数是可以清楚掉的


4. 修改建议：
    1. 方案1.
        1. 将partOne中的代理函数统一，通过DQDetailPlayType参数区分行为 *易于维护管理*
        2. 将setPlayerBackgroundViewState:playerContainerView:playerVC:拆分
            1. player.view 的添加依赖于playerContainerView 可以处理成一个特定用途的函数
            2. [playerViewController showBackgroundView:type]相关为另外一个函数，用于4.1修改的代理函数。

    2. 方案2.*推荐这个方案*: 
        1. 将setPlayerBackgroundViewState:playerContainerView:playerVC:拆分
            1. player.view 的添加依赖于playerContainerView 可以处理成一个特定用途的函数
            2. [playerViewController showBackgroundView:type]这个过程对detail无依赖，所以可以移除所有pargeOne相关代理函数，对于showBackgroundView:的处理搁置在player中。
            3. 如果type值需要detail处理，那么只对detail添加一个判断处理type的代理。
            




