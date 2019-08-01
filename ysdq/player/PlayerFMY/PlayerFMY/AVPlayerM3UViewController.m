//
//  AVPlayerM3UViewController.m
//  PlayerFMY
//
//  Created by lxw on 2019/7/31.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "AVPlayerM3UViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Masonry.h>
#import "M3U8Server.h"
#import "ZBLM3u8Manager.h"

@interface AVPlayerM3UViewController ()
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (strong, nonatomic) UIView *playerView;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) AVPlayerViewController *playerVC;


@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation AVPlayerM3UViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setupAVPlayerViewController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[ZBLM3u8Manager shareInstance]  tryStartLocalService];
            [[M3U8Server shared] setupHTTPServer];
            [self playWithUrlString:@"http://127.0.0.1:8080/58b20e07c35ab638a3a19c397e498e51/movie.m3u8"];
        });
    });
    
}

- (void)setupAVPlayerViewController {
    
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];

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

- (IBAction)buttonPlayClick:(UIButton *)sender {
//    if (!self.playerVC.player) {
//        NSString *playUrl = @"http://127.0.0.1:12345/58b20e07c35ab638a3a19c397e498e51/movie.m3u8";
//        NSURL *videoUrl = [NSURL URLWithString:playUrl];
//        self.playerVC.player = [[AVPlayer alloc]initWithURL:videoUrl];
//    }
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [self.playerVC.player play];
//    }else{
//        [self.playerVC.player pause];
//    }

}

static int avCount = 0;
- (void)playWithUrlString:(NSString *)urlStr
{
    NSLog(@"playUrlString:%@",urlStr);
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 9.0 / 16.0);
    self.playerView = [[UIView alloc] initWithFrame:self.videoView.bounds];
    self.playerView.backgroundColor = [UIColor blackColor];
    [self.playerView.layer addSublayer:self.playerLayer];
    [self.videoView addSubview:self.playerView];
    [self.player play];
    avCount ++;
}


- (IBAction)progressChange:(UISlider *)sender {
    
}
- (IBAction)volumeChange:(UISlider *)sender {
    
}


@end
