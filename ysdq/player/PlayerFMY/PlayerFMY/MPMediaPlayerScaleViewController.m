//
//  MPMediaPlayerScaleViewController.m
//  PlayerFMY
//
//  Created by lxw on 2018/6/26.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "MPMediaPlayerScaleViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Masonry.h"

@interface MPMediaPlayerScaleViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slideWidth;
@property (weak, nonatomic) IBOutlet UISlider *slideHeight;
@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;
@end

@implementation MPMediaPlayerScaleViewController {
    CGFloat _fullWidth;
    CGFloat _fullHeight;
    CGFloat _locationY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _fullWidth  = [UIScreen mainScreen].bounds.size.width - 40;
    _fullHeight = [UIScreen mainScreen].bounds.size.width - 40;
    _locationY  = self.slideHeight.frame.origin.y + self.slideHeight.frame.size.height + 30;
    self.videoView.frame = CGRectMake(20, _locationY, _fullWidth - 60, _fullHeight * 0.5);
    
    self.slideWidth.value = (_fullWidth - 60)/_fullWidth;
    self.slideWidth.value = (_fullHeight * 0.5)/_fullHeight;
    
    [self setUpMPMediaController];
}

- (IBAction)changeVideoScaleSegment:(UISegmentedControl *)sender {
    NSInteger index =  sender.selectedSegmentIndex;
    if (index == 0) {
        NSLog(@" 0 --- AspectFit");
        self.videoPlayer.scalingMode = MPMovieScalingModeAspectFit;
    }else if (index == 1) {
        NSLog(@" 1 --- AspectFill");
        self.videoPlayer.scalingMode = MPMovieScalingModeAspectFill;
    }else if (index == 2) {
        NSLog(@" 2 --- ScallFill");
        self.videoPlayer.scalingMode = MPMovieScalingModeFill;
    }
}

- (IBAction)mediaPlayStatusClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.videoPlayer play];
    }else{
        [self.videoPlayer pause];
//        [slef.videoPlayer stop];
    }
}
- (IBAction)changeWidthSlide:(UISlider *)sender {
    CGFloat playerW = sender.value * _fullWidth;
    CGFloat playerH = self.videoView.bounds.size.height;
    [self setVideoPlaySize:CGSizeMake(playerW, playerH)];
}
- (IBAction)changeHeightSlide:(UISlider *)sender {
    CGFloat playerW = self.videoView.bounds.size.width;
    CGFloat playerH = sender.value * _fullHeight;
    [self setVideoPlaySize:CGSizeMake(playerW, playerH)];
}

- (void)setVideoPlaySize:(CGSize)size {
    [self.videoView setFrame:CGRectMake(20, _locationY, size.width, size.height)];
}
- (IBAction)resetPlayer:(id)sender {
    [self setUpMPMediaController];
}

- (void)setUpMPMediaController {
    // 创建本地URL（也可创建基于网络的URL)
    NSURL *videoUrl = self.videoUrls[2];
    NSTimeInterval dateA = [[NSDate date] timeIntervalSince1970];

    if (self.videoPlayer != nil) {
        [self.videoPlayer stop];
        [self.videoPlayer.view removeFromSuperview];
        self.videoPlayer = nil;
    }
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
    moviePlayer.repeatMode = MPMovieRepeatModeNone;
    moviePlayer.shouldAutoplay = NO;
    moviePlayer.movieSourceType = MPMovieSourceTypeUnknown;
    moviePlayer.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
//    moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    // 设置该播放器的缩放模式
    moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    [moviePlayer.view setFrame: self.videoView.bounds];
    [self.videoView addSubview: moviePlayer.view];
    [moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoView);
    }];

    self.videoPlayer = moviePlayer;
    
    
    
    NSTimeInterval dateB = [[NSDate date] timeIntervalSince1970];
    if (dateB - dateA >= 1) {
        NSLog(@"耗时超过一秒！");
        NSLog(@"\n %f, \n %f, \n",dateA, dateB);
    }else {
        NSLog(@"\n %f, \n %f, \n",dateA, dateB);
    }

}
- (IBAction)changeEpisodeSegment:(UISegmentedControl *)sender {
    [self setUpMPMediaController];
    NSURL *videoUrl = self.videoUrls[sender.selectedSegmentIndex];
    self.videoPlayer.contentURL = videoUrl;
    [self.videoPlayer play];
}

- (void)dealloc {
    NSLog(@"");
    [self.videoPlayer stop];
    self.videoPlayer = nil;
}

@end
