//
//  M3U8Server.h
//  PlayerFMY
//
//  Created by lxw on 2019/8/1.
//  Copyright © 2019 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface M3U8Server : NSObject
@property (nonatomic, readonly, copy)NSString * address;
@property (nonatomic, assign) BOOL        needStartM3u8Server;//本地M3U8文件播放时为YES，其它情况(包括退出播放)都为NO

+ (instancetype)shared;
- (void)start;
- (BOOL)needStartServer:(NSString*)url;
- (void)setupHTTPServer;


@end

NS_ASSUME_NONNULL_END
