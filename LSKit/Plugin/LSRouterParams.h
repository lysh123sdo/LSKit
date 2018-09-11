//
//  LSRouterParams.h
//  GWBaseLib
//
//  Created by Lyson on 2018/7/17.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSRouterOptions;

@interface LSRouterParams : NSObject

@property (readwrite, nonatomic, strong) LSRouterOptions *routerOptions;
@property (readwrite, nonatomic, strong) NSDictionary *openParams;
@property (readwrite, nonatomic, strong) NSDictionary *extraParams;
@property (readwrite, nonatomic, strong) NSDictionary *controllerParams;
@property (readwrite, nonatomic, strong) NSString *routerUrl;
@property (readwrite, nonatomic, assign) BOOL animated;
- (instancetype)initWithRouterOptions: (LSRouterOptions *)routerOptions openParams: (NSDictionary *)openParams extraParams: (NSDictionary *)extraParams;

@end
