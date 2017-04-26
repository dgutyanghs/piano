//
//  TableViewController.m
//  日本二手钢琴大全
//
//  Created by Blueyang on 14-10-22.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
// 分组失败

#import "DisplayViewController.h"
#import "piano.h"
#import "pianoCell.h"
#import "PianoDetailViewController.h"
#import "MJExtension.h"
#import "UIImage+MJ.h"
#import "HLPictureScrollView.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "HZPhotoBrowser.h"
#import "HZPhotoGroup.h"
#import "HZPhotoItem.h"



@interface DisplayViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, HLPictureScrollViewDelegte,HZPhotoBrowserDelegate>

//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *newses;
//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *pianosA;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,weak ) UISearchBar * searchBar;
@property (nonatomic, strong) piano *pianoDetail;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (assign, nonatomic, getter=isSectionIndexTitleShow) BOOL sectionIndexTitleShow;
@property (weak, nonatomic) IBOutlet UIView *containView;


@property (nonatomic , strong) NSMutableArray *slideImages;
@property (nonatomic , strong) HLPictureScrollView *slideView;
@property (nonatomic, strong) NSMutableArray *imagesUrls;

@end


@implementation DisplayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"中古钢琴";
    self.sectionIndexTitleShow = YES;
    
    self.pianosA = (NSMutableArray *)[self DataSourceInit];
    
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    
    self.searchBar.placeholder = @"查询钢琴型号或品牌";
    self.searchBar.delegate  = self;
    
    
//    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"girlPiano3.png"]];
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background4.png"]];
    self.tableView.backgroundView = backView;
    
   
    [self setupRefresh];
    
    [self loadPianosPictures];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containViewDidTap:)];
    [self.containView addGestureRecognizer:tap];
    
//    [self testDownImageByAFNetworking];
}

-(void)loadPianosPictures  {
    HLHttpClient *httpClient = [HLHttpClient sharedInstance];
    
    __weak __typeof(self) weakSelf = self;
    [httpClient post:@"/hotnews" parameters:nil success:^(NSDictionary * responseObject) {
        NSLog(@"response:%@", responseObject.debugDescription);
        NSArray *datas = responseObject[@"pianonews"];
        
        NSMutableArray <NSString *> *imagesUrl = [NSMutableArray array];
        for (NSDictionary *dict in datas) {
            NSString *urlStr = dict[@"icon"];
            [imagesUrl addObject:urlStr];
        }
        self.imagesUrls = [imagesUrl mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.slideView removeFromSuperview];
            CGRect slideFrame = CGRectMake(0, 0, self.containView.width, self.containView.height);
            _slideView = [HLPictureScrollView viewWithFrame:slideFrame andImagesUrl:imagesUrl viewDisplayMode: UIViewContentModeScaleToFill];
            _slideView.delegate = weakSelf;
            [weakSelf.containView addSubview:_slideView];
            [_slideView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(44, 0, 0, 0)];
            [weakSelf.slideView setNeedsDisplay];
        });
    } fail:^(NSString *error) {
        NSLog(@"err:%@", error);
    }];
    
}

-(void)containViewDidTap:(UITapGestureRecognizer *)tap {
    HLHttpClient *httpClient = [HLHttpClient sharedInstance];
    
    __weak __typeof(self) weakSelf = self;
    [httpClient post:@"/hotnews" parameters:nil success:^(NSDictionary * responseObject) {
        NSLog(@"response:%@", responseObject.debugDescription);
        NSArray *datas = responseObject[@"data"];
        
        NSMutableArray *imagesUrl = [NSMutableArray array];
        for (NSDictionary *dict in datas) {
            NSString *urlStr = dict[@"icon"];
            [imagesUrl addObject:urlStr];
        }
        
        self.imagesUrls = [imagesUrl mutableCopy];
        
//        self.slideImages = [temp mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.slideView removeFromSuperview];
            CGRect slideFrame = CGRectMake(0, 0, self.containView.width, self.containView.height);
            _slideView = [HLPictureScrollView viewWithFrame:slideFrame andImagesUrl:imagesUrl viewDisplayMode: UIViewContentModeScaleAspectFit];
            [weakSelf.containView addSubview:_slideView];
            [weakSelf.slideView setNeedsLayout];
            [weakSelf.slideView setNeedsDisplay];
        });
    } fail:^(NSString *error) {
        NSLog(@"err:%@", error);
    }];
        
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    HLHttpClient *httpClient = [HLHttpClient sharedInstance];
    [httpClient post:nil parameters:nil success:^(id responseObject) {
        
    } fail:^(NSString *error) {
        
    }];
    

}


/**
 *  显示下载了多少条数据
 *
 *  @param count 数据条目
 */
