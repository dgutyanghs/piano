//
//  BaiduViewController.m
//  Used Piano
//
//  Created by Blueyang on 15-1-28.
//  Copyright (c) 2015年 Blueyang. All rights reserved.
//

#import "BaiduViewController.h"
#import "MJExtension.h"
#import "JsonModel.h"
#import "TableViewCell.h"
#import "MapPoint.h"


@interface BaiduViewController () <UITableViewDataSource,UITableViewDelegate, BMKLocationServiceDelegate >
{
    BMKLocationService *_locService;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayDataM;
@property (assign, nonatomic) CLLocationCoordinate2D userCoordinate;
//@property (strong, nonatomic) JsonModel *model;
@property (copy, nonatomic) NSString *userCity;
@property (assign, nonatomic) NSInteger pageNum;

@end

@implementation BaiduViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.placeholder = @"琴行";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _arrayDataM = [NSMutableArray array];
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GirlPiano.jpg"]];
    self.tableView.backgroundView = backView;
    
    [self _addFooterRefresh];
    [self _locationMyself];
    
    self.pageNum = 0;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 130;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.tableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;


}



-(void)_locationMyself
{
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [BMKLocationService setLocationDistanceFilter:100.0f];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    [_locService startUserLocationService];
    
}

-(void)_addFooterRefresh
{
//    [self.tableView.mj_footer footerWithRefreshingTarget:self selc]
//    [self.tableView.mj_footer addFooterWithTarget:self action:@selector(_footerRereshing)];
//    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    self.tableView.footerRefreshingText = @"努力加载中...";
}

- (void)_footerRereshing
{
    // 1.添加数据
    [self getJsonInfor:self.searchBar.placeholder InCity:self.userCity PageNum:++(self.pageNum)];
    
//    [self.tableView footerEndRefreshing];

}


#pragma mark - Baidu Map Location
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    [MBProgressHUD showMessage:@"正在加载数据"];
    [_locService stopUserLocationService];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"userLocation" object:self userInfo:@{@"userLocation":userLocation}];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.userCoordinate = userLocation.location.coordinate;
//    [self.tableView footerBeginRefreshing];
    [self geoCoding:self.userCoordinate];
}

-(void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@, location fail", error);
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"定位失败" message:@"请开启定位服务:设置 > 隐私 > 位置 > 定位 > 中古钢琴" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
}


#pragma - mark tableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"row %d, section %d", indexPath.row, indexPath.section);
    TableViewCell  *cell = [TableViewCell cellWithTableView:tableView];
    cell.js = _arrayDataM[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDataM.count;
}

#pragma -mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cellDelegate respondsToSelector:@selector(recentViewCellDidSelect:)]) {
        JsonModel *jm = [[JsonModel alloc]init];
       jm =  _arrayDataM[indexPath.row];
       CLLocationDegrees lat = [jm.location.lat doubleValue];
       CLLocationDegrees lng = [jm.location.lng doubleValue];
        CLLocationCoordinate2D loc;
        loc.latitude = lat;
        loc.longitude = lng;
        MapPoint *point = [MapPoint pointWithTitle:jm.name Location:loc];
        
        [self.cellDelegate recentViewCellDidSelect:point];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)geoCoding:(CLLocationCoordinate2D)coordinate
{
    NSString *str = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=0WKlYEhudtiwmG6SeWqgLaan&mcode=blue.Used-Piano&location=%f,%f&output=json&pois=0", coordinate.latitude, coordinate.longitude];
    
    NSString *strEncode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strEncode];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            NSError *error =[[NSError alloc]init];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSString * city = [dict valueForKeyPath:@"result.addressComponent.city"];
            self.userCity = city;

//            NSLog(@"city is %@", city);
            [self getJsonInfor:self.searchBar.placeholder InCity:city PageNum:self.pageNum];
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUD];
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"中古钢琴" message:@"网络不通！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
            });

            NSLog(@"error %@", connectionError);
        }
    }];
}

-(void)getJsonInfor:(NSString *)keyword InCity:(NSString *)city PageNum:(NSInteger) pageNum
{
    if (city == nil) {
//        [_locService stopUserLocationService];
//        [_locService startUserLocationService];
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"中古钢琴" message:@"网络不通！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
        return;
    }
    

    
    NSString *str = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?ak=0WKlYEhudtiwmG6SeWqgLaan&mcode=blue.Used-Piano&output=json&query=%@&page_size=20&scope=1&region=%@&page_num=%li", keyword, city, (long)pageNum];
    NSString *strEncode = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strEncode];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            NSError *error =[[NSError alloc]init];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//            NSLog(@"dict %@", dict);

            
            NSNumber *total = [dict valueForKey:@"total"];
            NSArray * array = [dict valueForKey:@"results"];
            
//            NSLog(@"array %@", array);
//
            
            NSArray *userArray = [JsonModel objectArrayWithKeyValuesArray:array];
            
            for (JsonModel * model in userArray) {
                [_arrayDataM addObject:model];
                
//                Location *loc = model.location;
//                NSLog(@"model.name %@, %@, %f, %f", model.name, model.address, [loc.lat floatValue], [loc.lng floatValue]);
            }

            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([total integerValue] > 0) {
                    [self.tableView reloadData];
                    NSIndexPath *index = [NSIndexPath indexPathForRow:20 * pageNum -1  inSection:0]; //page_size * page_num - 1
                    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                    [MBProgressHUD hideHUD];
               
                }else {
//                    [MBProgressHUD hideHUD];
                    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"中古钢琴" message:@"已没有更多的数据可加载！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [view show];
                }
            });
            
            
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUD];
                //            NSLog(@"connection error = %@", connectionError);
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"中古钢琴" message:@"网络不通！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
            });

            
        }
        
            
        
    }];
    
}

@end
