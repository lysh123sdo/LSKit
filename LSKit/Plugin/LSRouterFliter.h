//
//  LSRouterFliter.h
//  GWBaseLib
//
//  Created by Lyson on 2018/7/17.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSRouter.h"
#import "LSRouterParams.h"

/// 路由过滤器用来跳转前或者跳转后的逻辑处理
@interface LSRouterFliter : NSObject

@property (nonatomic , strong) LSRouterParams *parameter;

-(BOOL)routerInterception;

-(void)routerRedirectTask;

-(void)routerInterceptionTask;

-(BOOL)routerRedirect;

-(NSDictionary*)routerFilterParameter;

-(void)redirectSuccess;

-(void)redirectFail;

@end
