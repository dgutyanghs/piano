//
//  BYAnnotationView.m
//  Microto
//
//  Created by Blueyang on 14-12-5.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import "BYAnnotationView.h"
#import "MapPoint.h"
//#import "BMapKit.h"

@implementation BYAnnotationView

-(void)awakeFromNib
{
    
}





+(instancetype)viewWithMapPoint:(MapPoint *)mapPoint
{
    BYAnnotationView *view =[[[NSBundle mainBundle]loadNibNamed:@"BYAnnotationView" owner:nil options:nil] lastObject];
//    view.alpha = 1;
    view.mapPoint = mapPoint;
    return view;
}

-(void)setMapPoint:(MapPoint *)mapPoint
{
    
    _mapPoint = mapPoint;
    self.title.text = mapPoint.title;
    

}

@end
