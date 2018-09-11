//
//  QTDataManager.m
//  QuotData
//
//  Created by Lyson on 2017/12/25.
//  Copyright © 2017年 QuotData. All rights reserved.
//

#import "LSDataManager.h"
#import "LSMQMessageListManager.h"
#import <pthread.h>
#import <YYKit/YYThreadSafeDictionary.h>
#import "LSBaseDataCache.h"
#import "NSString+LS.h"
@interface LSDataManager()<LSMQTopicReceiveProtocol>
{
    
    pthread_mutex_t lock;
}


@property (nonatomic , assign) NSInteger mobileNetState;
@property (nonatomic , assign) NSInteger serverConnectState;
@property (nonatomic , assign) NSInteger loginType;
@property (nonatomic , copy) NSString *loginName;


@end



@implementation LSDataManager

//static char *QTDataQueue = "com.gw.quotdata.dataevent";

/**参数请求Key**/
NSString* const LSEvent = @"Event";
/**参数请求Key**/
NSString* const LSParameter = @"Parameter";

/**请求唯一标示,客户端使用**/
NSString* const LSRequestSeq = @"RequestSeq";
/**参数请求Key**/
NSString* const LSData = @"data";
+(void)config{
    
    [self shareInstance];
}


+(instancetype)shareInstance{
 
    return nil;
}

+(void)deallocInstance{
    
}


-(void)dealloc{
    
    
}

-(instancetype)init{
    
    if (self = [super init]) {
      
        [self initData];
        [self initEventObserver];
        [self initEvent];
        
        
    }
    
    return self;
}

-(void)initData{
    
    pthread_mutex_init(&lock, NULL);
    
    _loginType = -1;
    _mobileNetState = -1;
    _serverConnectState = -1;
    _language = @"--1";
    _loginName = nil;
    _socketReqDic = [[YYThreadSafeDictionary alloc] initWithCapacity:0];
}

-(void)initEvent{
    
    
}


-(void)clearAllRequest{
    
    pthread_mutex_lock(&lock);
    [_socketReqDic removeAllObjects];
    pthread_mutex_unlock(&lock);
}

-(void)initEventObserver{
    
    
    if (![NSString isEmpty:[self pluginDataEvent]]){
        [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:[self pluginDataEvent]];
    }
    if (![NSString isEmpty:[self loginEvent]]){
        [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:[self loginEvent]];
    }
    if (![NSString isEmpty:[self languageEvent]]){
        [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:[self languageEvent]];
    }
    if (![NSString isEmpty:[self serverConnectEvent]]){
        [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:[self serverConnectEvent]];
    }
    if (![NSString isEmpty:[self mobileNetworkingEvent]]){
        [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:[self mobileNetworkingEvent]];
    }
    
}

-(void)setSocketRequestValue:(LSDataModel*)dataModel key:(NSString*)key{
    
    pthread_mutex_lock(&lock);
    
    [_socketReqDic setValue:dataModel forKey:key];
    
    pthread_mutex_unlock(&lock);
}

/**事件监听**/
-(void)topicReceive:(id)msg topic:(NSString*)topic{
    
    if ([topic isEqualToString:[self pluginDataEvent]]) {
        //数据请求
        [self doEvent:msg];
    }else if ([topic isEqualToString:[self loginEvent]]){
        [self userLoginEvent:msg];
    }else if ([topic isEqualToString:[self serverConnectEvent]]){
        [self serverConnectChangeEvent:msg];
    }else if ([topic isEqualToString:[self mobileNetworkingEvent]]){
        [self mobileNetworkEvent:msg];
    }else if ([topic isEqualToString:[self languageEvent]]){
        [self languageChange:msg];
    }

}


-(void)mobileNetworkEvent:(id)msg{
    
    
    NSInteger state = [msg integerValue];
    
    self.mobileNetState = state;
    
    [self setMobileState:state];

}

-(void)serverConnectChangeEvent:(id)msg{
    
    NSInteger state = [msg[LSData] integerValue];
    self.serverConnectState = state;
 
    NSArray *allKeys = [_socketReqDic allKeys];
    
    for (int i = 0;  i < allKeys.count; i++) {
        
        NSString *key = [allKeys objectAtIndex:i];
        
        LSDataModel *model = [_socketReqDic objectForKey:key];
        
        [model setDataServerConnectState:state];
        
        if ([model respondsToSelector:@selector(serverConnectStateChange:)]) {
            
            [model serverConnectStateChange:state];
        }
    }
    
}

-(void)userLoginEvent:(id)msg{

    NSDictionary *data = msg;
    
    int newState  = [[data objectForKey:@"loginType"] intValue];
    NSString *newName = [data objectForKey:@"loginName"];
    
    self.loginName = newName;
    self.loginType = newState;

    [self setLoginState:newState];

}

