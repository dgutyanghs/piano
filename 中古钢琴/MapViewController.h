//
//  MapViewController.h
//  Microto
//
//  Created by Blueyang on 14-11-13.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BMapKit.h"
//#import "BMKBaseComponet.h"
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件


@interface MapViewController : UIViewController <BMKLocationServiceDelegate, BMKMapViewDelegate, BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (strong, nonatomic) NSNumber *cmd;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (copy, nonatomic) NSString *pointTitle;

- (IBAction)locatieMyself:(id )sender;


@end
