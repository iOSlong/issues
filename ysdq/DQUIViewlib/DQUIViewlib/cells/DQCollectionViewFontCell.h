//
//  DQCollectionViewFontCell.h
//  DQUIViewlib
//
//  Created by lxw on 2018/12/12.
//  Copyright © 2018 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>


#define DQTITLESHOW     @"DQTitleShow"
#define DQFONTNAME      @"DQFontName"

NS_ASSUME_NONNULL_BEGIN

@interface DQCollectionViewFontCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelFont;

@property (nonatomic, strong) NSDictionary *keyInfo;

@end

NS_ASSUME_NONNULL_END
