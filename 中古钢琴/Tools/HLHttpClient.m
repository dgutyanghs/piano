//
//  HLHttpClient.m
//  SmartCoach
//
//  Created by AlexYang on 15/8/6.
//  Copyright (c) 2015年 SmartCoach. All rights reserved.
//

#import "HLHttpClient.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "HLAccountManger.h"
//#import "const.h"



/**第1步: 存储唯一实例*/
static HLHttpClient *_instance = nil;

/**
 *  错误信息返回
 */
static NSString *errorStr = nil;

@interface HLHttpClient ()
@property (nonatomic , strong) NSURLSessionConfiguration *config;
@property (nonatomic , strong) AFHTTPSessionManager *mgr;
@property (nonatomic , strong) NSURLSessionDataTask *dataTask;
@end

@implementation HLHttpClient

-(AFHTTPSessionManager *)mgr {
    if (_mgr == nil) {
        _mgr = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:self.config];
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"httpsSmartcoach" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        NSSet *certSet =[NSSet setWithObject:certData];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:certSet];

        [securityPolicy setValidatesDomainName:NO];
        [securityPolicy setAllowInvalidCertificates:YES];
        _mgr.securityPolicy = securityPolicy;
    }
    
    return _mgr;
}

-(NSURLSessionConfiguration *)config {
    if (_config == nil) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    return _config;
}

/**第2步: 分配内存孔家时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/**第3步: 保证init初始化时都相同*/
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HLHttpClient alloc] init];
    });
    return _instance;
}

/**第4步: 保证copy时都相同*/
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}



/**
 *  注册用户
 *
 */
-(void)registerUserWithInfo:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/users/add",PREFIX_Login];
    
    self.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    self.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:param error:nil];
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
              HLLog(@"注册网络请求失败%@",error.localizedDescription);
              if (fail) {
                  fail(error.localizedDescription);
              }
            
        }else {
              NSNumber *status = [responseObject valueForKey:@"ok"];
              if ([status intValue]) {
                  NSString *phone = param[@"phone"];
                  NSString *password = param[@"password"];
                  
                  HLLog(@"------注册成功!!----phone %@", phone);
//                  [[HLAccountManger sharedInstance] saveAutoLoginStatus:@100];//保存登录手机方式NormalTypeMobileNumber = 100，以区别第三方登录；
                  [[HLAccountManger sharedInstance] saveAccountPhone:phone];
                  [[HLAccountManger sharedInstance] saveAccountPassword:password];
                  if (success) {
                      success(responseObject);
                  }
                  
              }else {
                  errorStr = [responseObject valueForKey:@"err"];
                  if (fail) {
                      fail(errorStr);
                  }
              }
        }
    }];
    
    [dataTask resume];
    
}



///**
// * Auto 登录服务器
// */
//-(void)loginServerWithPhone:(NSString*)phone Password:(NSString*)password success:(void (^)(id responseObject))success
-(void)loginServerAutomaticSuccess:(void (^)(id responseObject))success
{
    NSNumber *autoLoginType = [[HLAccountManger sharedInstance] getLoginStatus];
    if (autoLoginType.intValue != NormalTypeMobileNumber) {
        return;
    }
    
    NSMutableDictionary *param=[NSMutableDictionary new];
    NSString *phone = [[HLAccountManger sharedInstance] getAccountPhone];
    NSString *password = [[HLAccountManger sharedInstance] getAccountPassword];
    
    [param setValue:phone forKey:@"phone"];
    [param setValue:password forKey:@"password"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/users/get_token",PREFIX_Login];
    self.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    self.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    self.mgr.requestSerializer.timeoutInterval = 10; //timeout
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:param error:nil];
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
                  HLLog(@"auto login faile, network error");
        }else {
              NSNumber *status = [responseObject valueForKey:@"ok"];
              if ([status intValue]) {
                  HLLog(@"------Auto 登录成功!!!----phone %@", phone);
                  if (success) {
                      success(responseObject);
                  }
              }else {
                  errorStr = [responseObject valueForKey:@"err"];
                  HLLog(@"auto login faile:%@", errorStr);
                  
              }
            
        }
    }];
    
    [dataTask resume];

}

/**
 *  注销登录
 */
