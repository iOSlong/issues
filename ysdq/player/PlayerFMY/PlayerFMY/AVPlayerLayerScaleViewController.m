//
//  AVPlayerLayerScaleViewController.m
//  PlayerFMY
//
//  Created by lxw on 2018/6/27.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AVPlayerLayerScaleViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerLayerScaleViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slideWidth;
@property (weak, nonatomic) IBOutlet UISlider *slideHeight;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scaleSegment;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation AVPlayerLayerScaleViewController{
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
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }else if (index == 1) {
        NSLog(@" 1 --- AspectFill");
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }else if (index == 2) {
        //Stretch to fill layer bounds
        NSLog(@" 2 --- ScallFill");
        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    }
}

- (IBAction)mediaPlayStatusClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
    }else{
        [self.player pause];
        //        [slef.player stop];
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
    self.playerLayer.frame = self.videoView.layer.bounds;
}


- (void)setupAVPlayer {
    
    static int  index = 0;
    // 创建本地URL（也可创建基于网络的URL)
    NSURL *videoUrl = nil;
    if (index %2 == 0) {
        videoUrl = [[NSBundle mainBundle] URLForResource:@"cartoon" withExtension:@"mp4"];
        self.title = @"local cartoon mp4";
    }else{
        videoUrl = [NSURL URLWithString:VIDEO_URL_KOREA_DRAMA_MP4];
        self.title = @"net korea drama";
    }
    index ++;
    
    
    AVAsset *movieAsset
    = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    playerLayer.frame = self.videoView.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.videoView.layer  addSublayer:playerLayer];
    
    self.player = player;
    self.playerLayer = playerLayer;
}

@end
