//
//  LSRouterFliter.m
//  GWBaseLib
//
//  Created by Lyson on 2018/7/17.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import "LSRouterFliter.h"

#import "LSRouter.h"


@interface LSRouter()

-(void)openControllerByParameters:(LSRouterParams*)param;

-(void)releaseFilter;

@end

@interface LSRouterFliter()


@end

@implementation LSRouterFliter

-(BOOL)routerInterception{
    
    return NO;
}

-(NSDictionary*)routerFilterParameter{
    
    return nil;
}

-(BOOL)routerRedirect{
    
    return NO;
}


-(void)routerRedirectTask{
    
    
}

-(void)routerInterceptionTask{
    
}

-(void)filterComplete{
    
    [[LSRouter sharedRouter] releaseFilter];
}


-(void)redirectFail{
    
    [self filterComplete];
}

-(void)redirectSuccess{

    [self filterComplete];
    
    NSString *url = self.parameter.routerUrl;
    BOOL animated = self.parameter.animated;
    NSDictionary *extraParams = self.parameter.extraParams;
    LSRouterOpenCallback callBack = self.parameter.routerOptions.callback;
    
    [[LSRouter sharedRouter] open:url animated:animated extraParams:extraParams toCallback:callBack];
    
}

@end

