//
//  MapPoint.h
//  Microto
//
//  Created by Blueyang on 14-12-5.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MapPoint : NSObject <NSCoding>


@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D location;

+(MapPoint *)pointWithTitle:(NSString *)title Location:(CLLocationCoordinate2D )location;
+(void)saveMapPoint:(MapPoint *)point;

//保存地图退出时的中点
+(void)saveMapCenterPoint:(MapPoint *)point;
+(instancetype)readMapCenterPoint;
+(NSArray *)allMapPoint;
@end
