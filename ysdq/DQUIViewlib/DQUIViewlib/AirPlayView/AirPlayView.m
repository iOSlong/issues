//
//  AirPlayView.m
//  DQUIViewlib
//
//  Created by lxw on 2018/8/16.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AirPlayView.h"

@interface AirPlayView()
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UILabel *labelTitle;
@end


@implementation AirPlayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _disableAirPlayResponse = NO;
        [self setupUIItems];
        //        [self showBorderLine];
    }
    return self;
}

- (void)setupUIItems {
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)]];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:self.bounds];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    self.labelTitle.text = @"AirPlay";
    [self setIsLandscape:NO];
    [self addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeView = volumeView;
    [self.volumeView setRouteButtonImage:nil forState:UIControlStateNormal];
    [self.volumeView setShowsVolumeSlider:NO];
    [self addSubview:self.volumeView];
    [self.volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
        make.edges.equalTo(self);
    }];
    
    UIButton *mpButton = nil;
    
    for (UIButton *button in self.volumeView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            mpButton = button;
            [button addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
            break;
        }
    }
    [mpButton addTarget:self action:@selector(airplayButtonTouchInSide:) forControlEvents:UIControlEventTouchUpInside];
    [mpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mpButton.superview);
    }];

    
   
}
- (void)setDisableAirPlayResponse:(BOOL)disableAirPlayResponse {
    _disableAirPlayResponse = disableAirPlayResponse;
    [self.volumeView setHidden:disableAirPlayResponse];
    self.volumeView.userInteractionEnabled = !disableAirPlayResponse;
}
- (void)setIsLandscape:(BOOL)isLandscape {
    _isLandscape = isLandscape;
    self.labelTitle.font = [UIFont systemFontOfSize:17];
    self.labelTitle.textColor = [UIColor purpleColor];
}
- (void)setTitle:(NSString *)title {
    if (![_title isEqualToString:title]) {
        _title = title;
        self.labelTitle.text = title;
    }
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.labelTitle.font = titleFont;
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.labelTitle.textColor = titleColor;
}
- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imageView setImage:image];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[UIButton class]] ) {
        if([[change valueForKey:NSKeyValueChangeNewKey] intValue] == 1){
//            [(UIButton *)object setBounds:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        } else {
            self.volumeView.hidden = NO;
            [object setAlpha:1];
        }
    }
}

- (void)airplayButtonTouchInSide:(UIButton *)btn {
    NSLog(@"mptouchinside");
    if (self.tapClick) {
        self.tapClick(2);
    }
}

- (void)viewTap:(UITapGestureRecognizer *)tapG {
    if (self.tapClick) {
        self.tapClick(1);
    }
}

- (void)dealloc {
    for (UIButton *button in _volumeView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeObserver:self forKeyPath:@"alpha"];
        }
    }
}

@end
