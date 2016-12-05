//
//  BYAnnotationView.h
//  Microto
//
//  Created by Blueyang on 14-12-5.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapPoint;


@interface BYAnnotationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;



@property (strong, nonatomic)MapPoint * mapPoint;

+(instancetype)viewWithMapPoint:(MapPoint *)mapPoint;
@end