-(void)logoutSuccess:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/login/logout",PREFIX_Login];
    
    NSMutableDictionary *param=[NSMutableDictionary new];
    [param setValue:[[HLAccountManger sharedInstance] getToken] forKey:@"token"];
    NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:param error:nil];
    self.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    self.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            
        }else {
            NSNumber *status = [responseObject valueForKey:@"ok"];
              if ([status intValue]) {
//                  __weak  HLHttpClient *weakSelf = self;
//                  [weakSelf getTokenAfterLogoutSuccess:^(id responseObject) {
//                      HLLog(@"--------注销成功!!!---------");
//                      if (success) {
//                          success(responseObject);
//                      }
//                  } fail:^(NSString *error) {
//                      if (fail) {
//                          fail(error);
//                      }
//                  }];
    
              } else {
                  errorStr = [responseObject valueForKey:@"err"];
                  HLLog(@"logout error%@", errorStr);
                  if (fail) {
                      fail(errorStr);
                  }
              }
        }
        
    }];
    
    [dataTask resume];
    

    
}

/**
 *  获取验证码
 *
 *  @param phoneNumber 手机号
 */
-(void)getVerifyCodeFromServerWithPhone:(NSString *)phoneNumber andUsage:(NSDictionary *)dict Success:(void (^)(id responseObject))success Fail:(void (^)(NSString * error))fail
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/captcha",PREFIX_Login];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:phoneNumber forKey:@"phone"];
    
    self.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    self.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    self.mgr.requestSerializer.timeoutInterval = 10; //timeout
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:param error:nil];
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
          HLLog(@"验证码请求失败%@",error.localizedDescription);
              if (fail) {
                  fail(error.localizedDescription);
              }
            
        }else {
            HLLog(@"验证码---%@", responseObject);
              NSNumber *ret = responseObject[@"ok"];
              if (ret.intValue) {
                  if (success) {
                      success(responseObject);
                  }
              }else {
                  if (fail) {
                      fail(responseObject[@"err"]);
                  }
              }
        }
    }];
    
    
    [dataTask resume];
}


/**
 *  获取token 成功回调， 失败回调
 */
-(void)getTokenFromServer
{
//    __block  NSString *token = nil;
//    __weak  HLHttpClient *weakSelf = self;
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    NSString *urlStr = [NSString stringWithFormat:@"%@/login/init",PREFIX_Login];
//    self.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    NSMutableURLRequest *requst = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:param error:nil];
//    
//    
//    if (self.isNetworkReachable) {
//            if(![self isTokenValid]) {
//                HLLog(@"getting token .......");
//                NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:requst completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                    if (error) {
//                          HLLog(@"网络token请求失败%@",error.localizedDescription);
//                    }else {
//                            NSNumber *status = [responseObject valueForKey:@"ok"];
//                          if ([status intValue]) {  //token请求成功的回调
//
//                              token = [responseObject valueForKey:@"token"];
//                              HLLog(@"token请求成功");
//                              //1.保存token
//                              [[HLAccountManger sharedInstance] saveToken:token];
//
//                              //2.保存token的有效期
//                              NSNumber *tokenValidTimeLength = [responseObject valueForKey:@"expire"];
//                              [weakSelf updateTokenValidTime:tokenValidTimeLength.intValue];
//
//                              //3.如果是自动登陆(用户以前登陆过)，则在拿到token后自动进行登陆
//                              int loginStatus = [[[HLAccountManger sharedInstance] getLoginStatus] intValue];
//                              if (loginStatus) {
//                                   HLLog(@"重新get token后, 自动登录中...");
//                                  NSMutableDictionary *dict = nil;
//                                  if (loginStatus == NormalTypeMobileNumber) {
//                                      NSString * phone = [[HLAccountManger sharedInstance] getAccountPhone];
//                                      NSString * password = [[HLAccountManger sharedInstance] getAccountPassword];
//
//                                      [weakSelf loginServerWithPhone:phone Password:password success:^(id responseObject) {
//                                      }];
//                                  } else if (loginStatus == OtherTypeLoginQQ) {
//                                      dict = [NSMutableDictionary dictionaryWithContentsOfFile:HL_PATH_THIRD_TYPE_LOGIN(@"OtherTypeLoginQQ")];
//                                  } else if (loginStatus == OtherTypeLoginWB) {
//                                      dict = [NSMutableDictionary dictionaryWithContentsOfFile:HL_PATH_THIRD_TYPE_LOGIN(@"OtherTypeLoginWB")];
//                                  } else if (loginStatus == OtherTypeLoginWeiXin) {
//                                      dict = [NSMutableDictionary dictionaryWithContentsOfFile:HL_PATH_THIRD_TYPE_LOGIN(@"OtherTypeLoginWeiXin")];
//                                  }
//                                  HLLog(@"read local file %@", dict);
//                                  //发送登录请求
//                                  if (loginStatus != NormalTypeMobileNumber) {
//                                      [weakSelf post:@"/login/thirdlogin" parameters:dict success:^(id responseObject) {
//                                          HLLog(@"third type login succus %d", loginStatus );
//                                      } fail:^(NSString *error) {
//                                          HLLog(@"third type login error %@", error);
//                                      }];
//                                  }
//                              }
//                              
//                          } else  {//获取token 失败
//                              HLLog(@"token请求失败");
//                              [MBProgressHUD showError:@"get token error"];
//                          }
//                    }
//                }];
//                
//          [dataTask resume];
//        }
//    }
}

