//
//  SJAvatarBrowser.h
//  MyHouseKeeper
//
//  Created by System Administrator on 16/5/18.
//  Copyright © 2016年 llf-iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJAvatarBrowser : NSObject
/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像所在的imageView
 */
+(void)showImageView:(UIImageView*)avatarImageView;

+(void)showImage:(UIImage *)image sender:(UIView*)sender;

@end
