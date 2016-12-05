//
//  JsonModel.h
//  Used Piano
//
//  Created by Blueyang on 15-1-28.
//  Copyright (c) 2015年 Blueyang. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BMapKit.h"

#import "Location.h"

@interface JsonModel : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) Location  *location;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *uid;


+(NSDictionary *)objectClassInArray;
@end
