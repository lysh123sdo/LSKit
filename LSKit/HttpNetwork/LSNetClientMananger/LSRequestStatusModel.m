//
//  LSRequestStatusModel.m
//  GTANetProject
//
//  Created by Lyson on 16/3/16.
//  Copyright © 2016年 GTANetProject. All rights reserved.
//

#import "LSRequestStatusModel.h"
#import <JTObjectMapping/NSObject+JTObjectMapping.h>
#import <AFNetworking/AFNetworking.h>
#import "LSApiEngine.h"
@implementation LSRequestStatusModel

/*********获取data字段对应的json key值映射************/
-(NSString*)getCodeKey{

    return @"data";
}

/*********获取code字段对应的json key值映射************/
-(NSString*)getDataKey{
    
    return @"code";
}

/*********获取msg字段对应的json key值映射************/
-(NSString*)getMsgKey{
    
    return @"msg";
}

/// 解析返回数据
-(id)statusModel:(id)target data:(id)data mapping:(NSDictionary*)mapping{

    LSRequestStatusModel *model = [[self class] objectFromJSONObject:data mapping:[self getMapping:target mapping:mapping]];

    return model;
}

-(NSDictionary*)getMapping:(id)target mapping:(NSDictionary*)mapping{

    return [NSDictionary dictionaryWithObjectsAndKeys:[[target class] mappingWithKey:@"data" mapping:mapping],[self getCodeKey],@"code",[self getCodeKey],@"msg",[self getMsgKey],nil];
}

/// 解析错误提示
-(void)statusModelWithError:(NSError*)error{

    self.errorCode = [self codeSwitch:[self statusCodeWithError:error]];
    self.msg = [self msgByCode:self.errorCode];
    self.code = LSRequestError;

}

/// 获取状态码
-(int)statusCodeWithError:(NSError*)error{

    NSHTTPURLResponse *response;
    
    NSDictionary *errors = [error userInfo];
    
    if ([errors objectForKey:NSUnderlyingErrorKey]) {
        
        response = [[[errors objectForKey:NSUnderlyingErrorKey] userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
        [errors objectForKey:@"_kCFStreamErrorCodeKey"];
        if (response==nil) {
            return LSError_BadNet;
        }
        
    }else {
        
        response = (NSHTTPURLResponse*)[error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
    }
    
    return (int)response.statusCode;
}

/// 错误提示
-(NSString*)msgByCode:(NSInteger)code{

    NSString *msg = @"";
    switch (code) {
        case LSError_404:
            msg = @"访问路径不存在";
            break;
        case LSError_401:
            msg = @"无权限访问";
            break;
        case LSError_500:
            msg = @"服务器内部错误";
            break;
        case LSError_BadNet:
            msg = @"网络连接错误";
            break;
        default:
            break;
    }

    return msg;
}

/// 解析code
-(NSInteger)codeSwitch:(NSInteger)code{

    //TODO: code值暂时未知先设定为默认的
    NSInteger errorCode = code;

    return errorCode;
}

-(void)dealloc{
    
    DLog(@"%@释放了",NSStringFromClass([self class]));
    
}
@end
