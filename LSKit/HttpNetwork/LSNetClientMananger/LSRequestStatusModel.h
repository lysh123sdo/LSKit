//
//  StatusModel.h
//  GTANetProject
//
//  Created by Lyson on 16/3/16.
//  Copyright © 2016年 GTANetProject. All rights reserved.
//

//===============================
//结果状态类
//===============================

#import <Foundation/Foundation.h>

/**
 *  请求结果状态成功或者失败
 */
typedef NS_ENUM(NSInteger , LSRequestFlag) {
    LSRequestError = 0,//请求失败
    LSRequestSuccess = 1,//请求成功
    LSRequestoutDate = 2//过期
};

/**
 *  失败结果状态与msg对应使用 不同状态对应不同的消息提示
 */
typedef NS_ENUM(NSInteger , LSErrorCode) {
    LSError_Unknow = -1, //无法解析的数据
    LSError_BadNet = 10004,
    LSError_TimeOut = 10005,
    LSError_404 = 404,
    LSError_401 = 401,
    LSError_500 = 500,
};

/**
 解析model 处理返回数据解析用
 */
@interface LSRequestStatusModel : NSObject
/**
 *  请求标志
 */
@property (nonatomic , assign) NSInteger code;
/**
 *  提示消息
 */
@property (nonatomic , strong) NSString *msg;
/**
 *  错误代码
 */
@property (nonatomic , assign) NSInteger errorCode;
/**
 *  结果数据
 */
@property (nonatomic , strong) id data;


/**
 *  解析返回数据
 *
 *
 */
-(id)statusModel:(id)target data:(id)data mapping:(NSDictionary*)mapping;


/**
 *  解析错误提示
 *
 */
-(void)statusModelWithError:(NSError*)error;

/**
 *  获取状态码
 *
 *  @param error 错误
 *
 *  @return 状态码
 */
-(int)statusCodeWithError:(NSError*)error;


/**
 *  错误提示
 *
 *
 *  @return 状态码
 */
-(NSString*)msgByCode:(NSInteger)code;


/*********获取msg字段对应的json key值映射************/
-(NSString*)getMsgKey;

/*********获取code字段对应的json key值映射************/
-(NSString*)getDataKey;

/*********获取data字段对应的json key值映射************/
-(NSString*)getCodeKey;

@end
