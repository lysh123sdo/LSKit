//
//  LSRequestFliter.h
//  GWBaseLib
//
//  Created by Lyson on 2018/8/10.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSApiEngine;
@class LSRequestStatusModel;

///解析结果过滤器
@interface LSRequestFliter : NSObject

///过滤拦截
-(BOOL)filterInterception:(LSRequestStatusModel*)statusModel engine:(LSApiEngine*)engine;

///过滤添加
-(NSDictionary*)filterAddParameter:(LSRequestStatusModel*)statusModel engine:(LSApiEngine*)engine;

///过滤重定向
-(BOOL)fliterRedirection:(LSRequestStatusModel*)statusModel engine:(LSApiEngine*)engine;

@end
