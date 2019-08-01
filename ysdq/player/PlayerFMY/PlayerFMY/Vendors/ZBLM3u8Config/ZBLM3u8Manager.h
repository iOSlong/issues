//
//  ZBLM3u8Manager.h
//  M3U8DownLoadTest
//
//  Created by zengbailiang on 10/4/17.
//  Copyright © 2017 controling. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZBLM3u8Manager : NSObject

+ (instancetype)shareInstance;

- (BOOL)exitLocalVideoWithUrlString:(NSString*) urlStr;

- (NSString *)localPlayUrlWithOriUrlString:(NSString *)urlString;

- (void)tryStartLocalService;

- (void)tryStopLocalService;

@end
