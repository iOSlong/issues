//
//  ZBLM3u8Manager.m
//  M3U8DownLoadTest
//
//  Created by zengbailiang on 10/4/17.
//  Copyright © 2017 controling. All rights reserved.
//

#import "ZBLM3u8Manager.h"
#import "ZBLM3u8FileManager.h"
#import "HTTPServer.h"
#import "ZBLM3u8Setting.h"
/*
 控制中心，策略中心
 */
@interface ZBLM3u8Manager ()
@property (nonatomic, strong) NSMutableDictionary *downloadContainerDictionary;
@property (strong, nonatomic) HTTPServer *httpServer;
@property (nonatomic, assign, getter=isSuspend) BOOL suspend;
@end

@implementation ZBLM3u8Manager
+ (instancetype)shareInstance
{
    static ZBLM3u8Manager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.downloadContainerDictionary = @{}.mutableCopy;
        sharedInstance.suspend = NO;
    });
    return sharedInstance;
}

#pragma mark - public
- (BOOL)exitLocalVideoWithUrlString:(NSString*) urlStr
{
    return [ZBLM3u8FileManager exitItemWithPath:[[ZBLM3u8Setting commonDirPrefix] stringByAppendingPathComponent:[[ZBLM3u8Setting uuidWithUrl:urlStr] stringByAppendingString:[ZBLM3u8Setting m3u8InfoFileName]]]];
}

- (NSString *)localPlayUrlWithOriUrlString:(NSString *)urlString
{
    return  [NSString stringWithFormat:@"%@/%@/%@",[ZBLM3u8Setting localHost],[ZBLM3u8Setting uuidWithUrl:urlString],[ZBLM3u8Setting m3u8InfoFileName]];
}


#pragma mark - service
- (void)tryStartLocalService
{
    if (!self.httpServer) {
        NSLog(@"serverDocumentRoot:%@",[ZBLM3u8Setting commonDirPrefix]);
        self.httpServer=[[HTTPServer alloc]init];
        [self.httpServer setType:@"_http._tcp."];
        [self.httpServer setPort:[ZBLM3u8Setting port].integerValue];
        [self.httpServer setDocumentRoot:[ZBLM3u8Setting commonDirPrefix]];
        NSError *error;
        if ([self.httpServer start:&error]) {
            NSLog(@"开启HTTP服务器 端口:%hu",[self.httpServer listeningPort]);
        }
        else{
            NSLog(@"服务器启动失败错误为:%@",error);
        }
    }
    else if(!self.httpServer.isRunning)
    {
        [self.httpServer start:nil];
    }
}
- (void)tryStopLocalService
{
    [self.httpServer stop:YES];
}

@end
