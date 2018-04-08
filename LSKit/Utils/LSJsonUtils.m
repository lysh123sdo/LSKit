//
//  LSJsonUtils.m
//  GWBaseLib
//
//  Created by Lyson on 2018/2/27.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import "LSJsonUtils.h"

@implementation LSJsonUtils


+(id)jsonToObj:(NSData*)data{
    
    NSError *error ;
    NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    return result;
}

+(id)objToJson:(id)data{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                         error:nil];
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    return string;
}

@end
