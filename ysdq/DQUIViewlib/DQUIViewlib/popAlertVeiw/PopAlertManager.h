//
//  PopAlertManager.h
//  DQUIViewlib
//
//  Created by lxw on 2019/1/22.
//  Copyright © 2019 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ActionBlock)(_Nullable id sender);

@interface PopAlertAction : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) UIAlertActionStyle style;
@end

@interface PopAlertManager : NSObject<UIAlertViewDelegate>
@property (nonatomic, copy) NSArray *actions;
- (void)alertMessage:(NSString*)msg title:(NSString*)title actions:(NSArray*)actions;
- (void)alertMessage:(NSString*)msg title:(NSString*)title actions:(NSArray*)actions presentViewController:(UIViewController*)viewController;
@end


NS_ASSUME_NONNULL_END
