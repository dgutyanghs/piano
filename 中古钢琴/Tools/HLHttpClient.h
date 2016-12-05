//
//  HLHttpClient.h
//  SmartCoach
//
//  Created by AlexYang on 15/8/6.
//  Copyright (c) 2015年 SmartCoach. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/**
 *  第三方登录和手机注册登录
 */
typedef NS_ENUM(NSInteger, OtherTypeLoginEnum){
    /**
     *  非登录状态
     */
    LogoutStatus = 0,
    /**
     *  微信
     */
    OtherTypeLoginWeiXin = 1,
    /**
     *  新浪微博
     */
    OtherTypeLoginWB,
    
    /**
     *  QQ
     */
    OtherTypeLoginQQ,
    
    /*请在此添加其它的第三方登录，手机号NormalTypeMobileNumber保存在最后一个*/
    
    /**
     *  正常的手机号登录
     */
    NormalTypeMobileNumber = 100,
    
};

@interface HLHttpClient : NSObject


/**
 *  单例
 */
+(instancetype)sharedInstance;

-(void)startNetworkMonitor;
-(void)stopNetworkMonitor;
-(BOOL)isNetworkReachable;
-(BOOL)isNetworkReachableViaWifi;
-(BOOL)isNetworkReachableViaWWAN;


#pragma mark seperate Server , Login & Susan Server
-(void)post:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;
-(BOOL)isTokenValid;

/*
 * 上传 单张图片
 */
-(void)postImage:(UIImage *)image Interface:(NSString*)url parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;


/*
 * 上传 多张图片
 */
-(void)postImages:(NSArray *)images Interface:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(NSDictionary *dict))success fail:(void (^)(NSString * error))fail;

//用户更改密码 专用，其它的不要使用该方法
-(void)updatePassword:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;

-(void)postFile:(NSData *)fileData fileName:(NSString *)name Interface:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;



#pragma mark login


/**
 *  short login for first time
 */
//-(void)shortLoginServerWithPhone:(NSString*)phone Password:(NSString*)verifyCode success:(void (^)(id responseObject))success;
/**
 *  login normal  auto login (not first time)
 */

//-(void)loginServerWithPhone:(NSString*)phone Password:(NSString*)password success:(void (^)(id responseObject))success;

-(void)registerUserWithInfo:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;
//-(void)registerUser:(NSString*)phoneNumber Pass:(NSString*)password VeriCode:(NSString*)code success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;


-(void)logoutSuccess:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;


-(void)getTokenFromServer;
-(void)getVerifyCodeFromServerWithPhone:(NSString *)phoneNumber andUsage:(NSDictionary *)dict Success:(void (^)(id responseObject))success Fail:(void (^)(NSString * error))fail;
-(void)postLogin:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;
@end
