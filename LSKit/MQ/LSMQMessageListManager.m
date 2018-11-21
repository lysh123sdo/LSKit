//
//  LSMessageQueueManager.m
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/26.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import "LSMQMessageListManager.h"
#import "LSMessageQueue.h"
#import <YYKit/YYkit.h>
@interface LSMQMessageListManager()

@property (nonatomic , strong) YYThreadSafeDictionary *cacheMsgDic;
@property (nonatomic , strong) YYThreadSafeArray *tempMsgArray;
@property (nonatomic , assign) NSInteger maxQueueNum;
@property (nonatomic , strong) YYThreadSafeArray *msgQueueListArray;
@property (nonatomic , assign) BOOL isRunning;

@end


@implementation LSMQMessageListManager
 static BOOL _isRunning;
-(void)setIsRunning:(BOOL)isRunning{
    
    @synchronized(self){
        
        _isRunning = isRunning;
    }
    
}

- (BOOL)isRunning{
    
    @synchronized(self){
        
        return _isRunning;
    }
}


static LSMQMessageListManager *_instance;

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_instance == nil) {
        
        @synchronized(self){
            
            if (_instance == nil) {
                
                _instance = [super allocWithZone:zone];
            }
        }
    }
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        _maxQueueNum = 4;
        _msgQueueListArray = [YYThreadSafeArray arrayWithCapacity:0];
        _cacheMsgDic = [YYThreadSafeDictionary dictionaryWithCapacity:0];
        _tempMsgArray = [YYThreadSafeArray arrayWithCapacity:0];
      
        [self addDefaultMsgQueue];
    }
    
    return self;
}

/**添加默认的消息处理器**/
-(void)addDefaultMsgQueue{
    
    [self addNewMsgQueue];
}

/**添加一个队列**/
-(void)addNewMsgQueue{

    if (_maxQueueNum <= _msgQueueListArray.count) {
        return;
    }
    
    LSMessageQueue *queue = [[LSMessageQueue alloc] initWithDelegate:(id<LSMessageQueueSignalDelegate>)self];
    queue.name = [NSString stringWithFormat:@"%@%@",NSStringFromClass([LSMessageQueue class]),queue];
    [queue start];
    
    self.isRunning = YES;
    
    [_msgQueueListArray addObject:queue];
    
}

-(void)setCacheMsg:(id)msg topic:(NSString*)topic{
    
    [_cacheMsgDic setValue:msg forKey:topic];

}

-(BOOL)isEmpty:(NSString*)topic{
    
    if (topic == nil || topic == NULL || topic.length <= 0) {
        
        return YES;
    }
    
    return NO;
}

/**移除缓存消息话题**/
-(void)removeCacheMsgs:(NSArray*)topics{
    
    [topics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [self.cacheMsgDic removeObjectForKey:obj];
    }];
}

/**取消所有话题监听**/
-(void)removeAllTopic{

    //移除话题

    for (int i = 0; i < _msgQueueListArray.count; i++) {
        
        LSMessageQueue *queue = [_msgQueueListArray objectAtIndex:i];
        
        [queue removeAllTopic];
    }

}

/**取消话题监听**/
-(void)removeTopic:(NSString*)topic target:(id)target{
    

    for (int i = 0; i < _msgQueueListArray.count; i++) {
        
        LSMessageQueue *queue = [_msgQueueListArray objectAtIndex:i];
        
        if ([queue topicExis:topic]) {
            [queue removeTopic:topic target:target];
        }
    }
    
}

/**取消话题监听**/
-(void)removeTarget:(id)target{
    

    for (int i = 0; i < _msgQueueListArray.count; i++) {
        
        LSMessageQueue *queue = [_msgQueueListArray objectAtIndex:i];
        
        [queue removeTopicByTarget:target];
    }

}

