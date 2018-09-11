//
//  LSDataModel.m
//  LSKit
//
//  Created by Lyson on 2018/2/7.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import "LSDataModel.h"
#import "LSMQMessageListManager.h"
#import <YYKit/YYThreadSafeDictionary.h>

@interface LSDataModel()<LSMQTopicReceiveProtocol>

@property (nonatomic , strong) YYThreadSafeDictionary *responseHeadFieldsDic;
@property (nonatomic , strong) YYThreadSafeDictionary *requestHeadFieldsDic;

@property (nonatomic , strong) LSDataComplete completeBlock;

@end

@implementation LSDataModel

#define LSDataModelDefaultTimeOutCount 30

+(instancetype)initDataModelWithParameter:(id)parameter
                               requestSeq:(NSString*)requestIdentifire
                                 complete:(LSDataComplete)complete{
    
    LSDataModel *instance = [[self alloc] initWithParameter:parameter complete:complete];
    [instance setDataRequestIdentifire:requestIdentifire];
    
    return instance;
}

-(instancetype)initWithParameter:(id)parameter complete:(LSDataComplete)complete{
    
    if (self = [super init]) {
        
        self.completeBlock = complete;
        _parameter = parameter;
    
        [self requestInitEvent];
        [self initData];
        [self addTopic];
        [self receiveParameter:parameter];
    }
    
    return self;
}

-(void)initData{
    
    _responseHeadFieldsDic = [YYThreadSafeDictionary dictionaryWithCapacity:0];
    _requestHeadFieldsDic = [YYThreadSafeDictionary dictionaryWithCapacity:0];
    _serverConnectState = -1;
    self.language = @"-1";
    _loginType = 0;
    _mobileNetState = -1;
    _parameterIsOk = YES;
    
}


-(void)addTopic{
    NSArray *topics = [self listenerRemoteEvent];
    
    for (NSString *topic in topics) {
        
        [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:topic];
    }
}

-(void)setDataRequestIdentifire:(NSString *)requestIdentifire{
    
    _requestIdentifire = requestIdentifire;
    
    [self.responseHeadFieldsDic setValue:_requestIdentifire forKey:@"requestIdentifire"];
}

-(void)setDataMobileNetState:(NSInteger)mobileNetState{
    
    _mobileNetState = mobileNetState;
}

-(void)setDataLoginType:(NSInteger)loginType{
    
    _loginType = loginType;
}

-(void)setDataParameterIsOk:(BOOL)isOk{
    
    _parameterIsOk = isOk;
}

-(void)setDataLoginName:(NSString*)loginName{
    
    _loginName = loginName;
}

-(void)setDataIsReponse:(BOOL)isR{
   
    _isResponse = isR;
}

-(void)setDataLanguage:(NSString*)language{
    
    _language = language;
}

-(void)setDataServerConnectState:(NSInteger)serverConnectState{
    
    _serverConnectState = serverConnectState;
}


-(void)mobileNetworkChange:(NSInteger)state{
    
    [self setDataMobileNetState:state];
    
    if (![self connectChangeRunCheck]) {
        [self dataComplete];
    }
}

-(void)serverConnectStateChange:(NSInteger)state{

    if (![self connectChangeRunCheck]) {
        [self dataComplete];
    }
}

-(void)userLoginStateChange:(NSInteger)state{
    
    if([self respondsToSelector:@selector(cacheDataClearTask)]){
        
        [self cacheDataClearTask];
        
    }

    [self setDataLoginType:state];
    
    if (![self connectChangeRunCheck]) {
        [self dataComplete];
    }
}

-(void)languageDataChange:(NSString*)language{
    
    _language = language;
}

/**启动超时计时**/
-(void)startTimeCount{

    [self cancelTimeCount];
    
    [self performSelector:@selector(dataTimeOutTask) withObject:nil afterDelay:[self timeOutCount]];
}

