//
//  piano.m
//  日本二手钢琴大全
//
//  Created by Blueyang on 14-10-22.
//  Copyright (c) 2014年 Blueyang. All rights reserved.
//

#import "piano.h"
#import "FMDB.h"

@interface piano()

@end


static FMDatabase *db = nil;
static  NSMutableArray *pianosA= nil;
static  NSMutableArray *arrayLogos = nil;

@implementation piano



+(NSArray *)pianoSearchRet:(NSString *)searchText
{
    NSMutableArray *pianoSelect = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from JapanUsedPiano_copy where  model like '%@%%' or logo like '%@%%' order by logo;",  searchText, searchText];
    
    //  NSLog(@"sql is %@", sql);

    FMResultSet *rs = [db executeQuery:sql];
    while (rs.next) {
        piano *p = [[piano alloc]init];
        
        p.ID        = [rs intForColumn:@"id"];
        p.company   = [rs stringForColumn:@"company"];
        p.logo      = [rs stringForColumn:@"logo"];
        p.model     = [rs stringForColumn:@"model"];
        p.hight     = [rs stringForColumn:@"hight"] ;
        p.width     = [rs stringForColumn:@"width"];
        p.length    = [rs stringForColumn:@"length"];
        p.height    = [rs stringForColumn:@"height"];
        p.since     = [rs stringForColumn:@"since"];
        p.end       = [rs stringForColumn:@"end"];
        p.price     = [rs stringForColumn:@"price"];
        p.kind      = [rs stringForColumn:@"kind"];
        p.color     = [rs stringForColumn:@"color"];
        p.selection = [rs stringForColumn:@"selection"];
        p.remarks   = [rs stringForColumn:@"remarks"];
        
//        NSLog(@"%d %@ %@ %@", p.ID, p.company, p.logo, p.model);
        
        [pianoSelect addObject:p];
    }
    [pianosA addObject:pianoSelect];
    return pianosA;
}

+(NSInteger)pianoLogoCount
{
    NSInteger count = 0;
    
    NSString *sql =[NSString stringWithFormat:@"select count(DISTINCT logo) as 'count' from JapanUsedPiano_copy;"];
    
    FMResultSet *rs = [db executeQuery:sql];
    while (rs.next) {
        count = [rs intForColumn:@"count"];
    }
//    NSLog(@"count %d",count);

    return count;
}



+(NSString *)pianoLogoName:(NSInteger)section
{
    return arrayLogos[section];
}

+(NSArray *)pianoLogos
{
    
    return arrayLogos;
    
}


+(NSArray *)pianoArrayByLogo
{
    pianosA    = [NSMutableArray array];
    arrayLogos = [NSMutableArray array];
    
    NSString  *filename   = [[NSBundle mainBundle]pathForResource:@"AlexPianoDataBase" ofType:@"sqlite"];
    db = [FMDatabase databaseWithPath:filename];
    if ([db open]) {
//        NSLog(@"数据库打开成功");
        
        //查出有共多少种logo  默认为 asc, desc 为降序
        NSString *sql =[NSString stringWithFormat:@"select DISTINCT logo  from JapanUsedPiano_copy order by logo asc;"];
        FMResultSet *rs = [db executeQuery:sql];
        
        while (rs.next) {
            NSString *logo = nil;
            logo = [rs stringForColumn:@"logo"];
            [arrayLogos addObject:logo];
        }
//        NSLog(@"logo is %@", arrayLogos);
        
        //按照logo分类，每个logo为一个array, 所有分类完成后，最后汇总成二维array  'pianosA'
        for (NSString *str in arrayLogos) {
            NSMutableArray *arrayPiano = [NSMutableArray array ];
            NSString *sql2      = [NSString stringWithFormat:@"select * from JapanUsedPiano_copy where logo = '%@';", str];
            FMResultSet *rs2    = [db executeQuery:sql2];
            while (rs2.next) {

                piano *p = [[piano alloc]init];
                
                p.ID        = [rs2 intForColumn:@"id"];
                p.company   = [rs2 stringForColumn:@"company"];
                p.logo      = [rs2 stringForColumn:@"logo"];
                p.model     = [rs2 stringForColumn:@"model"];
                p.hight     = [rs2 stringForColumn:@"hight"];
                p.width     = [rs2 stringForColumn:@"width"];
                p.length    = [rs2 stringForColumn:@"length"];
                p.height    = [rs2 stringForColumn:@"height"];
                p.since     = [rs2 stringForColumn:@"since"];
                p.end       = [rs2 stringForColumn:@"end"];
                p.price     = [rs2 stringForColumn:@"price"];
                p.kind      = [rs2 stringForColumn:@"kind"];
                p.color     = [rs2 stringForColumn:@"color"];
                p.selection = [rs2 stringForColumn:@"selection"];
                p.remarks   = [rs2 stringForColumn:@"remarks"];
                
                [arrayPiano  addObject:p];
            }
//            NSLog(@" arraryPiano count %d is %@", arrayPiano.count, arrayPiano);
            [pianosA addObject:arrayPiano];
//            [arrayPiano removeAllObjects];

        }
//        NSLog(@"all pianos  is %@", pianosA);
        
    } else {
        NSLog(@"数据库打开失败");
    }
    
    return pianosA;
}
@end
