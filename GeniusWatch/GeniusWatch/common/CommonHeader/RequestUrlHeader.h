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
#define WATCH_INFO_URL              MAKE_REQUEST_URL(@"device/basicinfo")

//解除手表
#define REVOKE_WATCH_URL            MAKE_REQUEST_URL(@"device/unbind")

//获取绑定设备列表
#define DEVICE_LIST_URL             MAKE_REQUEST_URL(@"device/list")

//获取设备当前位置
#define UPDATE_LOCATION_URL         MAKE_REQUEST_URL(@"activity/lastpoi")

//获取设备信息
#define OWNER_INFO_URL              MAKE_REQUEST_URL(@"device/owner")

//设置设备信息
#define UPDATE_OWNER_URL            MAKE_REQUEST_URL(@"device/updateownerinfo")

//获取设备基本信息
#define WATCH_INFO_URL              MAKE_REQUEST_URL(@"device/basicinfo")

//获取设备参数开关
#define WATCH_SETTING_URL           MAKE_REQUEST_URL(@"device/settings")

//修改设备配置信息
#define UPDATE_WATCH_SETTING_URL    MAKE_REQUEST_URL(@"device/updatesettings")

//获取通讯录
#define CONTACTS_URL                MAKE_REQUEST_URL(@"contacts/get")

//添加通讯录
#define ADD_CONTACTS_URL            MAKE_REQUEST_URL(@"contacts/put")

//删除通讯录
#define DEL_CONTACTS_URL            MAKE_REQUEST_URL(@"contacts/del")

//更新通讯录
#define UPDATE_CONTACT_URL          MAKE_REQUEST_URL(@"contacts/post")

//手机流量查询
#define WATCH_FLOWCHARGE_URL        MAKE_REQUEST_URL(@"device/flowcharge")

//手机话费查询
#define WATCH_CALLCHARGE_URL        MAKE_REQUEST_URL(@"device/callcharge")

//消息列表
#define MESSAGE_LIST_URL            MAKE_REQUEST_URL(@"device/msg")

//消息删除
#define MESSAGE_DELETE_URL          MAKE_REQUEST_URL(@"device/delmsg")

//意见反馈
#define FEEDBACK_URL                MAKE_REQUEST_URL(@"static/feedback")

//修改密码
#define CHG_PWD_URL                 MAKE_REQUEST_URL(@"user/changepwd")

//设置守护
#define SET_GUARD_URL               MAKE_REQUEST_URL(@"device/care")

//用户协议
#define USER_NOTICE_URL             MAKE_REQUEST_URL(@"static/license")

#endif
