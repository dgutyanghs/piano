//
//  JsonModel.m
//  Used Piano
//
//  Created by Blueyang on 15-1-28.
//  Copyright (c) 2015年 Blueyang. All rights reserved.
//

#import "JsonModel.h"


@implementation JsonModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"location":[Location class]
             };
}
@end
