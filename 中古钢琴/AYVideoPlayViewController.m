//
//  AYVideoPlayViewController.m
//  UsedPiano
//
//  Created by AlexYang on 17/3/23.
//  Copyright © 2017年 Blueyang. All rights reserved.
//

#import "AYVideoPlayViewController.h"
#import "XLVideoPlayer.h"
#import "XLVideoItem.h"

@interface AYVideoPlayViewController ()
@property (nonatomic, strong) XLVideoPlayer *player;
@end

@implementation AYVideoPlayViewController

- (XLVideoPlayer *)player {
    if (!_player) {
        _player = [[XLVideoPlayer alloc] init];
        _player.frame = CGRectMake(0, 64, self.view.frame.size.width, 250);
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.videoItem.title;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.player.videoUrl = self.videoItem.mp4_url;
    [self.view addSubview:self.player];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.player destroyPlayer];
    self.player = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