- (void)showNewStatusCount:(int)count
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // below : 下面  btn会显示在self.navigationController.navigationBar的下面
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
//    [self.view addSubview:btn ];
    
    // 2.设置图片和文字
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (count) {
        NSString *title = [NSString stringWithFormat:@"共有%d个新的钢琴", count];
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"没有新的钢琴数据" forState:UIControlStateNormal];
    }
    
    // 3.设置按钮的初始frame
    CGFloat btnH = 30;
    CGFloat btnY = 64 - btnH;
    CGFloat btnX = 2;
    CGFloat btnW = self.view.frame.size.width - 2 * btnX;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
//    NSLog(@" %f, %f, %f, %f", btnX, btnY, btnW, btnH);
    // 4.通过动画移动按钮(按钮向下移动 btnH + 1)
    [UIView animateWithDuration:0.7 animations:^{
        btn.transform = CGAffineTransformMakeTranslation(0, btnH + 2);
    } completion:^(BOOL finished) { // 向下移动的动画执行完毕后
        
        // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
        [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 将btn从内存中移除
            [btn removeFromSuperview];
        }];
        
    }];
}

-(NSArray *)DataSourceInit
{
    return [piano pianoArrayByLogo];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.pianosA.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[self.pianosA objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID  = @"PianoCell";
    pianoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[pianoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];

    }
    
    cell.textLabel.text = [[_pianosA[indexPath.section] objectAtIndex:indexPath.row]model];
    cell.detailTextLabel.text = [[_pianosA[indexPath.section] objectAtIndex:indexPath.row] logo];
//    cell.detailTextLabel.textColor = [UIColor colorWithRed:88/255.0 green:149/255.0 blue:217/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor greenColor];
    cell.detailTextLabel.textColor = [UIColor purpleColor];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

/**
 每组开头的title显示 内容
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headTitle = nil;
    if (self.pianosA.count <= 1) {
        headTitle = [NSString stringWithFormat:@"查找结果 :(%lu 个型号）", (unsigned long)[self.pianosA[section] count]];
    }else {
        headTitle = [piano pianoLogoName:section];
        headTitle = [headTitle stringByAppendingFormat:@" (%lu 个型号)", (unsigned long)[self.pianosA[section] count]];
    }
    return headTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor redColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor cyanColorHL_New];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.textColor = [UIColor cyanColorHL_New];
}


-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if ([self.pianosA[section] count] == 0) {
        return nil;
    }
    
    if (self.pianosA.count > 1) {
        footer = [[self.pianosA[section] objectAtIndex:0] valueForKey:@"company"];
        footer = [footer stringByAppendingFormat:@"\n\n"];
    } else {
        footer = nil;
    }
    return footer;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSectionIndexTitleShow) {
        NSMutableArray <NSString *> *logosHeader = [NSMutableArray array];
        NSArray <NSString *> *logos =   [piano pianoLogos];
        
        for (NSString *name in logos) {
            NSString *firstLetter = [name substringWithRange:NSMakeRange(0, 1)];
            [logosHeader addObject:firstLetter];
        }
        
        return logosHeader;
        
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
           [self.searchBar resignFirstResponder];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _pianoDetail = [[piano alloc]init];
    _pianoDetail = [_pianosA[indexPath.section] objectAtIndex:indexPath.row];
     
    [self performSegueWithIdentifier:@"PianoDetailViewController" sender:nil];
}


#pragma mark - UISearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.pianosA removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        self.pianosA = (NSMutableArray *)[self DataSourceInit];
        self.sectionIndexTitleShow = YES;
    }else {
        self.pianosA = (NSMutableArray *)[piano pianoSearchRet:searchText];
        self.sectionIndexTitleShow = NO;
    }
    [self.tableView reloadData];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PianoDetailViewController"]) {

        PianoDetailViewController *pianoDetailVC = segue.destinationViewController;
        pianoDetailVC.pianoDetail = self.pianoDetail;
    }
    
}



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark -  Picture Delegate
-(void)pictureScrollImageViewDidTap:(int)index {
    //启动图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
//    browser.sourceImagesContainerView = self.slideView.scrollView; // 原图的父控件
    browser.sourceImagesContainerView = nil; // 原图的父控件
    browser.imageCount = self.imagesUrls.count; // 图片总数
    browser.currentImageIndex = index;
    browser.delegate = self;
    [browser show];
 
}


- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imagesUrls[index]];
    return image;
}


- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    NSString *str =  self.imagesUrls[index];
    NSURL *url = [NSURL URLWithString:str];
    return url;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
//- (BOOL)shouldAutorotate {
//    return NO;
//}

//just a test, nothing
- (void)testDownImageByAFNetworking {
    HLHttpClient *client = [HLHttpClient sharedInstance];
    [client getImage:nil parameters:nil success:^(id responseObject) {
        NSLog(@"success");
//        NSData *data = (NSData *)responseObject;
//        UIImage *image = [UIImage imageWithData:data];
        UIImage *image = (UIImage *)responseObject;
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
//        imageV.size = image.size;
        imageV.frame = CGRectMake(100, 100, image.size.width, image.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView addSubview:imageV];
        });
    } fail:^(NSString *error) {
        NSLog(@"error");
    }];
}

@end
