//
//  piano.h
//  日本二手钢琴大全
//
//  Created by Blueyang on 14-10-22.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
// 

#import <Foundation/Foundation.h>

@interface piano : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *hight;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString  *length;
@property (nonatomic, copy) NSString  *height;
@property (nonatomic, copy) NSString *since;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *selection;
@property (nonatomic, copy) NSString *remarks;


//+(NSArray *)pianoInit;
+(NSArray *)pianoSearchRet:(NSString *)searchText;
+(NSInteger)pianoLogoCount;
+(NSString *)pianoLogoName:(NSInteger)section;


+(NSArray *)pianoArrayByLogo;
+(NSArray *)pianoLogos;
//+(instancetype)pianoInit;
@end
