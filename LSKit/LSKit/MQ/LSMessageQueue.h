//
//  LSMessageQueue.h
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/25.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSRunloopSource.h"
#import "LSMessageList.h"
#import "LSMessageModel.h"
#import "LSMQMessageListManager.h"

@class LSMessageQueue;


@protocol LSMessageQueueSignalDelegate<NSObject>

-(void)messageQueueIsWaitingMessage:(LSMessageQueue*)queue;

@end


@class LSMessageModel;

@interface LSMessageQueue : NSThread

@property (readonly) NSInteger maxMsgNum;
@property (readonly) NSInteger msgCount;
@property (readonly) NSInteger topicCount;
@property (readonly) NSInteger lastAddMsgNum;

-(instancetype)initWithDelegate:(id<LSMessageQueueSignalDelegate>)delegate;

-(BOOL)canAddTopic:(NSString*)topic;

-(BOOL)topicExis:(NSString*)topic;

-(NSDictionary*)topics;

-(void)remove;

-(void)push:(LSMessageModel*)model;

-(void)pushMsgs:(NSArray*)msgs;

-(void)removeTopicByTarget:(id)target;

-(void)removeAllTopic;

-(void)removeTopic:(id)topic;

-(void)removeTopic:(id)topic target:(NSString*)target;

/**添加话题**/
-(void)addTarget:(id<LSMQTopicReceiveProtocol>)target topic:(NSString*)topic;

@end
