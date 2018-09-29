//
//  MPLoadTestViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/9/27.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "MPLoadTestViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MPLoadTestViewController ()
@property (nonatomic, strong) UIView *playerBaseView;
@property (nonatomic, strong) MPMoviePlayerController    *player;
@end

@implementation MPLoadTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    self.playerBaseView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.playerBaseView];
    
    
    
    
    
    
    [self _setupPlayer];
    
    
    
    
    self.player.view.frame           = self.playerBaseView.bounds;
    self.player.view.backgroundColor = [UIColor clearColor];
    [self.playerBaseView addSubview:self.player.view];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerBaseView);
    }];

}

- (void)_setupPlayer {
    NSTimeInterval dateA = [[NSDate date] timeIntervalSince1970];
   
    [self.player stop];
    self.player = [[MPMoviePlayerController alloc] init];
    self.player.repeatMode = MPMovieRepeatModeNone;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.shouldAutoplay = NO;
    self.player.movieSourceType = MPMovieSourceTypeUnknown;
    self.player.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    NSTimeInterval dateB = [[NSDate date] timeIntervalSince1970];
    if (dateB - dateA >= 1) {
        NSLog(@"耗时超过一秒！");
        NSLog(@"\n %f, \n %f, \n",dateA, dateB);
    }else {
        NSLog(@"\n %f, \n %f, \n",dateA, dateB);
    }
}




@end
