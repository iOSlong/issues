//
//  LXOperation.h
//  gcd
//
//  Created by lxw on 2020/4/30.
//  Copyright © 2020 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXOperation : NSOperation
@end



@interface NonConcurrentOperation : LXOperation
@property (nonatomic, strong) id myData;

- (instancetype)initWithData:(id)data;
- (instancetype)initWithBlock:(void(^)(void))block;

@end



NS_ASSUME_NONNULL_END
