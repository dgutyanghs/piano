//
//  AYVideoViewController.m
//  UsedPiano
//
//  Created by AlexYang on 17/3/8.
//  Copyright © 2017年 Blueyang. All rights reserved.
//

#import "AYVideoViewController.h"
#import "AYPlayViewController.h"
#import "XLVideoPlayer.h"
#import "XLVideoItem.h"
#import "XLVideoCell.h"
#import "AYVideoPlayViewController.h"
#import "MJExtension.h"
#import "SURefreshHeader.h"
#import "ISMessages+Alex.h"

@interface AYVideoViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *_indexPath;
    XLVideoPlayer *_player;
    CGRect _currentPlayCellRect;
}


@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoArray;
@end

@implementation AYVideoViewController


- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player destroyPlayer];
    _player = nil;
}


#pragma mark - network

- (void)fetchVideoListData {
    
    __weak typeof(self) weakSelf = self;
    HLHttpClient *client = [HLHttpClient sharedInstance];
    
    [client post:@"/videoinfo" parameters:nil success:^(NSDictionary * responseObject) {
        NSLog(@"videoinfo:%@", responseObject.debugDescription);
        NSArray *videolist = responseObject[@"videoslist"];
        if (videolist.count) {
            _videoArray = [XLVideoItem mj_objectArrayWithKeyValuesArray:videolist];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.header endRefreshing];
            });
        }
        
    } fail:^(NSString *error) {
        NSLog(@"videoinfo error:%@", error.debugDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            [ISMessages showErrorMsg:@"网络不通" title:@"请稍后再试"];
            [weakSelf.tableView.header endRefreshing];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频列表";
    
    [self fetchVideoListData];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
//    [tableView configureForAutoLayout ];
    tableView.dataSource = self;
    tableView.delegate  = self;
    tableView.estimatedRowHeight = 208;
    tableView.rowHeight = 208;
    
    __weak __typeof(self) weakSelf = self;
    [tableView addRefreshHeaderWithHandle:^{
        NSLog(@"add refresh header");
        [weakSelf fetchVideoListData];
    }];
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
    
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self alertUserWhenNewworkInWWanStatus];
}

- (void)alertUserWhenNewworkInWWanStatus {
    
    HLHttpClient *client = [HLHttpClient sharedInstance];
    if (client.isNetworkReachableViaWWAN) {
        [ISMessages showResultMsg:@"在线视频会产生流量费用,请到WiFi下观看视频, 土豪随意!" title:@"移动蜂窝网数据"Status:ISAlertTypeWarning];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    
    UIView *view = tapGesture.view;
    XLVideoItem *item = self.videoArray[view.tag - 100];

    _indexPath = [NSIndexPath indexPathForRow:view.tag - 100 inSection:0];
    XLVideoCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    
    _player = [[XLVideoPlayer alloc] init];
    _player.videoUrl = item.mp4_url;
    [_player playerBindTableView:self.tableView currentIndexPath:_indexPath];
    _player.frame = cell.videoImageView.frame;

    [cell.contentView addSubview:_player];  
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        [player destroyPlayer];
        _player = nil;
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLVideoCell *cell = [XLVideoCell videoCellWithTableView:tableView];
    XLVideoItem *item = self.videoArray[indexPath.row];
    cell.videoItem = item;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
//    [cell.videoImageView addGestureRecognizer:tap];
//    cell.videoImageView.tag = indexPath.row + 100;
    [cell.playImage addGestureRecognizer:tap];
    cell.playImage.tag = indexPath.row + 100;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLVideoItem *item = self.videoArray[indexPath.row];
    AYVideoPlayViewController *playVc = [[AYVideoPlayViewController alloc] init];
    playVc.videoItem = item;
    [self.navigationController pushViewController:playVc animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        
        [_player playerScrollIsSupportSmallWindowPlay:YES];
    }
}

@end
