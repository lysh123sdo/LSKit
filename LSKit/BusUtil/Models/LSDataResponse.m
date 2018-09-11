//
//  TDDataResponse.m
//  TradeData
//
//  Created by Lyson on 2018/1/12.
//  Copyright © 2018年 TradeData. All rights reserved.
//

#import "LSDataResponse.h"
#import "LSMQMessageListManager.h"
#import <objc/runtime.h>
#import <LSKit/LSKit.h>
@implementation LSDataResponse


/**数据回调打包**/
+(BOOL)responsePackege:(id)data statusCode:(NSInteger)statusCode headCodes:(NSDictionary*)headCodes msg:(NSString*)msg event:(NSString*)event{
    
    int uRet = [[headCodes objectForKey:@"uRet"] intValue];
    NSString *identifire = [headCodes objectForKey:@"requestIdentifire"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSNumber *uR = [NSNumber numberWithInt:uRet];
    
    [dic setValue:identifire forKey:@"RequestSeq"];
    [dic setValue:data forKey:@"data"];
    [dic setValue:@(statusCode) forKey:@"code"];
    [dic setValue:msg forKey:@"msg"];
    [dic setValue:uR forKey:@"uRet"];
    
    LSLogDebug(@"start response data : %@ %@",event,data);
    
    [[LSMQMessageListManager shareInstance] addMsg:dic topic:event];
    
    return YES;
}

+(BOOL)responsePackege:(id)data statusCode:(NSInteger)statusCode headCodes:(NSDictionary*)headCodes msg:(NSString*)msg event:(NSString*)event level:(int)level cache:(BOOL)cache{
    
    int uRet = [[headCodes objectForKey:@"uRet"] intValue];
    NSString *identifire = [headCodes objectForKey:@"requestIdentifire"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSNumber *uR = [NSNumber numberWithInt:uRet];
    
    [dic setValue:identifire forKey:@"RequestSeq"];
    [dic setValue:data forKey:@"data"];
    [dic setValue:@(statusCode) forKey:@"code"];
    [dic setValue:msg forKey:@"msg"];
    [dic setValue:uR forKey:@"uRet"];
    
    LSLogDebug(@"start response data : %@ %@",event,data);
    
    [[LSMQMessageListManager shareInstance] addMsg:dic topic:event level:level cache:cache];
    
    return YES;
}


/**获取一个类的属性值**/
+(NSArray*)keysOfClass:(Class)cls{
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:0];
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    
    for (int i = 0 ; i < count; i++) {
        
        const char *propertyName = property_getName(properties[i]);
        
        NSString *str = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        
        [keys addObject:str];
    }
    
    free(properties);
    
    return keys;
}


+(NSDictionary*)infosFromObj:(id)data keys:(NSArray*)keys{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [keys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *value = [data valueForKey:obj];
        [dic setValue:value forKey:obj];
    }];
    return dic;
}

@end
