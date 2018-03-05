//
//  LSMessageQueueManager.h
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/26.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import <Foundation/Foundation.h>
//@protocol LSMessageQueueDelegate;

@protocol LSMQTopicReceiveProtocol <NSObject>

-(void)topicReceive:(id)msg topic:(NSString*)topic;

@end

@interface LSMQMessageListManager : NSObject

+(instancetype)shareInstance;

/**取消所有话题监听**/
-(void)removeAllTopic;

/**取消话题监听**/
-(void)removeTopic:(NSString*)topic target:(id)target;

-(void)removeTopic:(id)topic;

/**取消话题监听**/
-(void)removeTarget:(id)target;


/**添加话题监听**/
-(void)addTopic:(id<LSMQTopicReceiveProtocol>)target topic:(NSString*)topic;

/**添加话题消息
 msg:消息
 topic:监听的话题
 **/
-(void)addMsg:(id)msg topic:(NSString*)topic;

/**添加话题消息
 msg:消息
 topic:监听的话题
 level:消息优先级
 **/
-(void)addMsg:(id)msg topic:(NSString*)topic level:(NSInteger)level;

/**添加话题消息 缓存小事件，大数据请勿缓存
 msg:消息
 topic:监听的话题
 cache:是否缓存本条消息
 **/
-(void)addMsg:(id)msg topic:(NSString*)topic cache:(BOOL)cache;

/**添加话题消息 缓存小事件，大数据请勿缓存
 msg:消息
 topic:监听的话题
 level:消息优先级
 cache:是否缓存本条消息
 **/
-(void)addMsg:(id)msg topic:(NSString*)topic level:(NSInteger)level cache:(BOOL)cache;

/**移除缓存消息话题**/
-(void)removeCacheMsgs:(NSArray*)topics;
@end
