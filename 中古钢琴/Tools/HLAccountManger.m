//
//  HLAccountManger.m
//  SmartCoach_ForCoach
//
//  Created by MacWillam on 15/6/11.
//  Copyright (c) 2015年 HLTX. All rights reserved.
//

#import "HLAccountManger.h"


static HLAccountManger *_instance = nil;

@implementation HLAccountManger


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
        _instance = [[HLAccountManger alloc] init];
    });
    return _instance;
}

/**第4步: 保证copy时都相同*/
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}







//退出登陆
-(BOOL)loginOut{
    NSUserDefaults *outInfo = [NSUserDefaults standardUserDefaults];
//    [outInfo setObject:@"" forKey:HL_ACCOUNT_PHONE];
//    [outInfo setObject:@"" forKey:HL_ACCOUNT_PASSWORD];
//    [outInfo setObject:@"" forKey:HL_TOKEN];
    [outInfo setObject:@0 forKey:HL_AUTO_LOGIN];
    return YES;
}

//返回用户的昵称
//-(NSString *)getAccountUsername{
//    NSUserDefaults *saveUserInfo = [NSUserDefaults standardUserDefaults];
//    NSString *userUsername = [saveUserInfo objectForKey:HL_ACCOUNT_USER_NAME];
//    return [userUsername length]>0 ?userUsername:@"";
//}

//返回自动登录标志
-(NSNumber *)getLoginStatus{
    NSUserDefaults *saveUserInfo = [NSUserDefaults standardUserDefaults];
    NSNumber *loginStatus = [saveUserInfo objectForKey:HL_AUTO_LOGIN];
    return loginStatus ;
}

//返回Token
-(NSString *)getToken{
    NSUserDefaults *UserInfo = [NSUserDefaults standardUserDefaults];
    NSString *token = [UserInfo objectForKey:HL_TOKEN];
//    HLLog(@"userdefault get token = %@", token);
    return [token length]>0 ?token:@"";
}

/**
 *  token 过期时间
 */
-(NSNumber *)getTokenExpireTime
{
    NSUserDefaults *UserInfo = [NSUserDefaults standardUserDefaults];
    NSNumber *tokenVaildTime = [UserInfo objectForKey:HL_TOKEN_EXPIRE_TIME];
//    HLLog(@"userdefault get tokenVaildTime = %@", tokenVaildTime);
    return tokenVaildTime;
}

//返回用户id 手机号
-(NSString *)getAccountPhone{
    NSUserDefaults *saveUserInfo = [NSUserDefaults standardUserDefaults];
    NSString *userAccountid = [saveUserInfo objectForKey:HL_ACCOUNT_PHONE];
//    return [userAccountid length]>0 ?userAccountid:@"";
    return userAccountid;
}
//返回用户密码
-(NSString *)getAccountPassword{
    NSUserDefaults *saveUserInfo = [NSUserDefaults standardUserDefaults];
    NSString *userPassword = [saveUserInfo objectForKey:HL_ACCOUNT_PASSWORD];
    return [userPassword length]>0 ?userPassword:@"";
}

-(void)saveAccountPhone:(NSString*)phone{
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:HL_ACCOUNT_PHONE];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)saveAccountPassword:(NSString*)passWord{
    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:HL_ACCOUNT_PASSWORD];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)saveToken:(NSString*)token{
//    HLLog(@"userdefault save token = %@", token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:HL_TOKEN];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    [self getToken];
}

-(void)saveTokenExpireTime:(NSNumber *)time
{
//    HLLog(@"userdefault save TokenVaildTime = %@", time);
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:HL_TOKEN_EXPIRE_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveAutoLoginStatus:(NSNumber *)status{
    [[NSUserDefaults standardUserDefaults] setObject:status forKey:HL_AUTO_LOGIN];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
