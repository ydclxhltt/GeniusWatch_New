//
//  RequestUrlHeader.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/9/3.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#ifndef GeniusWatch_RequestUrlHeader_h
#define GeniusWatch_RequestUrlHeader_h

#define SERVER_URL                  @"http://115.29.5.113/watch/app/"

#define MAKE_REQUEST_URL(inf)       [NSString stringWithFormat:@"%@%@",SERVER_URL,inf]

//验证手机号
#define CHECK_PHONENUMBER_URL       MAKE_REQUEST_URL(@"login/validateRegAccount")

//获取验证码
#define GET_CODE_URL                MAKE_REQUEST_URL(@"login/getMsgCode")

//提交验证码
#define CHECK_CODE_URL              MAKE_REQUEST_URL(@"login/validateMsgCode")

//注册和忘记密码
#define REG_CHANGEPWD_URL           MAKE_REQUEST_URL(@"login/postAccountPassword")

//登录
#define LOGIN_URL                   MAKE_REQUEST_URL(@"login/land")

//绑定设备
#define BIND_URL                    MAKE_REQUEST_URL(@"device/bind")

//退出登录
#define EXIT_URL                    MAKE_REQUEST_URL(@"user/logout")

//宝贝资料
//#define BABY_INFO_URL

//关于手表
#define WATCH_INFO_URL              MAKE_REQUEST_URL(@"device/basicinfo/")

#endif