/**添加话题监听**/
-(void)addTopic:(id<LSMQTopicReceiveProtocol>)target topic:(NSString*)topic{
    
    if ([self isEmpty:topic]) {
        @throw [NSException exceptionWithName:NSObjectNotAvailableException reason:@"需要添加消息主题" userInfo:nil];
        return;
    }
    
    for (int i = 0; i < _msgQueueListArray.count; i++) {
        
        LSMessageQueue *queue = [_msgQueueListArray objectAtIndex:i];
        
        if ([queue canAddTopic:topic]) {
            
            [queue addTarget:target topic:topic];
            
            break;
        }
    }

    [self responseCacheMsg:topic target:target];
    
}

/**添加话题消息 缓存小事件，大数据请勿缓存
 msg:消息
 topic:监听的话题
 cache:是否缓存本条消息
 **/
-(void)addMsg:(id)msg topic:(NSString*)topic cache:(BOOL)cache{
    
    [self addMsg:msg topic:topic level:LSMessageLevel_Default cache:cache];
}

/**添加话题消息 缓存小事件，大数据请勿缓存
 msg:消息
 topic:监听的话题
 level:消息优先级
 cache:是否缓存本条消息
 **/
-(void)addMsg:(id)msg topic:(NSString*)topic level:(NSInteger)level cache:(BOOL)cache{
   
    if ([self isEmpty:topic]) {
        @throw [NSException exceptionWithName:NSObjectNotAvailableException reason:@"需要添加消息主题" userInfo:nil];
        return;
    }
    
    if (cache) {
        
        [self setCacheMsg:msg topic:topic];
    }
    
    [self addMsg:msg topic:topic level:level];
}

/**添加话题消息
 msg:消息
 topic:监听的话题
 **/
-(void)addMsg:(id)msg topic:(NSString*)topic{
    
    if ([self isEmpty:topic]) {
        @throw [NSException exceptionWithName:NSObjectNotAvailableException reason:@"需要添加消息主题" userInfo:nil];
        return;
    }
    
    [self addMsg:msg topic:topic level:LSMessageLevel_Default];
}

/**添加话题消息
 msg:消息
 topic:监听的话题
 level:消息优先级
 **/
-(void)addMsg:(id)msg topic:(NSString*)topic level:(NSInteger)level{

    LSMessageModel *model = [LSMessageModel new];
    model.msg = msg;
    model.level = level;
    model.topic = topic;
    [_tempMsgArray addObject:model];
    
    [self push];

}

#pragma mark -

-(void)responseCacheMsg:(NSString*)topic target:(id)target{
 
    id msg = [_cacheMsgDic objectForKey:topic];
    
    if (msg) {
      
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            id<LSMQTopicReceiveProtocol> resTarget = target;
            
            if (resTarget && [resTarget respondsToSelector:@selector(topicReceive:topic:)]) {
                [resTarget topicReceive:msg topic:topic];
            }
        });
//        [self addMsg:msg topic:topic];
    }
    
}

-(void)messageQueueIsWaitingMessage:(LSMessageQueue*)queue{
    
    [self addMessages:queue];

}

-(void)push{
   
    LSMessageQueue *queue = [_msgQueueListArray firstObject];
    
    LSMessageModel *model = [_tempMsgArray firstObject];
    
    if (model && !self.isRunning) {
        self.isRunning = YES;
        [queue push:model];
        [_tempMsgArray removeObject:model];
        
    }
}

-(void)addMessages:(LSMessageQueue*)queue{

    NSInteger msgCount = queue.maxMsgNum > _tempMsgArray.count ? _tempMsgArray.count : queue.maxMsgNum;
    NSMutableArray *msgs = [NSMutableArray arrayWithCapacity:msgCount];
    for (int i = 0; i < msgCount; i++) {
        
        [msgs addObject:[_tempMsgArray objectAtIndex:i]];
        
    }
    [queue pushMsgs:msgs];
    [_tempMsgArray removeObjectsInArray:msgs];
    
    if (_tempMsgArray.count > 0) {
        
        self.isRunning = YES;
    }else{
        
        self.isRunning = NO;
    }
 
}


@end