-(void)setLoginState:(NSInteger)state{
    
    NSArray *allKeys = [_socketReqDic allKeys];
    
    for (int i = 0;  i < allKeys.count; i++) {
        
        NSString *key = [allKeys objectAtIndex:i];
        
        LSDataModel *model = [_socketReqDic objectForKey:key];
        
        if ([model respondsToSelector:@selector(userLoginStateChange:)]) {
            
            [model userLoginStateChange:state];
        }
        
        if ([model respondsToSelector:@selector(setDataLoginName:)]) {
            
            [model setDataLoginName:self.loginName];
        }
    }
}

-(void)setMobileState:(NSInteger)state{
    
    NSArray *allKeys = [_socketReqDic allKeys];
    
    for (int i = 0;  i < allKeys.count; i++) {
        
        NSString *key = [allKeys objectAtIndex:i];
        
        LSDataModel *model = [_socketReqDic objectForKey:key];
        
        if ([model respondsToSelector:@selector(mobileNetworkChange:)]) {
            
            [model mobileNetworkChange:state];
        }
    }
}

-(void)languageChange:(id)msg{
    
    NSString *language = msg[LSData];
    self.language = language;
    
    NSArray *allKeys = [_socketReqDic allKeys];

    for (int i = 0;  i < allKeys.count; i++) {

        NSString *key = [allKeys objectAtIndex:i];

        LSDataModel *model = [_socketReqDic objectForKey:key];

        if ([model respondsToSelector:@selector(languageDataChange:)]) {

            [model languageDataChange:language];
        }
    }
}

/**处理UI界面的请求事件**/
-(void)doEvent:(NSDictionary*)dic{
    
    NSString *event = [dic objectForKey:LSEvent];
    
    NSDictionary *parameter = [dic objectForKey:LSParameter];
    NSString *requestSeq = [dic objectForKey:LSRequestSeq];

    if (requestSeq == nil) {
        
        NSLog(@"请求 %@ requestSeq %@ 为空!",event,requestSeq);
        return;
    }
   
    GWDataManagerLog(@"receive request event parameter : %@ %@",event,parameter);
    
    LSDataModel *dataModel = [self dataModelWithParameter:parameter
                                                    event:event
                                        requestIdentifire:requestSeq];
    
    
    
    if (dataModel) {

  
        [dataModel setDataRequestIdentifire:requestSeq];
        
        [dataModel setDataLoginType:self.loginType];
        [dataModel setDataLoginName:self.loginName];
        [dataModel setDataServerConnectState:self.serverConnectState];
        [dataModel setDataMobileNetState:self.mobileNetState];
        [dataModel setDataLanguage:self.language];
        
        if(![dataModel isListener]){
            [self setSocketRequestValue:dataModel key:requestSeq];
        }
        
        [dataModel startRun];

    }
}

//通过判断请求Key来判断来自同一个页面的请求是否已经存在
-(BOOL)requestIsExist:(NSString*)requestSeq{
    
    NSArray *allKeys = [_socketReqDic allKeys];
    
    if ([allKeys containsObject:requestSeq]) {
        
        return YES;
    }
    return NO;
}

-(void)removeRequestByClass:(Class)clss{
    
    pthread_mutex_lock(&lock);
    
    NSArray *allKeys = [_socketReqDic allKeys];
    
    for (int i = 0 ; i < allKeys.count; i++) {
        
        NSString *key = [allKeys objectAtIndex:i];
        LSDataModel *dataModel = [_socketReqDic objectForKey:key];
        
        if ([dataModel isKindOfClass:clss]) {
            [_socketReqDic removeObjectForKey:key];
        }
        
    }
    pthread_mutex_unlock(&lock);
}

-(void)removeRequestByKey:(NSString*)requestKey{
    
    pthread_mutex_lock(&lock);
    [self.socketReqDic removeObjectForKey:requestKey];
    pthread_mutex_unlock(&lock);
    
}

-(LSDataModel*)findAExistRequest:(Class)classs{
    
    NSArray *keys = [_socketReqDic allKeys];
    
    for (NSString *key in keys) {
        
        LSDataModel *dataModel = [_socketReqDic objectForKey:key];
        
        if ([dataModel isKindOfClass:classs]) {
            
            return dataModel;
        }
    }
    
    return nil;
}


-(NSString*)pluginDataEvent{
    
    return nil;
}

-(NSString*)mobileNetworkingEvent{
    
    return nil;
}

-(NSString*)serverConnectEvent{
    
    return nil;
}

-(NSString*)loginEvent{
    
    return nil;
}

-(NSString*)languageEvent{
    
    return nil;
}

-(LSDataModel*)dataModelWithParameter:(id)parameter event:(NSString*)event requestIdentifire:(NSString*)requestIdentifire{
    
    
    return nil;
}



@end
