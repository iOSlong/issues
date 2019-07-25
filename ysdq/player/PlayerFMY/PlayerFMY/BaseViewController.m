//
//  BaseViewController.m
//  PlayerFMY
//
//  Created by lxw on 2018/6/26.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *videoUrl1 = [[NSBundle mainBundle] URLForResource:@"WeChatSight15153" withExtension:@"mp4"];
    NSURL *videoUrl2 = [[NSBundle mainBundle] URLForResource:@"fat_rabbit" withExtension:@"mov"];
//    NSURL *videoUrl3 = [NSURL URLWithString:VIDEO_URL_KOREA_DRAMA_MP4];
    NSURL *videoUrl3 = [[NSBundle mainBundle] URLForResource:@"icebinfire" withExtension:@"mp4"];
    self.videoUrls = @[videoUrl1,videoUrl2];
//    self.videoUrls = @[videoUrl1,videoUrl2,videoUrl3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
