//
//  LXOperation.h
//  gcd
//
//  Created by lxw on 2020/4/30.
//  Copyright © 2020 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXOperation;
@protocol LXOperationDelegate <NSObject>
- (void)albumAnalyzeDidCompletionOperation:(LXOperation *_Nullable)operation;
@end

NS_ASSUME_NONNULL_BEGIN

@interface LXOperation : NSOperation
@property (nonatomic, weak) id<LXOperationDelegate>delegate;
@end



@interface NonConcurrentOperation : LXOperation
@property (nonatomic, strong) id myData;

- (instancetype)initWithData:(id)data;
- (instancetype)initWithBlock:(void(^)(void))block;

@end



@interface ConcurrentOperation : LXOperation {
    BOOL executing;
    BOOL finished;
}
@property (nonatomic, readonly)NSArray *photoTasks;
- (instancetype)initWithAlbum:(id)album;
- (void)completeOperation;
@end



NS_ASSUME_NONNULL_END
