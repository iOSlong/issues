# application/Documents

### 追溯历史版本数据存储目录

#### 版本时间点： 
change_20170303， 是一年前对存储地址及策略做的调整，应当可以将相关代码进行删除了。

#### 下载相关目录名：
1. DQVideoDowloadInfo.plist
2. DQFileDownloadTempresumeDatas.plist //断点缓存资源存储plist文件。
3. DQVideonDownloadCache  //下载资源存放目录。
    规则文件命名：
    Document/DQFileDownloadCache/[NSString stringWithFormat:@"aid_%@_porder_%@_%@",video.aid,video.order,videoName]/[video.m3u8UrlArray indexOfObject:url]+type(M3U8-"",MP4-".mp4",Unknown-"")
4. DQFileDownloadCache
    规则文件命名：
    Document/DQFileDownloadCache/[url.absoluteString md5]
5. DQFileDownloadTemp  冗余路劲，可对相关代码做删除。


#### 调整前后对比：

实体描述 | 调整 前 | 调整 后
-------- | ------ | ------
目录 | Library/ | Documents/
缓存Dir | DQFileDownloadTemp | DQFileDownloadTemp 
下载完成视频存储Dir | DQVideonDownloadCache | DQVideoDownloadCache




file:///private/var/mobile/Containers/Data/Application/50183365-627F-43E4-929A-F72A9A59A773/Library/Caches/com.apple.nsurlsessiond/Downloads/com.ysdqTV.iphone.client/CFNetworkDownload_KFsy5Q.tmp



    
    
文件下载完成（FileDownloadManager）：

1. 得到用户定义临时文件地址：
    filePath =  currentDownloader.filePath = /Documents/DQFileDownloadCache/dcbe3897ae0c5b75094254832971bbde
    desURL  = [NSURL fileURLWithPath:filePath];
2. 获取下载缓存文件地址：
    downloadURL = /Library/Caches/com.apple.nsurlsessiond/Downloads/com.ysdqTV.iphone.client/CFNetworkDownload_fQMi3Y.tmp
3. 将下载缓存从缓存地址移动至Documents临时文件中
    [[NSFileManager defaultManager] moveItemAtURL:downloadURL toURL:desURL error:&fileMoveErr]; 


代理通知（VideoForDownload）BZXFileDownloadManager:didFinishedOfURL:downloader:

1. 通过downloader.filePath获取Documents临时文件地址
  downloadFilePath = /Documents/DQFileDownloadCache/dcbe3897ae0c5b75094254832971bbde
2. 根据下载url及VideoForDownload自身信息获取最终资源存放地址
  filePath      = [self filePathForUrl:url.absoluteString] = Documents/DQVideoDownloadCache/aid_2_723251_porder_3_不伦食堂-第3集/0.mp4；
3. 将Documents临时文件转移到最终下载文件规则拼接的地址
 [[NSFileManager defaultManager] moveItemAtPath:downdFielPath toPath:filePath error:&error];
 
 
 
 
 
 
 
 
 
 
 
 
 

 





```sequence
Andrew->China: Says Hello
China->DownloadOne: notiforDownload must be one 
Note right of China: China thinks\nabout it
China-->Andrew: How are you?
Andrew->>China: I am good thanks!
```

