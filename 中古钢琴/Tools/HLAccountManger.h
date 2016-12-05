//
//  HLAccountManger.h
//  SmartCoach_ForCoach
//
//  Created by MacWillam on 15/6/11.
//  Copyright (c) 2015年 HLTX. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HL_ACCOUNT_USER_NAME       @"HLAccountUsername"
#define HL_ACCOUNT_PASSWORD       @"HLAccountPassword"
#define HL_TOKEN                    @"HLToken"
#define HL_TOKEN_EXPIRE_TIME         @"HLTokenExpireTime"
#define HL_ACCOUNT_OAUTH_TOKEN     @"HLAccountOAuthToken"
#define HL_ACCOUNT_USERID         @"HLAccountUserID"
#define HL_ACCOUNT_EMAIL          @"HLAccountEmail"
#define HL_ACCOUNT_PHONE            @"HLAccountPhone"
#define HL_AUTO_LOGIN                   @"HLAutoLoginFlag"

@interface HLAccountManger : NSObject

/**
 *  账户的单例
 *
 *  @return 账户
 */
+(HLAccountManger *)sharedInstance;




/**
 *  退出账户（注销账户的Account pwd AuthToken）
 *
 *  @return 是否退出成功
 */
-(BOOL)loginOut;


//返回Token
-(NSString *)getToken;
/**
 *  token有效时间
 */
-(NSNumber *)getTokenExpireTime;
//返回用户id 手机号
-(NSString *)getAccountPhone;
//返回用户密码
-(NSString *)getAccountPassword;
//登录状态
-(NSNumber *)getLoginStatus;

-(void)saveAccountPhone:(NSString*)phone;
-(void)saveAccountPassword:(NSString*)passWord;
-(void)saveToken:(NSString*)token;
-(void)saveAutoLoginStatus:(NSNumber *)status;

-(void)saveTokenExpireTime:(NSNumber *)time;
@end
