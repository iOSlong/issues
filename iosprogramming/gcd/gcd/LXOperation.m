//
//  LXOperation.m
//  gcd
//
//  Created by lxw on 2020/4/30.
//  Copyright © 2020 lxw. All rights reserved.
//

#import "LXOperation.h"

@implementation LXOperation

@end


@interface NonConcurrentOperation ()
@property (nonatomic, copy) dispatch_block_t opBlock;
@end

@implementation NonConcurrentOperation
- (instancetype)initWithData:(id)data {
    self = [super init];
    if (self) {
        _myData = data;
    }
    return self;
}
- (instancetype)initWithBlock:(void (^)(void))block {
    self = [super init];
       if (self) {
           _opBlock = block;
       }
       return self;
}
- (void)main {
    @try {
        if (_opBlock) {
            _opBlock();
        }else{
            for (int i = 0; i < 10; i ++) {
                sleep(2);
                NSLog(@"%@| %@_%d",[NSThread currentThread],_myData,i);
            }
        }
    } @catch (NSException *exception) {

    }
}
@end
