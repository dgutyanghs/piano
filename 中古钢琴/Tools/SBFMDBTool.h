//
//  SBFMDBTool.h
//  SmartBra
//
//  Created by AlexYang on 16/11/3.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class HLHeartRateModel;

@interface SBFMDBTool : NSObject

+(instancetype)sharedInstance;


-(NSArray <HLHeartRateModel *>*)SBCollectHeartRateDataByDate:(NSDate *)date;
-(void)SBInsertHeartRateValue:(uint8_t)value andDate:(NSDate *) recordDate;
@end