/**取消超时计时**/
-(void)cancelTimeCount{


//    <LSMessageQueue: 0x6080000e4480>{number = 3, name = LSMessageQueue<LSMessageQueue: 0x6080000e4480>{number = 3, name = com.gw.msgQueue}}
//
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

-(void)cancelTimeCountTas{
    
}

-(void)startRun{
   
    [self setDataIsReponse:NO];
    
    BOOL run = [self runCheck];
    
    
    if (!run) {
        return;
    }
    
    [self startTimeCount];
    
    [self willRunTask];
    
    if ([self listenerRemoteEvent].count <= 0) {
        [self noRemoteResponseTask];
    }
}


-(BOOL)connectChangeRunCheck{
    
    if (_isResponse) {
        return YES;
    }
    
    if ([self localOrRemote]) {
        return YES;
    }else if(![self mobileNet]){
        //无网
        [self noMobileNetWorkTask];
        return NO;
    }else if(![self serverConnect]){
        //服务器无连接
        [self noServerConnectTask];
        return NO;
    }else if(![self userAutho]){
        //无权限
        [self noAuthorizationTask];
        return NO;
    }
    
    return YES;
}

-(BOOL)runCheck{
    
    
    if(!self.parameterIsOk){
        [self parameterDataTask];
        return NO;
    }else if ([self localOrRemote]) {
        
        [self localDataTask];
        
        return NO;
        
    }else if(![self mobileNet]){
        //无网
        [self noMobileNetWorkTask];
        
        return NO;
    }else if(![self serverConnect]){
        //服务器无连接
        [self noServerConnectTask];
        
        return NO;
    }else if(![self userAutho]){
        //无权限
        [self noAuthorizationTask];
        
        return NO;
    }else if([self isListener] && [self requestWaitingTask]){
        [self localDataTask];
        return NO;
    }else if([self isListener] && ![self requestWaitingTask]){
        [self startTimeCount];
        return NO;
    }
    
    
    return YES;
}

-(void)startReponse:(id)data stateCode:(LSDataModelReponseState)stateCode msg:(NSString*)msg{
  
    NSString *event = [self responseEvent];
  
    [self dataComplete];
    
    if ([self isEmpty:event]) {
        NSLog(@"无回调事件,丢弃");
        return ;
    }
    
    NSDictionary *headField = _responseHeadFieldsDic;
    
    BOOL res = [self startReponse:data event:event headField:headField stateCode:stateCode msg:msg];
    [self setDataIsReponse:res];
    
}


-(BOOL)startReponse:(id)data event:(NSString*)event headField:(NSDictionary*)headField stateCode:(LSDataModelReponseState)stateCode msg:(NSString*)msg{
    
    return [LSDataResponse responsePackege:data statusCode:stateCode headCodes:headField msg:msg event:event];
}

-(void)startReponse:(id)data stateCode:(LSDataModelReponseState)stateCode msg:(NSString*)msg cache:(BOOL)cache{
    
    NSString *event = [self responseEvent];
    
    [self dataComplete];
    
    if ([self isEmpty:event]) {
        NSLog(@"无回调事件,丢弃");
        return ;
    }
    
    NSDictionary *headField = _responseHeadFieldsDic;
    
    _isResponse = [self startReponse:data event:event headField:headField stateCode:stateCode msg:msg cache:cache];
}


-(BOOL)startReponse:(id)data event:(NSString*)event headField:(NSDictionary*)headField stateCode:(LSDataModelReponseState)stateCode msg:(NSString*)msg cache:(BOOL)cache{
    
    return [LSDataResponse responsePackege:data statusCode:stateCode headCodes:headField msg:msg event:event level:0 cache:cache];
}

//LSDataModelUserLoginState_Null
#pragma mark -tools

-(BOOL)isEmpty:(NSString*)value{
    
    if (value == nil || [value isKindOfClass:[NSNull class]] || value.length <= 0 ) {
        return YES;
    }
    
    return NO;
}

-(void)dataComplete{
    
    [self cancelTimeCount];
    
    if (self.completeBlock) {
        self.completeBlock(self.requestIdentifire, nil);
    }
}

#pragma mark -

-(void)requestInitEvent{
    
    
}

-(NSData *)receiveParameter:(id)parameter{
    
    return nil;
}

-(void)noMobileNetWorkTask{
    
    [self startReponse:nil stateCode:LSDataModelReponseState_NoNetwork msg:@"网络连接失败，请检查网络设置!"];
}

-(void)parameterDataTask{
    
    [self startReponse:nil stateCode:LSDataModelReponseState_Fail msg:@"参数不合法!"];
}

-(void)dataTimeOutTask{
    
    [self startReponse:nil stateCode:LSDataModelReponseState_TimeOut msg:@"请求超时!"];
}

-(void)noAuthorizationTask{
   
    [self startReponse:nil stateCode:LSDataModelReponseState_NoAutho msg:@"无权限!"];
}

-(void)noServerConnectTask{
  
    [self startReponse:nil stateCode:LSDataModelReponseState_NoServer msg:@"服务器无连接!"];
}

-(void)noRemoteResponseTask{
    
    [self dataComplete];
}

-(void)localDataTask{
    
    
}

-(void)cacheDataIsOkTask{
    
    
}

-(void)willRunTask{
    
    
}

-(NSString*)responseEvent{
    
    return nil;
}


-(NSArray*)listenerRemoteEvent{
    
    return nil;
}


-(BOOL)mobileNet{
    
    return YES;
}

-(BOOL)serverConnect{
    
    return YES;
}

-(BOOL)userAutho{

    return YES;
}

-(BOOL)localOrRemote{
    
    return NO;
}

-(BOOL)isListener{
    
    return NO;
}

-(BOOL)requestWaitingTask{
    
    return YES;
}


-(NSInteger)timeOutCount{
    
    return LSDataModelDefaultTimeOutCount;
}

-(void)cacheDataChanged{
   
    if ([self requestWaitingTask]) {        
        [self localDataTask];
    }
}

-(void)receiveData:(id)msg topic:(NSString*)topic{
    
    
}

-(void)response:(id)data topic:(NSString*)topic{
    
    
}

- (void)cacheDataClearTask {
    
    
}


#pragma mark - msg
-(void)topicReceive:(id)msg topic:(NSString*)topic{
  
    if ([self isInListener:topic]) {
    
        [self receiveData:msg topic:topic];
    }else{
        
        NSLog(@"%@ 监听到未监听消息 %@",[self description] , topic);
    }
}


-(BOOL)isInListener:(NSString*)topic{
    
    NSArray *lis = [self listenerRemoteEvent];
    
    for(NSString* key in lis){
        
        if ([key isKindOfClass:[NSString class]]&& [key isEqualToString:topic]) {
            return YES;
        }
    }
    
    return NO;
}

@end
