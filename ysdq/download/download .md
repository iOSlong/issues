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

1. VideoDownloadManager.maxDownloadTaskNumber = 1;
2. VideoDownloadManager.addDownloadVideo:video];
3. VideoDownloadManager.startDownloadVideo:video retryStatus:DownloadRetryStatusNone];
4. VideoDownloadManager.reNewDownloadTasks]
5. VideoDownloadManager.downloadingVideo.startDownloadVideo

6. if(VideoFileTypeUnkonwn) VideoForDownload.fecthDownloadUrl  {获取到VideoForDownload.m3u8UrlArray}
7. [VideoDownloadManager.videosMap setObject:video forKey:itemKey];
8. else(M3U8|MP4|~) VideoForDownload.startDownloadSegment

9. BZXFileDownloadManager.downloadFileWithURL:url delegate:VideoDownloadManager
10. 



#### 播放地址，下载地址？
SAStreamOperationPlay,
SAStreamOperationDownload，



#### 