/**
 *  token是否过期
 */
//-(BOOL)isTokenValid
//{
//    long long delta = 600;
//    
//    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
//    long long currentTime = (long long)[date timeIntervalSince1970];
//    NSNumber * expireTime = [[HLAccountManger sharedInstance] getTokenExpireTime];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//     
//    NSDate *expDate = [NSDate dateWithTimeIntervalSince1970:[expireTime longLongValue]];
//    
//    HLLog(@"is Token valid %@, cur:%@, exp:%@", [[HLAccountManger sharedInstance] getToken],[formatter stringFromDate:date] ,[formatter stringFromDate:expDate]);
//    if (currentTime < [expireTime longLongValue] - delta) {
//        return true;
//    } else {
//        return false;
//    }
//}

/**
 *  new change Susan Bra
 *  token是否过期
 *  expireTime 时间戳, 过期的时间戳, 单位是秒
 */
-(BOOL)isTokenValid
{
    NSTimeInterval  delta = 60 * 60 * 12.0; //half day
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTime = [date timeIntervalSince1970];
    NSNumber * expireTime = [[HLAccountManger sharedInstance] getTokenExpireTime];
    
    //>>>>>> for test
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *expDate = [NSDate dateWithTimeIntervalSince1970:[expireTime doubleValue]];
    HLLog(@"is Token valid %@, cur:%@, exp:%@", [[HLAccountManger sharedInstance] getToken],[formatter stringFromDate:date] ,[formatter stringFromDate:expDate]);
   //<<<<<<< end
    if (currentTime < [expireTime doubleValue] - delta) {
        return true;
    } else {
        return false;
    }
    
}



/**
 *  状态网络是否通
 */
-(BOOL)isNetworkReachable
{
    return  [[AFNetworkReachabilityManager sharedManager] isReachable];
    
}

/**
 *  wifi状态
 */
-(BOOL)isNetworkReachableViaWifi
{
    return  [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    
}

/**
 *  3G/4G/蜂窝网络状态
 */
-(BOOL)isNetworkReachableViaWWAN
{
    return  [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
    
}

/**
 *  开始网络监测
 */
-(void)startNetworkMonitor
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *reachabeMgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [reachabeMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
//                [MBProgressHUD showError:@"未知网络"];
                HLLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//                [MBProgressHUD showError:@"网络不通"];
                HLLog(@"没有网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                HLLog(@"蜂窝数据网");
                if (![self isTokenValid]) {
                    __weak __typeof(self) weakSelf = self;
                    [self loginServerAutomaticSuccess:^(NSDictionary * responseObject) {
                        NSNumber *expire = responseObject[@"expire"];
                        NSTimeInterval expireStand = expire.doubleValue / 1000.0;
                        NSString *token = responseObject[@"token"];
                        [weakSelf updateToken:token AndExpireTime:@(expireStand)];
                    }];
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                if (![self isTokenValid]) {
                    __weak __typeof(self) weakSelf = self;
                    [self loginServerAutomaticSuccess:^(NSDictionary * responseObject) {
                        NSNumber *expire = responseObject[@"expire"];
                        NSTimeInterval expireStand = expire.doubleValue / 1000.0;
                        NSString *token = responseObject[@"token"];
                        [weakSelf updateToken:token AndExpireTime:@(expireStand)];
                    }];
                }
                HLLog(@"WIFI网络");
                break;
        }
    }];
    
    // 3.开始监控
    [reachabeMgr startMonitoring];
}

/**
 *  停止网络监测
 */
-(void)stopNetworkMonitor
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


/**
 *  封装 AFN发送post请求
 *
 *  @param param   上传参数
 *  @param urlStr  请求接口
 *  @param success 成功回调
 *  @param fail    失败回调
 */
-(void)post:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PREFIX, interface];
    self.mgr.requestSerializer.timeoutInterval = 10.0;
    self.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    self.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    //拼接参数
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString *token = [[HLAccountManger sharedInstance] getToken];
    dict[@"token"] = token;
    NSMutableURLRequest *requst = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:dict error:nil];
    //发送请求
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:requst completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (fail) {
                fail(error.localizedDescription);
            }
        }else {
            if (success) {
                success(responseObject);
            }
            
        }
    }];
    
    [dataTask resume];
    
}

