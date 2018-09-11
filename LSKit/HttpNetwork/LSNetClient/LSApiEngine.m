//
//  GTAApiEngine.m
//  GTANetProject
//
//  Created by Lyson on 16/3/17.
//  Copyright © 2016年 GTANetProject. All rights reserved.
//

#import "LSApiEngine.h"

@interface LSApiEngine()
@property (nonatomic , strong ) NSDictionary *parameters;

@end

@implementation LSApiEngine

#define TIMEOUT 8


-(instancetype)init{
    
    if (self = [super init]) {
        _httpHeaders = [[NSMutableDictionary alloc] initWithCapacity:0];
        _headers = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [self initEvent];
    }
    return self;
}

-(instancetype)initWithUrl:(NSString*)url parameters:(NSDictionary*)parameters files:(NSArray*)files{

    if (self = [super init]) {
        
        _api = [url copy];
        _userInfo = [_api copy];
        _files = [files copy];
        _httpHeaders = [[NSMutableDictionary alloc] initWithCapacity:0];
        _headers = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.parameters = parameters;
        
        if (![LSApiEngine isEmpty:self.host]) {
          _url = [NSString stringWithFormat:@"%@%@",self.host,self.api];
        }else{
            _url =  self.api;
        }
        
        [self initEvent];
    }

    return self;
}

-(void)setUrl:(NSString*)url parameters:(NSDictionary*)parameters files:(NSArray*)files{

    _api = [url copy];
    _userInfo = [_api copy];
    _files = [files copy];
    self.parameters = parameters;
    
    if (![LSApiEngine isEmpty:self.host]) {
        _url = [NSString stringWithFormat:@"%@%@",self.host,self.api];
    }else{
        _url =  self.api;
    }
}

-(void)addHttpHeader:(NSString*)header key:(NSString*)key{
    
    [_headers setValue:header forKey:key];
}

-(NSMutableDictionary *)httpHeaders{

    NSDictionary *header = [self encryHeader:self.headers];
    
    if (header) {
        [_httpHeaders addEntriesFromDictionary:header];
    }
    
    return _httpHeaders;
}

-(NSDictionary*)postBody{
    
    NSDictionary *encyBody =[self encryBody:_parameters];
    
    if (encyBody) {
        
        _parameters = encyBody;
    }
    
    NSDictionary *unicodeBody =[self unicodeBody:_parameters];
    
    if (unicodeBody) {
        
        _parameters = unicodeBody;
    }
    
    DLog(@"\n<<-----------请求-------------------\n Url == %@\n  DicStyle == %@\n------------------------------->>",self.url,_parameters);
    
    return _parameters;
}

-(NSString*)host{
    
    
    return nil;
}

-(NSDictionary*)encryHeader:(NSDictionary*)header{
    
    return nil;
}

-(NSDictionary*)encryBody:(NSDictionary*)body{


    return nil;
}

-(NSDictionary*)unicodeBody:(NSDictionary*)body{
    
    
    return nil;
}


- (NSTimeInterval)requestTimeoutInterval {
    return TIMEOUT;
}

+(BOOL)isEmpty:(NSString*)text{
    
    if ([text isKindOfClass:[NSNull class]] || text == nil  || text.length <=0) {
        
        return YES;
    }
    
    return NO;
}

-(void)initEvent{
    
}


-(void)dealloc{

    DLog(@"%@释放了",NSStringFromClass([self class]));

}
@end
