//
//  AVPlayerScaleViewController.m
//  PlayerFMY
//
//  Created by lxw on 2018/6/26.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AVPlayerScaleViewController.h"
#import <AVKit/AVKit.h>
#import <Masonry.h>

@interface AVPlayerScaleViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slideWidth;
@property (weak, nonatomic) IBOutlet UISlider *slideHeight;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scaleSegment;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@end

@implementation AVPlayerScaleViewController {
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
    
    [self setupAVPlayer];
    
}

- (IBAction)changeVideoScaleSegment:(UISegmentedControl *)sender {
    NSInteger index =  sender.selectedSegmentIndex;
    if (index == 0) {
        //Preserve aspect ratio; fit within layer bounds.
        NSLog(@" 0 --- AspectFit");
        self.playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
    }else if (index == 1) {
        NSLog(@" 1 --- AspectFill");
        self.playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }else if (index == 2) {
        //Stretch to fill layer bounds
        NSLog(@" 2 --- ScallFill");
        self.playerVC.videoGravity = AVLayerVideoGravityResize;
    }
}

- (IBAction)mediaPlayStatusClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.playerVC.player play];
    }else{
        [self.playerVC.player pause];
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


- (void)setupAVPlayer {
    
    NSURL *videoUrl = self.videoUrls[1];

    
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
    
    playerVC.player = [[AVPlayer alloc]initWithURL:videoUrl];
    
#if 0
    [self presentViewController:playerVC animated:YES completion:nil];
#else
    [playerVC.view setFrame: self.videoView.bounds];
    [self.videoView addSubview: playerVC.view];
    [playerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoView);
    }];
    self.playerVC = playerVC;
#endif
    
}
- (IBAction)changeEpisodeSegment:(UISegmentedControl *)sender {
    NSURL *videoUrl = self.videoUrls[sender.selectedSegmentIndex];
    self.playerVC.player = [[AVPlayer alloc]initWithURL:videoUrl];
    [self.playerVC player];
}


@end