-(void)postLogin:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PREFIX_Login, interface];
    self.mgr.requestSerializer.timeoutInterval = 10.0;
    self.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    self.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    //拼接参数
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    NSMutableURLRequest *requst = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:dict error:nil];
    //发送请求
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:requst completionHandler:^(NSURLResponse * _Nonnull response, NSDictionary * responseObject, NSError * _Nullable error) {
        if (error) {
            if (fail) {
                fail(error.localizedDescription);
            }
        }else {
            if (success) {
                success(responseObject);
            }
            
        }
    }];
    
    [dataTask resume];
    
}

#pragma mark - 上传单张图片 专用post
-(void)postImage:(UIImage *)image Interface:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail
{
    
    if (image == nil) return;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PREFIX, interface];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    //按当前时间生成文档名
    NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *fileData = UIImageJPEGRepresentation(image, 0.4);
        [formData appendPartWithFileData:fileData name:@"avatar" fileName:fileName mimeType:@"image/jpeg"];
    } error:nil];
    
   NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            HLLog(@"图片上传失败");
            if (fail) {
                fail(error.localizedDescription);
            }
        }else {
            NSNumber * status = responseObject[@"ok"];
            if (status.intValue) {
                HLLog(@"图片上传成功");
                if (success) {
                    success(responseObject);
                }
            } else {
                errorStr = [responseObject valueForKey:@"err"];
                if (fail) {
                    fail(errorStr);
                }
            }
        }
   }];
    
    [dataTask resume];
}

#pragma mark - 上传一组图片
-(void)postImages:(NSArray *)images Interface:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(NSDictionary *dict))success fail:(void (^)(NSString * error))fail
{
    if (images.count == 0) {
         return;
    }

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PREFIX, interface];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    dict[@"token"] = [[HLAccountManger sharedInstance] getToken];
    //服务器Base address
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < images.count; i++) {
            NSData *fileData = UIImageJPEGRepresentation(images[i], 0.04);
            [formData appendPartWithFileData:fileData name:[NSString stringWithFormat:@"sport_pic_%i.jpeg",i] fileName:fileName mimeType:@"image/jpeg"];
        }
    } error:nil];
    
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            HLLog(@"图片上传失败");
            if (fail) {
                fail(error.localizedDescription);
            }
            
        }else {
            NSNumber * status = responseObject[@"ok"];
            if (status.intValue) {
                NSDictionary *dict = responseObject[@"info"];
                
                if (success) {
                    success(dict);
                }
            } else {
                errorStr = [responseObject valueForKey:@"err"];
                if (fail) {
                    fail(responseObject);
                }
            }
        }
    }];
    
    [dataTask resume];
    
    
}

#pragma mark - upload a txt file
-(void)postFile:(NSData *)fileData fileName:(NSString *)name Interface:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail
{
    if (fileData == nil) return;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PREFIX, interface];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMdd-HHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    //按当前时间生成文档名
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@.txt", deviceName,str,name];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file1" fileName:fileName mimeType:@"text/plain"];
    } error:nil];
    
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            HLLog(@"文件上传失败");
            if (fail) {
                fail(error.localizedDescription);
            }
        }else {
            NSNumber * status = responseObject[@"ok"];
            if (status.intValue) {
                HLLog(@"文件上传成功");
                if (success) {
                    success(responseObject);
                }
            } else {
                errorStr = [responseObject valueForKey:@"err"];
                if (fail) {
                    if (errorStr) {
                        fail(errorStr);
                    }else {
                        fail(@"上传失败");
                    }
                }
            }
        }
    }];
    
    [dataTask resume];
    
}


//用户更改密码 专用，其它的不要使用该方法
-(void)updatePassword:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail{
//
//    NSString *url = [NSString stringWithFormat:@"%@%@",PREFIX, interface];
}


-(void)updateToken:(NSString *)token AndExpireTime:(NSNumber *)expire {
    [[HLAccountManger sharedInstance] saveTokenExpireTime:expire];
    [[HLAccountManger sharedInstance] saveToken:token];
}

@end
