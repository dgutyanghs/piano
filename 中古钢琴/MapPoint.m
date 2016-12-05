//
//  MapPoint.m
//  Microto
//
//  Created by Blueyang on 14-12-5.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import "MapPoint.h"


static NSMutableArray *_mapPointM = nil;
static NSString *mapCenterPoint = @"地图中点";

@implementation MapPoint


+(MapPoint *)pointWithTitle:(NSString *)title Location:(CLLocationCoordinate2D)location
{
    MapPoint *point = [[MapPoint alloc]init];
    point.title = title;
    point.location = location;
//    point.date = nil;
    return point;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"title"];
        NSData *data = [coder decodeObjectForKey:@"location"];
        CLLocationCoordinate2D location;
        [data getBytes:&location length:sizeof(location)];
        self.location = location;
//        self.date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"title"];

    CLLocationCoordinate2D  location = self.location;

    NSData *data = [NSData dataWithBytes:&location length:sizeof(location)];
    [coder encodeObject:data forKey:@"location"];
//    [coder encodeObject:self.date forKey:@"date"];

}
+(void)deleteMapPoint:(MapPoint *)point
{
    if (point == nil || _mapPointM == nil) {
        return;
    }
    
    [_mapPointM removeObject:point];
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"poi.data"];
    
    [NSKeyedArchiver archiveRootObject:_mapPointM toFile:path];;
}

+(void)saveMapPoint:(MapPoint *)point
{
    if (point == nil) return;
    
    if (_mapPointM == nil) {
        _mapPointM = [NSMutableArray array];
    }
#warning this can not jude to same point in the array
    if ([_mapPointM containsObject:point]) {
        return;
    }
//    point.date = [NSDate date];
    [_mapPointM insertObject:point atIndex:0];
//    NSLog(@"_mapPointM %@", _mapPointM);
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"poi.data"];
    
    [NSKeyedArchiver archiveRootObject:_mapPointM toFile:path];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"mapPointAdd" object:nil];
    
}

+(void)saveMapCenterPoint:(MapPoint *)point
{
   if (point == nil) return;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:mapCenterPoint];
    [NSKeyedArchiver archiveRootObject:point toFile:path];
}

+(instancetype)readMapCenterPoint
{

    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:mapCenterPoint];
    MapPoint *point = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return point;
}

+(NSArray *)allMapPoint
{
//    NSArray *reverArray ;
    if (_mapPointM == nil) {
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [doc stringByAppendingPathComponent:@"poi.data"];
        
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
//        for (MapPoint *point in array) {
//            NSLog(@"title %@", point.title);
//        }
        _mapPointM = [NSMutableArray arrayWithArray:array];
        _mapPointM = (NSMutableArray *)[[_mapPointM reverseObjectEnumerator ]allObjects];
//        [_mapPointM reverseObjectEnumerator];
    }

    return _mapPointM;
}


@end
