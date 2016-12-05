//
//  MapViewController.m
//  Microto
//
//  Created by Blueyang on 14-11-13.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import "MapViewController.h"
#import "BYAnnotationView.h"
#import "MapPoint.h"


@interface MapViewController ()
{
        BMKPoiSearch* _poisearch;
    BMKGeoCodeSearch* _geocodesearch;
    int curPage;
    NSMutableArray *_poiArrayM;
    
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mapView.mapType = BMKMapTypeStandard;
//    _mapView.compassPosition = CGPointMake(20, 100);

    _mapView.userTrackingMode   = BMKUserTrackingModeNone;
    _poisearch = [[BMKPoiSearch alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];


//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedUserLocation:) name:@"userLocation" object:nil];

}

-(void)receivedUserLocation:(NSDictionary *)dict
{
    NSLog(@"dict %@",dict);
}

-(void)recoverLastPosition
{
//    MapPoint *point = [MapPoint readMapCenterPoint];
//    NSLog(@"point is %@ %f %f", point.title, point.location.latitude, point.location.longitude);
//    if (point != nil) {
    
//        self.location = point.location;
//        [_mapView setCenterCoordinate:self.location animated:YES];
//        BMKCoordinateSpan span = BMKCoordinateSpanMake(0.050035, 0.050035);
//        BMKCoordinateRegion region = BMKCoordinateRegionMake(self.location, span);
//        
//        [_mapView setRegion:region animated:YES];
//    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    [_mapView viewWillAppear];
   
    _poisearch.delegate = self;
    _geocodesearch.delegate = self;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([self.cmd isEqual:@1]) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = self.location;
        item.title = self.pointTitle;
        
        [_mapView addAnnotation:item];
        
        // put the point in the map center
        [_mapView setCenterCoordinate:self.location animated:YES];
        
        BMKCoordinateSpan span = BMKCoordinateSpanMake(0.01, 0.01);
        BMKCoordinateRegion region = BMKCoordinateRegionMake(self.location, span);
        [_mapView setRegion:region animated:YES];


    }


}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];


    [_mapView viewWillDisappear];
    _mapView.delegate   = nil;
    _poisearch.delegate = nil;
    _geocodesearch.delegate = nil;
    
    self.cmd = nil;

}
#pragma mark baidu map location delegate
- (void)willStartLocatingUser
{
    NSLog(@"will start location user");
}

- (void)didStopLocatingUser
{
    NSLog(@"did stop location user");
    //        _mapView.showsUserLocation = NO;
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"!error %@",error);
}





- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation %@", userLocation.location);
    [_mapView updateLocationData:userLocation];
    
//    CLLocationCoordinate2D center = userLocation.location.coordinate;
//    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.050035, 0.050035);
//    BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
//    
//    [_mapView setRegion:region animated:YES];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //    NSLog(@"%f, %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
}

- (IBAction)locatieMyself:(UIButton *)sender
{
//    [_locService startUserLocationService];
//    _mapView.showsUserLocation  = NO;
//    _mapView.userTrackingMode   = BMKUserTrackingModeNone;
//    _mapView.showsUserLocation  = YES;
//   [_mapView updateLocationData:<#(BMKUserLocation *)#>]
}







#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}



//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView =[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] ;
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        
        
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        annotationView.canShowCallout = TRUE;
        annotationView.alpha = 1;

        
        MapPoint *mapPoint = [[MapPoint alloc]init];
        mapPoint.title = annotation.title;
        mapPoint.location = annotation.coordinate;
//           NSLog(@"title %@, long %f, lat %f", mapPoint.title, mapPoint.location.longitude, mapPoint.location.latitude);
        
        BYAnnotationView *customView = [BYAnnotationView viewWithMapPoint:mapPoint];
        BMKActionPaopaoView *test = [[BMKActionPaopaoView alloc]initWithCustomView:customView];
        test.alpha = 1;
        ((BMKPinAnnotationView *)annotationView).paopaoView = test;
        ((BMKPinAnnotationView *)annotationView).paopaoView.alpha = 1;
    }
    

    return annotationView;
}









#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
//    NSLog(@"you clicked blank at %f, %f", coordinate.latitude, coordinate.longitude);
}


- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
//        NSLog(@"you clicked POI at %@ %f, %f", mapPoi.text, mapPoi.pt.longitude, mapPoi.pt.latitude);

    
}

//
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"bubble");
}


/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
        NSLog(@"didSelectAnnotationView");
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
        NSLog(@"didDeselectAnnotationView");
}

@end
