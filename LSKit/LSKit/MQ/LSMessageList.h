//
//  LSMessageList.h
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/26.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**消息优先级**/
typedef NS_ENUM(NSInteger , LSMessageLevel){
    
    LSMessageLevel_Low,
    LSMessageLevel_Default,
    LSMessageLevel_High,
    
};

@class LSMessageModel;

@interface LSMessageList : NSObject

@property (nonatomic , assign) NSInteger msgCount;

-(instancetype)initWithWaitingNum:(NSInteger)waitingNum;

/**清除消息**/
-(void)clearMsg;

/**添加消息**/
-(void)pushMsgs:(NSArray*)msgs;

/**添加消息**/
-(void)pushMsg:(LSMessageModel*)model;


-(LSMessageModel*)popMsg;

@end
