//
//  STMAssembleViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2019/3/16.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "STMAssembleViewController.h"
#import "Masonry.h"
#import "STMAssembleView.h"

@interface STMAssembleViewController ()
@property (nonatomic, strong) STMAssembleView *asView;

@property (nonatomic, copy) NSString *asStr;
@property (nonatomic, strong) NSDictionary *asDic;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *clickBt;

@end

@implementation STMAssembleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Do any additional setup after loading the view.
    self.avatarImageView = [UIImageView new];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 35/2;
    self.clickBt = [UIButton new];
    
    [self asyncMake];

}

- (void)asyncMake {
    self.asDic = @{
                   @"avatarImageView":self.avatarImageView,
                   @"clickBt":self.clickBt
                   };
        //排列居中
    NSString *sizeStr = @"width:25,height:18";
    NSString *centerStr = ASS(@"{hc(padding:30,extendWith:1)[(imageName:starmingicon,%@)][(imageName:starmingicon,%@)][(imageName:starmingicon,%@)]}",sizeStr,sizeStr,sizeStr);
        //嵌套组合布局
    NSString *midStr = @"{ht(padding:10,extendWith:2)[avatarImageView(imageName:avatar)][{vl(padding:10)[(text:戴铭,color:AAA0A3)][(text:Starming站长,color:E3DEE0,font:13)][(text:喜欢画画编程和写小说,color:E3DEE0,font:13)]}(width:210,backColor:FAF8F9,backPaddingHorizontal:10,backPaddingVertical:10,radius:8)]}";
        //按钮
    NSString *followBtStr = @"{hc(padding:4,extendWith:1)[(imageName:starmingicon,width:14,height:10)][(text:关注,font:16,color:FFFFFF)]}";
        //说明区域
    NSString *desStr = @"{hc(padding:5.5,extendWith:1)[(text:STMAssembleView.演示,color:E3DEE0,font:13)][(imageName:starmingicon,width:14,height:10,ignoreAlignment:left)][(text:www.starming.com星光社,color:E3DEE0,font:13)]}";
        //整体组装
    self.asStr = ASS(@"{vc(padding:20)[%@][%@(backColor:AAA0A3,radius:8,backBorderWidth:1,backBorderColor:E3DEE0,backPaddingHorizontal:80,backPaddingVertical:20,button:<clickBt>)][%@][%@(ignoreAlignment:top,isFill:1)]}",midStr,followBtStr,centerStr,desStr);
    
    __weak typeof(self) weakSelf = self;
    [STMAssembleView fsAsync:self.asStr objects:self.asDic completion:^(STMAssembleView *asView) {
        [weakSelf.view addSubview:asView];
        [asView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(30);
            make.left.equalTo(weakSelf.view).offset(20);
            make.right.equalTo(weakSelf.view).offset(-20);
            make.bottom.equalTo(weakSelf.view).offset(-20);
        }];
    }];
}

@end
