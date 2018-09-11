//
//  LSRequestFliter.m
//  GWBaseLib
//
//  Created by Lyson on 2018/8/10.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import "LSRequestFliter.h"
#import "LSApiEngine.h"

@implementation LSRequestFliter

///过滤拦截
-(BOOL)filterInterception:(LSRequestStatusModel*)statusModel engine:(LSApiEngine*)engine{
    
    return NO;
}

///过滤添加
-(NSDictionary*)filterAddParameter:(LSRequestStatusModel*)statusModel engine:(LSApiEngine*)engine{
    
    return nil;
}

///过滤重定向
-(BOOL)fliterRedirection:(LSRequestStatusModel*)statusModel engine:(LSApiEngine*)engine{
    
    return NO;
}

@end
