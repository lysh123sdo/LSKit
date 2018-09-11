//
//  LSDataModel.h
//  LSKit
//
//  Created by Lyson on 2018/2/7.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDataModelProtocol.h"
#import "LSDataResponse.h"
#import "LSDataRequest.h"

/**
 状态码 手机网路状态码

 - LSDataModelMobileNetState_NoNetwork: 无网
 - LSDataModelMobileNetState_WLAN: WLan
 - LSDataModelMobileNetState_WIFI: WIFI
 */
typedef NS_ENUM(NSInteger , LSDataModelMobileNetState){

    LSDataModelMobileNetState_NoNetwork,
    LSDataModelMobileNetState_WLAN,
    LSDataModelMobileNetState_WIFI,
};


/**
 用户类型

 - LSDataModelUserLoginState_Null: 未登录
 - LSDataModelUserLoginState_Guest: 游客
 - LSDataModelUserLoginState_Real: 真实
 - LSDataModelUserLoginState_Monitor: 模拟
 */
typedef NS_ENUM(NSInteger , LSDataModelUserLoginState){
    
    LSDataModelUserLoginState_Null = -1,
    LSDataModelUserLoginState_Guest = 0,
    LSDataModelUserLoginState_Real = 1,
    LSDataModelUserLoginState_Monitor = 2,
};


/**
 请求状态码

 - LSDataModelReponseState_Success: 成功
 - LSDataModelReponseState_Fail: 失败
 - LSDataModelReponseState_Empty: 为空
 - LSDataModelReponseState_Push: 推送
 - LSDataModelReponseState_NoNetwork: 无网
 - LSDataModelReponseState_TimeOut: 超时
 - LSDataModelReponseState_NoAutho: 无权限
 - LSDataModelReponseState_NoServer: 服务器连接异常
 */
typedef NS_ENUM(NSInteger , LSDataModelReponseState){
    
    LSDataModelReponseState_Success = 10000,
    LSDataModelReponseState_Fail = 10001,
    LSDataModelReponseState_Empty = 10002,
    LSDataModelReponseState_Push = 10003,
    LSDataModelReponseState_NoNetwork = 10004,
    LSDataModelReponseState_TimeOut = 10005,
    LSDataModelReponseState_NoAutho = 10006,
    LSDataModelReponseState_NoServer = 10007,
};

/**
 请求完成回调

 @param requestIndentifire 请求唯一标识
 @param response 返回数据
 */
typedef void(^LSDataComplete)(NSString *requestIndentifire ,id response);

/**
 数据请求model --与消息队列结合使用
 */
@interface LSDataModel : NSObject<LSDataModelProtocol>

/**
 请求用户名 -没有为空
 */
@property (nonatomic , strong , readonly) NSString *loginName;

@property (nonatomic , strong) NSString *language;

/**
 用户登录状态
 */
@property (nonatomic , assign , readonly) NSInteger loginType;

/**
 服务器状态
 */
@property (nonatomic , assign , readonly) NSInteger serverConnectState;

/**
 手机网络状态
 */
@property (nonatomic , assign , readonly) NSInteger mobileNetState;

/**
 是否已经回调
 */
@property (nonatomic , assign , readonly) BOOL isResponse;


/**
 参数是否ok
 */
@property (nonatomic , assign , readonly) BOOL parameterIsOk;

/**
 请求参数
 */
@property (nonatomic , strong , readonly) id parameter;

/**
 请求唯一标识
 */
@property (nonatomic , strong , readonly) NSString *requestIdentifire;

/**
 初始化方法

 @param parameter 参数
 @param requestIdentifire 唯一标识
 @param complete 完成回调
 @return 请求model
 */
+(instancetype)initDataModelWithParameter:(id)parameter
                               requestSeq:(NSString*)requestIdentifire
                                 complete:(LSDataComplete)complete;



/**
 启动 开始检测-检测结果ok则发送请求数据
 */
-(void)startRun;

-(BOOL)runCheck;

/**
 回调

 @param data 回调数据
 @param stateCode 状态码
 @param msg 回调提示信息
 */
-(void)startReponse:(id)data stateCode:(LSDataModelReponseState)stateCode msg:(NSString*)msg;


/**
 回调

 @param data 回调数据
 @param stateCode 回调状态码
 @param msg 回调提示信息
 @param cache 回调数据是否缓存到消息队列 --消息队列只会缓存最后一条数据
 */
-(void)startReponse:(id)data stateCode:(LSDataModelReponseState)stateCode msg:(NSString*)msg cache:(BOOL)cache;

/**
 启动超时计时器
 */
-(void)startTimeCount;


/**
 取消超时计时器
 */
-(void)cancelTimeCount;

/**
 本地缓存数据变化--有数据更新变化
 */
-(void)cacheDataChanged;

/**
 完成请求
 */
-(void)dataComplete;

/**
 是否在监听对象数组里

 @param topic 判断的话题
 @return YES 在 NO 不在
 */
-(BOOL)isInListener:(NSString*)topic;

/**
 设置唯一标识

 @param requestIdentire 唯一标识
 */
-(void)setDataRequestIdentifire:(NSString *)requestIdentire;

/**
 设置手机网络状态

 @param mobileNetState 网络状态
 */
-(void)setDataMobileNetState:(NSInteger)mobileNetState;

/**
 设置登录状态

 @param loginType 登录状态
 */
-(void)setDataLoginType:(NSInteger)loginType;

/**
 设置用户名

 @param userName 用户名
 */
-(void)setDataLoginName:(NSString*)userName;

/**
 设置是否已经返回

 @param isR YES NO
 */
-(void)setDataIsReponse:(BOOL)isR;

/**
 设置参数是否合法ok

 @param isOk YES NO
 */
-(void)setDataParameterIsOk:(BOOL)isOk;

/**
 设置交易服务器状态

 @param serverConnectState 交易状态
 */
-(void)setDataServerConnectState:(NSInteger)serverConnectState;

/**
 设置语言
 
 @param language 语言
 */
-(void)setDataLanguage:(NSString*)language;

/**
 请求过程中手机网络变化通知

 @param state 手机网络
 */
-(void)mobileNetworkChange:(NSInteger)state;

/**
 请求过程中语言变化通知
 
 @param language 语言
 */
-(void)languageDataChange:(NSString*)language;

/**
 请求过程中服务器变化通知

 @param state 服务器
 */
-(void)serverConnectStateChange:(NSInteger)state;

/**
 请求过程中登录状态变化

 @param state 登录状态
 */
-(void)userLoginStateChange:(NSInteger)state;

@end
