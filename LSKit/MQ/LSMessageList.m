//
//  LSMessageList.m
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/26.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import "LSMessageList.h"
#import "LSMessageModel.h"
#import <pthread.h>
@interface LSMessageList()
{
    pthread_mutex_t _lock;
}
@property (nonatomic , strong) NSMutableArray *waitingMsgList;
@property (nonatomic , strong) NSMutableArray *entryMsgList;
@property (nonatomic , strong) NSMutableArray *contentMsgList;
/**就绪发送的消息的数量 --减少对候发消息的访问**/
@property (nonatomic , assign) NSInteger waitingMsgNum;

@end

@implementation LSMessageList

-(instancetype)initWithWaitingNum:(NSInteger)waitingNum{
    
    if (self = [super init]) {
        
        pthread_mutex_init(&_lock,NULL);
      
        self.waitingMsgNum = waitingNum;
        _waitingMsgList = [NSMutableArray arrayWithCapacity:0];
        _contentMsgList = [NSMutableArray arrayWithCapacity:0];
        _entryMsgList = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

-(NSInteger)msgCount{
    
    NSInteger count = _contentMsgList.count + _waitingMsgList.count + _entryMsgList.count;
    
    return count;
}

/**清除消息**/
-(void)clearMsg{
    
    pthread_mutex_lock(&_lock);
    [_contentMsgList removeAllObjects];
    pthread_mutex_unlock(&_lock);
}

/**添加消息**/
-(void)pushMsgs:(NSArray*)msgs{
    
    pthread_mutex_lock(&_lock);
    [_contentMsgList addObjectsFromArray:msgs];
    pthread_mutex_unlock(&_lock);
}

/**添加消息**/
-(void)pushMsg:(LSMessageModel*)model{
    
    pthread_mutex_lock(&_lock);
    [_contentMsgList addObject:model];
    pthread_mutex_unlock(&_lock);
}

-(void)moveMsgToWaiting{
  
    NSInteger num = self.waitingMsgNum >= _entryMsgList.count ? _entryMsgList.count : self.waitingMsgNum;
    
    for (int i = 0 ; i < num ; i++) {
        LSMessageModel *model = [_entryMsgList objectAtIndex:i];
        [_waitingMsgList addObject:model];
    }
    //移除已添加消息
    [_entryMsgList removeObjectsInArray:_waitingMsgList];
}

-(void)moveMsgToEntry{
    
    [_entryMsgList addObjectsFromArray:_contentMsgList];
    [_contentMsgList removeAllObjects];
    
}

-(void)moveMsg{
    
    pthread_mutex_lock(&_lock);

    [self moveMsgToEntry];
    
    [self moveMsgToWaiting];

    pthread_mutex_unlock(&_lock);
}

-(LSMessageModel*)popMsg{
    
    NSInteger count = [_waitingMsgList count];
    
    LSMessageModel *model;
    
    BOOL read = count > 0 ? YES :NO;
    
    if (read) {
        
        model = [_waitingMsgList firstObject];
        [_waitingMsgList removeObjectAtIndex:0];
        
    }else{
        
        [self moveMsg];
        
        count = [_waitingMsgList count];
        
        read = count > 0 ? YES :NO;
        
        if (read) {
            
            model = [_waitingMsgList firstObject];
            [_waitingMsgList removeObjectAtIndex:0];
        }
    }
    
    return model;
}

@end

