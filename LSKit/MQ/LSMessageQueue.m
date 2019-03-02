//
//  LSMessageQueue.m
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/25.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import "LSMessageQueue.h"
#import <pthread.h>

@interface LSMessageQueue()
{
    
}

@property (nonatomic , strong) LSMessageList *msgList;
@property (nonatomic , assign) BOOL isRunning;
@property (nonatomic , strong) LSRunloopContext *context;
@property (nonatomic , strong) NSMutableDictionary *topicDic;
@property (nonatomic , assign) NSInteger waitingNum;
@property (nonatomic , weak) id<LSMessageQueueSignalDelegate> delegate;

@end

@implementation LSMessageQueue

static BOOL _issRunning;

-(void)setIsRunning:(BOOL)isRunning{
    
    @synchronized(self){
        
        _issRunning = isRunning;
    }
    
}

- (BOOL)isRunning{
    
    @synchronized(self){
        
        return _issRunning;
    }
}


-(void)runLoopScheduleRouting:(LSRunloopContext *)context strRef:(CFStringRef)mode{
    
    self.context = context;
}

-(void)runLoopPerformRouting:(void *)info{
    
    
}

-(void)runLoopCancelRouting:(LSRunloopContext *)context strRef:(CFStringRef)mode{
    
    
}

-(instancetype)initWithDelegate:(id<LSMessageQueueSignalDelegate>)delegate{
    
    if (self = [super init]) {
        
        self.name = @"com.Lson.msgQueue";
        _delegate = delegate;
        
        _waitingNum = 100;
        _maxMsgNum = 10000;
        
        _msgList = [[LSMessageList alloc] initWithWaitingNum:self.waitingNum];
        _topicDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
    }
    return self;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        self.waitingNum = 100;
        
        _msgList = [[LSMessageList alloc] initWithWaitingNum:self.waitingNum];
        _topicDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
    }
    return self;
}

-(void)main{
    
    
    @autoreleasepool{
        
        NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
        
        LSRunloopSource *source = [[LSRunloopSource alloc] initWithDelegate:(id<LSRunloopSourceDelegate>)self];
        [source addToCurrentLoop];
        
        while (!self.isCancelled) {
            
            [self doTask];
            
            [myRunLoop runMode:NSDefaultRunLoopMode
                    beforeDate:[NSDate distantFuture]];
        }
        
    }
    
}

#pragma mark -话题添加

-(void)removeTopicByTarget:(id)target{
    
    NSArray *keys = [_topicDic allKeys];
    
    for (int i = 0; i < keys.count ; i++) {
        
        NSString *topic = [keys objectAtIndex:i];
       
        [self removeTopic:topic target:target];
        
    }
    
}

-(void)removeAllTopic{
    
    [_topicDic removeAllObjects];
    
}

-(void)removeTopic:(id)topic{
    
    
    [_topicDic removeObjectForKey:topic];
    
}

-(void)removeTopic:(id)topic target:(NSString*)target{
    
    if ([self isEmpty:topic]) {
        return;
    }
    
    NSHashTable *table = [_topicDic objectForKey:topic];
    
    if (!table) {
        return;
    }
    
    if ([table containsObject:target]) {
        
        [table removeObject:target];
    }
    
    [_topicDic setValue:table forKey:topic];
    
}

/**添加话题**/
-(void)addTarget:(id<LSMQTopicReceiveProtocol>)target topic:(NSString*)topic{
    
    NSHashTable *table = [_topicDic objectForKey:topic];
    
    if (!table) {
        table = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    
    if (![table containsObject:target]) {
        [table addObject:target];
    }
    
    [_topicDic setValue:table forKey:topic];
    
}


#pragma mark -消息处理

-(void)pushMsgs:(NSArray*)msgs{
    
    if (msgs.count <= 0) {
        
        return;
    }
    
    _lastAddMsgNum = msgs.count;
    
    [_msgList pushMsgs:msgs];
    
    if (!self.isRunning) {
        //发送信号激活
        [self fire];
    }
}

//消息添加
-(void)push:(LSMessageModel*)model{
    
    [_msgList pushMsg:model];
    
    _lastAddMsgNum = 1;
    
    if (!self.isRunning) {
        //发送信号激活
        [self fire];
    }
}

-(void)remove{
    
    [self.context.source removeLoop];
}

-(void)fire{
    
    [self.context.source fireRunloop:self.context.runLoop];
}


-(NSDictionary*)topics{
    
    return _topicDic;
}

-(BOOL)topicExis:(NSString*)topic{
    
    if ([_topicDic objectForKey:topic]) {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)canAddTopic:(NSString*)topic{
    
    if ([_topicDic objectForKey:topic] || self.maxMsgNum > self.lastAddMsgNum) {
        
        return YES;
    }
    
    return NO;
}

-(NSInteger)topicCount{
    
    NSInteger count = _topicDic.count;
    
    return count;
}

-(NSInteger)msgCount{
    
    NSInteger count = _msgList.msgCount;
    
    return count;
}

#pragma mark - 派发

-(BOOL)isEmpty:(NSString*)topic{
    
    if (topic == nil || topic == NULL || topic.length <= 0) {
        
        return YES;
    }
    
    return NO;
}

-(void)doTask{
    
    @autoreleasepool{
        
        LSMessageModel *model = [_msgList popMsg];
        
        if (!model) {
            self.isRunning = NO;
            
            if (_delegate && [_delegate respondsToSelector:@selector(messageQueueIsWaitingMessage:)]) {
                
                [_delegate messageQueueIsWaitingMessage:self];
            }
        }else{
            self.isRunning = YES;
            
            [self sendMsg:model];
            [self fire];
            
        }
        
    }
    
}

-(void)sendMsg:(LSMessageModel*)model{
    
    NSString *topic = model.topic;
    NSString *msg = model.msg;
    
    NSHashTable *table = [_topicDic objectForKey:topic];
    
    if (!table) {
        return;
    }
    
    NSArray *array = [table allObjects];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id<LSMQTopicReceiveProtocol> target = obj;
        
        if ([target respondsToSelector:@selector(topicReceive:topic:)]) {
            [target topicReceive:msg topic:topic];
            
        }
    }];
    
}

@end

