//
//  M3U8Server.m
//  PlayerFMY
//
//  Created by lxw on 2019/8/1.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "M3U8Server.h"
#import <CocoaHTTPServer/HTTPServer.h>

#define kM3U8ServerPort     8080

@interface M3U8Server ()
@property (nonatomic, strong) HTTPServer *server;
@property (nonatomic, copy) NSString     *address;
@end

@implementation M3U8Server
+ (instancetype)shared {
    static M3U8Server *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [M3U8Server new];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _address = [NSString stringWithFormat:@"http://127.0.0.1:%d",kM3U8ServerPort];
        __weak __typeof(self)weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:NSExtensionHostDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf stop];
        }];
    }
    return self;
}
- (void)start {
    [self testM3U8Server];
        //    while (!self.m3u8ServerRuning) {
        //        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        //    }
}

- (void)stop {
    [self.server stop];
}

- (void)testM3U8Server {
    __weak __typeof(self)weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.address]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse*_Nullable response, NSData*_Nullable data, NSError*_Nullable connectionError) {
                               __strong __typeof(weakSelf)strongSelf = weakSelf;
                               if (!connectionError) {
                                   [NSObject cancelPreviousPerformRequestsWithTarget:strongSelf selector:@selector(testM3U8Server)object:nil];
                               } else {
                                   [strongSelf setupHTTPServer];
                                   [strongSelf performSelector:@selector(testM3U8Server)withObject:nil afterDelay:0.2];
                               }
                           }];
}

- (NSString *)m3u8DocumentPath {
    NSArray  *directoryArr      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = directoryArr.firstObject;
//    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"m3u8files"];
    return documentDirectory;
}
- (NSString *)bundleM3u8FilePath {
//    NSString *filesDirPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"m3u8files"];
    NSString *filesDirPath = @"/Users/lxw/Documents/fmy/issues/issues/ysdq/player/PlayerFMY/PlayerFMY/videos/m3u8files";
    return filesDirPath;
}

- (BOOL)copybundleFileInDocument {
    NSString *docFileDir = [self m3u8DocumentPath];
    NSString *bundleFileDir = [self bundleM3u8FilePath];
    NSError *error = nil;
    BOOL succ = NO;
    BOOL idDir = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath: docFileDir isDirectory:&idDir];
    if (!exists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:docFileDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:docFileDir]) {
         succ = [[NSFileManager defaultManager] copyItemAtPath:bundleFileDir toPath:[docFileDir stringByAppendingPathComponent:@"m3u8files"] error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    NSLog(@"docFileDir:%@\n bundleFileDir:%@\n",docFileDir,bundleFileDir);
    return succ;
}

- (void)setupHTTPServer {
    if (![self copybundleFileInDocument]) {
        NSLog(@"copybundleFileInDocument failed");
        return;
    }
    if ([self.server isRunning]) {
        [self.server stop];
    }
    
    NSString *referRoot  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"m3u8files"];
    
    HTTPServer *server = [[HTTPServer alloc] init];
    server.type = @"_http._tcp.";
    server.port = kM3U8ServerPort;
    server.documentRoot = referRoot;
    self.server = server;
    
    NSError *error = nil;
    if (![server start:&error]) {
        NSLog(@"http server start failed. %@", error);
    }
}

@end
