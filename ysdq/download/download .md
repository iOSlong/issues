### download 

demoURL:http://122.228.76.38/play/0291BBB5F30D370B68EB226730D2B6012E0E9CB0.mp4?app_code=web&mac=15220349085d0b6&token=REZBQzVCMERBQzYwOTkxMEFBMUFCRTdBQ0JDODBFMDM2MThFMEM4Rl93ZWJfMTUyNzIxNjM2MA==&user=web_2_2018-05-25-08-30&user_id=&user_token=&vf=MCw1MjJGMg==

#### App
AppDelegate: 
+(void)observeDownloadManager 


#### 下载业务辅助类文件
**FileHelper** 
> 磁盘检查

```
+ (uint64_t)getFreeDiskspaceMB;
+ (unsigned long long int)folderSize:(NSString*)folderPath;
+ (BOOL)CheckVideoFileIsAvalible:(NSString*)path;
```
**Reachability** 
> 网络检查

**BZXCachePromptView**
> 下载操作提示弹框

**BZXReminderNetState**
> 下载网络状态弹框提示。参看VideoObjectState.reachabilityChanged

**BZXVideoObjectState**
> 用于处理网络监听之后的下载网络弹框状态。参看VideoDownloadManager.addNotifications

**BZXAppSettings** 
> 全局变量存储 | 下载操作弹框方法接口
```
@property BOOL                         b3GDownloadEnable;
@property BZXVideoResolution<Optional> *downloadResolution;
@property BZXVideoResolution<Optional> *playResolution; //具体参考player2类
@property NSString<Optional>        *downloadFolderPath;
//下载操作提示弹框 - 可以与BZXCachePromptView合并
- tipAllowDownloadPresentViewController
```

#### 下载数据类文件 和 管理操作类文件

##### 数据类文件
**BZXVideoResolution**
**BZXVideo**
**BZXVideoForDownload**
**BZXVideoObjectState**
**DownLoadObject**
**SASPlayableVideo**
**BZXFileDownloader**

##### 管理操作类
###### BZXVideoDownloadHelpler
> 数据转换处理 | 数据读取处理

```
+ (BZXVideo*)createDownloadVideo:(BZXDetailRequest2Item*)item episodeIndex:(NSInteger)i;
+ (NSDictionary*)readAllOldDownloadDataToVidoeDownloadMap;
```

###### BZXVideoDownloadManager
下载流程控制管理

> FIXME:

1. // FIXME: long{ hasReaded可作为单列的一个属性，进行一次性判断，而不应该使用userdefault【占用userdefault资源，代码结构复杂化】 }
2. // FIXME: long{ hasMove可作为单列的一个属性，简化代码，而不应该使用userdefault【占用userdefault资源，代码结构复杂化】 }
3. // FIXME: long{ checkOldDownloadDir，本方法经过一年多的版本迭代，已经可以移除，原有下载路径已经毫无意义 }


###### BZXDownloadManager
> 可以废弃的类。



###### BZXFileDownloadManager
> 文件下载管理类


###### BZXFileDownloader
> 文件下载执行类   


### DateStore
old:  /Library/DQVideonDownloadCache
      /Library/DQVideonDownloadCache/DQVideoDowloadInfo.plist
      videosMap = 



### 验证以下类及代码可以删除（相关逻辑的代码都应当删除）：
#### BZXDownloadManager类
#### BZXJSPatchManager类
#### BZXOldDataHelp类
#### BZXM3U8Downloader类
#### BZXM3U8VideoDownloader类
#### 函数readAllOldDownloadDataToVidoeDownloadMap，及调用它的相关逻辑代码
#### 函数checkOldDownloadDir，及调用它的相关逻辑代码
#### 函数readOldData，及调用它的相关逻辑代码
#### 函数checkOldDownloadDir


           

### 流程
#### 一、 添加下载任务，并启动下载任务
* 业务类：视频下载管理类 **VideoDownloadManager**
* 相关数据类：
    1. VideoForDownload 
        > 视频下载单位，与视频一一对应，并处理对应下载任务。
        
* 函数操控流程：
    1. 设置支持下载同步任务数：VideoDownloadManager.maxDownloadTaskNumber = 1;
    2. 添加下载任务：[VideoDownloadManager.addDownloadVideo:video];
    3. 启动下载任务：
        1. [VideoDownloadManager.startDownloadVideo:video retryStatus:DownloadRetryStatusNone];
            > 生成VideoForDownload,做相应初始化配置，并添加到管理队列。
        
        2. [VideoDownloadManager.reNewDownloadTasks]
            > 刷新下载任务队列，以及刷新本地数据。
            
        3. VideoDownloadManager.downloadingVideo.startDownloadVideo
            > 对应downloadingVideo调用开始下载视频的任务。

#### 二、获取下载地址，并根据地址进行分段下载
* 业务类：视频下载类：**VideoForDownload**
* 相关数据和功能类：
    1. BZXParseHelper
        > 获取下载六地址功能类
    2. FileDownloadManager
        > 下载任务管理类

* 函数操控流程
    1. 获取下载流地址：if(VideoFileTypeUnkonwn) VideoForDownload.fecthDownloadUrl  {获取到.m3u8UrlArray}
        > BZXParseHelper工具类根据类信息获取下载流地址: VideoForDownload.m3u8UrlArray
    
    2. 流地址成功后更新视频下载管理列表数据: [VideoDownloadManager.videosMap setObject:video forKey:itemKey]; 
    
    3. 根据VideoForDownload的下载地址数组，开始进行按序分段下载。
        > else(M3U8|MP4|~) VideoForDownload.startDownloadSegment

#### 三、资源下载，并进行代理同步、数据更新
* 业务类：文件下载类：**FileDownloadManager**
* 相关数据和功能类：
    1. VideoForDownload
        > 对应下载视频资源，代理下载资源回调，
    2. FileDownloadManager
        > 下载任务管理类，管理fileDownloader数据及对应的下载task网络任务。
    3. FileDownloader 
        > 对应着一个下载单位，作为一条下载内容业务数据的存储传递类。


* 函数操控流程：
    1. 下载管理类启动一条下载：FileDownloadManager.downloadFileWithURL:url delegate:VideoDownloadManager header:videoForDownload.header
        > 参数为：下载地址url、代理videoForDownload、请求头videoForDownload.header
    
    2. 为对应下载url创建FileDownloader实例：
        > 1. 生成资源文件路径，[FileDownloadManager.filePathForURL:url]
        > 2. 穿甲FileDownloader：[FileDownloader alloc] initWithURL:url filePath:[self filePathForURL:url]
        > 3. 将下载单元存储类添加到下载管理数组序列中，_downloaders.addobject:downloader
    
    3.  根据下载单元数据类，启动网络下载任务。 
        > [self startDownLoadWithObject:downloader]
        1. 查询已经存在的NSURLSessionDownloadTask
            1. 根据下载地址url从现有任务序列(_downloadTasks)寻找，
            2. 根据系在地址url寻找已有缓存数据resumeData，若resumeData存在则利用缓存数据找回[self downloadTaskWithResumeData:resumeData]
        2. 没有找着NSURLSessionDownloadTask，则新建下载任务
        3. 启动下载任务[currentDownLoadTask resume]，并将之添加到任务管理队列_downloadTasks[keyForUrl] = currentDownLoadTask。
        4. 同步对应FileDownloader.tate状态。
        
    
        

#### 播放地址，下载地址？
SAStreamOperationPlay,
SAStreamOperationDownload，



#### 





