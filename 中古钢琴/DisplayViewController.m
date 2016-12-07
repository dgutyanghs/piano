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
#import "MJNews.h"
#import "MJNewsCell.h"
#import "MJExtension.h"
#import "UIImage+MJ.h"



@interface DisplayViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)NSArray *newses;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *pianosA;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,weak ) UISearchBar * searchBar;
@property (nonatomic, strong) piano *pianoDetail;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (assign, nonatomic, getter=isSectionIndexTitleShow) BOOL sectionIndexTitleShow;




@end


@implementation DisplayViewController

-(NSArray *)newses
{
    if (!_newses) {
        self.newses = [MJNews objectArrayWithFilename:@"newses_yang.plist"];
//        self.newses = [MJNews objectArrayWithFilename:@"newses.plist"];
    }
    return _newses;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pianosA = (NSMutableArray *)[self DataSourceInit];

    
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    
    
    self.searchBar.placeholder = @"查询钢琴型号或品牌";
    self.searchBar.delegate  = self;
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"girlPiano3.png"]];
    self.tableView.backgroundView = backView;
    
    // 注册cell
    if (IS_IPAD) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"MJNewsCellPad" bundle:nil] forCellWithReuseIdentifier:@"newsIpad"];
    }else {
        [self.collectionView registerNib:[UINib nibWithNibName:@"MJNewsCell" bundle:nil] forCellWithReuseIdentifier:@"news"];
    }

    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2500 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.title = @"中古钢琴";
    self.SectionIndexTitleShow = YES;
    
    [self setupRefresh];
  
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRerfeshing)];

}

#pragma mark 开始进入刷新状态
- (void)headerRerfeshing
{

    NSURL *url = [NSURL URLWithString:@"http://taobao.com"];

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:5.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.tableView reloadData];
                
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.tableView.mj_header endRefreshing];
                [self showNewStatusCount:0];
            });
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
               UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"网络不给力" message:@"请检查网络是否连接?" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alter.alpha = 0.6;
                alter.tintColor = [UIColor purpleColor];
                [alter show];
            });

        }

    } ];

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
//    return  [piano pianoInit];
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
    cell.detailTextLabel.text = [[_pianosA[indexPath.section] objectAtIndex:indexPath.row]logo];
//    cell.imageView.image = [UIImage imageNamed:@"CellLogo.jpg"];
    
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
//    NSLog(@"search bar text %@", _SearchBar.text);
    if (self.isSectionIndexTitleShow) {
           return [piano pianoLogos];
    }else {
        return nil;
    }

}

#pragma mark - UITableViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scroll....");
    if ([scrollView isEqual:self.tableView]) {
           [self.searchBar resignFirstResponder];
    }

    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"_pianoDetail = %@", _pianoDetail);
    _pianoDetail = [[piano alloc]init];
    _pianoDetail = [_pianosA[indexPath.section] objectAtIndex:indexPath.row];
//    NSLog(@"sel %d, %d model %@, logo %@", indexPath.section, indexPath.row, _pianoDetail.model, _pianoDetail.logo);
    
    [self performSegueWithIdentifier:@"PianoDetailViewController" sender:nil];
}


#pragma mark - UISearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    NSLog(@"searchText = %@", searchText);

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
//    NSLog(@"search click");
    [self.searchBar resignFirstResponder];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PianoDetailViewController"]) {


        PianoDetailViewController *pianoDetailVC = segue.destinationViewController;
        pianoDetailVC.pianoDetail = self.pianoDetail;

//        NSLog(@"prepare  pianoDetailVC %@", pianoDetailVC);

    }
    
}

#pragma mark - collectionview
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newses.count * 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"news";
    if (IS_IPAD) {
        ID = @"newsIpad";
    }
    
    MJNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSLog(@"collection cell %f, %f", cell.bounds.size.width, cell.bounds.size.height);
//    NSLog(@"index = %li", (long)indexPath.item);
    cell.news = self.newses[indexPath.item % self.newses.count];
    self.pageControl.currentPage = [cell.news.index integerValue];
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger i = indexPath.item % self.newses.count;
//    self.pageControl.currentPage = i;
//}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
