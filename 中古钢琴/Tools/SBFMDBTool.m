//
//  SBFMDBTool.m
//  SmartBra
//
//  Created by AlexYang on 16/11/3.
//
//

#import "SBFMDBTool.h"

/**第1步: 存储唯一实例*/
static SBFMDBTool *_instance = nil;

/**
 *  错误信息返回
 */
//static NSString *errorStr = nil;
//static const int secondsPerDay = 24 * 60 * 60;

@interface SBFMDBTool ()
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSMutableArray *records;
@end


@implementation SBFMDBTool

/**第2步: 分配内存孔家时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance initialFMDataBase];
    });
    return _instance;
}

/**第3步: 保证init初始化时都相同*/
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SBFMDBTool alloc] init];
    });
    return _instance;
}

/**第4步: 保证copy时都相同*/
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}


#pragma mark -- 
#pragma mark FMDB

-(void)initialFMDataBase {
    //1.获得数据库文件的路径
//    NSString *fileName = HL_PATH_THIRD_TYPE_LOGIN(@"rrdata.sqlite");
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:HL_DATA_BASE_FILE];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open])
    {
        //4.创表
        NSString *tableStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, timeStamp double NOT NULL, value int NOT NULL);", HL_DB_T_HeartRate];
        BOOL result = [db executeUpdate:tableStr];
        if (result)
        {
            HLLog(@"创建表:t_heartRate成功");
        }else {
            HLLog(@"创建表:t_heartRate失败");
        }
        
        BOOL result1 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_rrdata (recordTime int NOT NULL, rrdata int NOT NULL);"];
        if (result1)
        {
            HLLog(@"创建表:t_rrdata success");
        }else {
            HLLog(@"创建表:t_rrdata failed");
        }
        
        
        BOOL result2 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_measureTime (id INTEGER PRIMARY KEY AUTOINCREMENT, timeModel object NOT NULL, f_LFHF float,  retStr text, T int);"];
        if (result2)
        {
            HLLog(@"创建表:t_measureTime成功");
        }else {
            HLLog(@"创建表:t_measureTime失败");
        }
    }
    
    self.db = db;
}


-(BOOL)queryRRDataRecordInDataBaseByTimestamp:(int)timestamp {
    //根据条件查询
    FMResultSet *resultSet = [self.db executeQuery:@"select * from t_rrdata where recordTime > %d;", timestamp];
    
    if ([resultSet next]) {
        return YES;
    }else {
        return NO;
    }
}


//-(NSMutableArray *)initialRecordsBetween:(NSDate*)date1 and:(NSDate *)date2 {
//    _records = nil;
//    _records = [NSMutableArray array];
//    
//    
//    FMDatabase *db = [FMDatabase databaseWithPath:HL_DATA_BASE_FILE];
//    if ([db open]) {
//        NSString *queryString = [NSString stringWithFormat:@"select value,timeStamp from %@;", HL_DB_T_HeartRate];
//        FMResultSet *resultSet = [db executeQuery:queryString];
//        //遍历结果集合
//        while ([resultSet  next])
//        {
//            HLHeartRateModel *model = [[HLHeartRateModel alloc] init];
//            model.value = [resultSet intForColumn:@"value"];
//            model.timeStamp = [resultSet doubleForColumn:@"timeStamp"];
//            
//            [_records addObject:model];
////            HLLog(@"model(%d, %f)", model.value, model.timeStamp);
//        }
//    }
//    return _records;
//}
//
//-(NSMutableArray *)initialRecordsByDay:(NSDate *)date {
//    _records = nil;
//    _records = [NSMutableArray array];
//    
//    NSDate *beginDate = [self getBeginOfDay:date];
//    NSTimeInterval beginTimeStamp = beginDate.timeIntervalSince1970;
//    NSTimeInterval endTimeStamp = beginDate.timeIntervalSince1970 + secondsPerDay;
//    HLLog(@"initial stamp(b:%.f, e:%.f)", beginTimeStamp, endTimeStamp);
//    FMDatabase *db = [FMDatabase databaseWithPath:HL_DATA_BASE_FILE];
//    self.db = db;
//    if ([db open]) {
//        NSString *queryString = [NSString stringWithFormat:@"select value,timeStamp from %@ where timeStamp between %.0f and %.0f;", HL_DB_T_HeartRate, beginTimeStamp, endTimeStamp];
//        FMResultSet *resultSet = [db executeQuery:queryString];
//        //遍历结果集合
//        while ([resultSet  next])
//        {
//            HLHeartRateModel *model = [[HLHeartRateModel alloc] init];
//            model.value = [resultSet intForColumn:@"value"];
//            model.timeStamp = [resultSet doubleForColumn:@"timeStamp"];
//            
//            [_records addObject:model];
////            HLLog(@"model(%d, %f)", model.value, model.timeStamp);
//        }
//    }
//    return _records;
//}

-(NSDate *)getBeginOfDay:(NSDate *)now {
//    NSDate *now=[NSDate date];
    NSCalendar *cal=[NSCalendar currentCalendar];
    cal.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSDate *beginOfToday= [cal startOfDayForDate:now];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy/M/d HH:mm:ss"];
    NSLog(@"Begin of today=%@",[dateFormatter stringFromDate:beginOfToday]);
    
    return beginOfToday;
}




//-(NSArray <HLHeartRateModel *>*)SBCollectHeartRateDataByDate:(NSDate *)date {
//    _records = nil;
//    NSTimeInterval beginTimeStamp ,endTimeStamp;
//    
//    NSDate *beginOfDay = [self getBeginOfDay:date];
//    beginTimeStamp = beginOfDay.timeIntervalSince1970;
//    endTimeStamp = beginTimeStamp + secondsPerDay;
//    _records = [[self queryRecordBetweenStart:beginTimeStamp andEnd:endTimeStamp] mutableCopy];
//    
//    return _records;
//}



//-(NSArray *)queryRecordBetweenStart:(NSTimeInterval)beginTimeStamp andEnd:(NSTimeInterval) endTimeStamp {
//    
//    NSAssert(self.db, @"error db");
//    NSMutableArray *datas = [NSMutableArray array];
//    NSString *queryString = [NSString stringWithFormat:@"select value,timeStamp from %@ where timeStamp between %.0f and %.0f;", HL_DB_T_HeartRate, beginTimeStamp, endTimeStamp];
//    FMResultSet *resultSet = [self.db executeQuery:queryString];
//    //遍历结果集合
//    while ([resultSet  next])
//    {
//        HLHeartRateModel *model = [[HLHeartRateModel alloc] init];
//        model.value = [resultSet intForColumn:@"value"];
//        model.timeStamp = [resultSet doubleForColumn:@"timeStamp"];
//        
//        [datas addObject:model];
////        HLLog(@"model(%d, %f)", model.value, model.timeStamp);
//    }
//    
//    return datas;
//}

-(void)SBInsertHeartRateValue:(uint8_t)value andDate:(NSDate *) recordDate{
    NSTimeInterval timeStamp = recordDate.timeIntervalSince1970;
    NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO %@ (timeStamp, value) VALUES (%f,%d);", HL_DB_T_HeartRate, timeStamp, value];
    [self.db executeUpdate:insertStr];
    HLLog(@"heart Rate insert DB (%f,%d)",timeStamp, value);
}

@end
