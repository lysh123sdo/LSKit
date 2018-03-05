//
//  LSMessageModel.h
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/26.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMessageModel : NSObject

@property (nonatomic , strong) NSString *topic;
@property (nonatomic , strong) NSString *msg;
@property (nonatomic , assign) NSInteger level;

@end
