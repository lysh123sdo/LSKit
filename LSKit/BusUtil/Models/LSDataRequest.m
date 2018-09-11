//
//  TDDataRequest.m
//  TradeData
//
//  Created by Lyson on 2018/1/12.
//  Copyright © 2018年 TradeData. All rights reserved.
//

#import "LSDataRequest.h"
#import "LSMQMessageListManager.h"

@implementation LSDataRequest

+(void)request:(NSString*)event parameters:(id)parameter requestSeq:(NSString*)requestSeq plugin:(NSString*)plugin{
    
    NSDictionary *reDic = [NSDictionary dictionaryWithObjectsAndKeys:event,@"Event",requestSeq,@"RequestSeq",parameter,@"Parameter", nil];
    
    [[LSMQMessageListManager shareInstance] addMsg:reDic topic:plugin];
}



@end
