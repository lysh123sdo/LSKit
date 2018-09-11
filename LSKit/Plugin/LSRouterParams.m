//
//  LSRouterParams.m
//  GWBaseLib
//
//  Created by Lyson on 2018/7/17.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import "LSRouterParams.h"
#import "LSRouterOptions.h"

@implementation LSRouterParams

- (instancetype)initWithRouterOptions: (LSRouterOptions *)routerOptions openParams: (NSDictionary *)openParams extraParams: (NSDictionary *)extraParams{
    [self setRouterOptions:routerOptions];
    [self setExtraParams: extraParams];
    [self setOpenParams:openParams];
    return self;
}

- (NSDictionary *)controllerParams {
    NSMutableDictionary *controllerParams = [NSMutableDictionary dictionaryWithDictionary:self.routerOptions.defaultParams];
    [controllerParams addEntriesFromDictionary:self.extraParams];
    [controllerParams addEntriesFromDictionary:self.openParams];
    return controllerParams;
}

- (NSDictionary *)getControllerParams {
    return [self controllerParams];
}

@end
