//
//  TDDataRequest.h
//  TradeData
//
//  Created by Lyson on 2018/1/12.
//  Copyright © 2018年 TradeData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSDataRequest : NSObject

/**
 请求
 @param event 事件
 @param parameter 参数
 @param requestSeq 唯一标识
 @param plugin 数据组件模块
 */
+(void)request:(NSString*)event parameters:(id)parameter requestSeq:(NSString*)requestSeq plugin:(NSString*)plugin;

@end
